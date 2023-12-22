/**
 * See also
 * - [Babel plugin handbook](https://github.com/jamiebuilds/babel-handbook/blob/master/translations/en/plugin-handbook.md#traversal))
 * - [Feature: supabase gen schema json · Issue #1715 · supabase/cli](https://github.com/supabase/cli/issues/1715#issuecomment-1841671620)
 */
import * as fs from 'fs';
import { parse } from '@babel/parser';
import jsonLoose from 'json-loose';
import traverse, { Visitor } from '@babel/traverse';
import set from 'lodash/set';
import { config as dotEnvConfig } from 'dotenv';

dotEnvConfig();

import { BabelTraverseHelper } from '/~/shared/lib/node/babel/traverse-helper.ts';

import {
  DbFieldFkInfo,
  DbFieldInfo,
  DbStructure,
  SupabaseRelationInfo,
} from '/~/shared/api/supabase/json-schema.types.ts';

import { envValueRequire } from '/~/shared/lib/node/env';
import { json } from '/~/shared/lib/json';
import {
  DbFnsData,
  DbFnsSchema,
} from '/~/shared/api/supabase/json-db-functions.types';

const inputSupabaseGeneratedTypesPath = envValueRequire(
  'SUPABASE_GENERATED_TYPES_PATH',
);

const outputSupabaseRawParsedTypesPath = envValueRequire(
  'SUPABASE_RAW_PARSED_TYPES_PATH',
);
const outputSupabaseSchemaJsonPath = envValueRequire(
  'SUPABASE_SCHEMA_JSON_PATH',
);

const outputSupabaseFunctionsJsonPath = envValueRequire(
  'SUPABASE_FUNCTIONS_JSON_PATH',
);

const source = fs.readFileSync(inputSupabaseGeneratedTypesPath).toString();

const parsed = parse(source, {
  sourceType: 'module',
  plugins: [
    [
      'typescript',
      {},
    ],
  ],
});

// const getCode = <P extends Node,>(path: NodePath<P>) => {
//     const { node } = path;
//     const { start, end } = node;

//     if (start && end) {
//         return source.slice(start, end);
//     }
// }

const result: DbStructure = {};

const resultFunctions: DbFnsData = {};

const traverseHelperDbSchemas = new BabelTraverseHelper({ maxLevel: 1 });
const traverseHelperDbSchemaSections = new BabelTraverseHelper({ maxLevel: 1 });
const traverseHelperDbTables = new BabelTraverseHelper({ maxLevel: 1 });
const traverseHelperDbFns = new BabelTraverseHelper({ maxLevel: 1 });
const traverseHelperDbTablesSections = new BabelTraverseHelper({ maxLevel: 1 });
const traverseHelperDbTablesFields = new BabelTraverseHelper({ maxLevel: 1 });

let currentSchemaName = '';
let currentTableName = '';
let currentTableRelationsInfo: SupabaseRelationInfo[] = [];

const visitDbTablesFields: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;

    const fieldName = (node.key as any).name;

    const resultPath = [currentSchemaName, currentTableName, fieldName];

    const typeString = `${path.get('typeAnnotation.typeAnnotation')}`;

    const typeParts = typeString.split(/[ ]*\|[ ]*/g);

    traverseHelperDbTablesFields.process(path);

    const fieldInfo: DbFieldInfo = {
      name: fieldName,
      nullable: false,
      type: '',
    };

    typeParts.forEach((typePart) => {
      if (typePart === 'null') {
        fieldInfo.nullable = true;
      } else {
        fieldInfo.type = typePart;
      }
    });

    set(result, resultPath, fieldInfo);
  },
};

const visitDbTablesSections: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;

    const sectionName = (node.key as any).name;
    traverseHelperDbTablesSections.process(path);

    switch (sectionName) {
      case 'Row':
        traverseHelperDbTablesFields.reset();
        path.traverse(visitDbTablesFields);
        break;
      case 'Relationships':
        const relationsString = `${path.get('typeAnnotation.typeAnnotation')}`;
        const jsonEncodedRelationsBroken = relationsString.replace(/;$/gm, ',');
        const jsonEncodedRelations = jsonLoose(jsonEncodedRelationsBroken);
        currentTableRelationsInfo = JSON.parse(jsonEncodedRelations);
        break;
    }
  },
};

const visitDatabaseSchemasTables: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;

    currentTableName = (node.key as any).name;

    traverseHelperDbTables.process(path);

    const resultPath = [currentSchemaName, currentTableName];
    set(result, resultPath, {});

    currentTableRelationsInfo = [];
    traverseHelperDbTablesSections.reset();
    path.traverse(visitDbTablesSections);
    currentTableRelationsInfo.forEach((relationInfo) => {
      const {
        columns,
        foreignKeyName,
        isOneToOne,
        referencedColumns,
        referencedRelation,
      } = relationInfo;

      for (let i = 0; i < columns.length; i++) {
        const column = columns[i];
        const referencedColumn = referencedColumns[i];

        const fkResultPath = [
          currentSchemaName,
          currentTableName,
          column,
          'fkInfo',
        ];

        const fkInfo: DbFieldFkInfo = {
          foreignField: referencedColumn,
          fkName: foreignKeyName,
          isOneToOne,
          foreignTable: referencedRelation,
        };

        set(result, fkResultPath, fkInfo);
      }
    });
  },
};

const visitDatabaseSchemasFns: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;

    traverseHelperDbFns.process(path);

    const fnName = (node.key as any).name;

    const fnInfoString = `${path.get('typeAnnotation.typeAnnotation')}`;

    let fnInfo: DbFnsSchema | string = '';

    const jsonEncodedFnInfoBroken = fnInfoString.replace(
      /;$/gm,
      ',',
    ).replace(/(Record<[^>]*>)/gm, '"$1"')
      /** }[] */
      .replace(/[\s]*}\[\]/gm, '\n      __array: true\n    }')
      /** ?: */
      .replace(/\?:\s+(\w+)/gm, ': "null | $1"');

    let jsonEncodedFnInfo = '';

    try {
      jsonEncodedFnInfo = jsonLoose(
        jsonEncodedFnInfoBroken,
      );

      fnInfo = JSON.parse(
        jsonEncodedFnInfo,
      ) as DbFnsSchema;
    } catch (e) {
      console.error(
        'jsonEncodedFnInfoBroken:',
        jsonEncodedFnInfoBroken,
      );
      console.error('jsonEncodedFnInfo:', jsonEncodedFnInfo);
      fnInfo = jsonEncodedFnInfoBroken;
      // throw e;
    }
    set(resultFunctions, [currentSchemaName, fnName], fnInfo);
  },
};

const visitDatabaseSchemasSection: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;

    const name = (node.key as any).name;

    traverseHelperDbSchemaSections.process(path);

    if (name === 'Tables') {
      traverseHelperDbTables.reset();
      path.traverse(visitDatabaseSchemasTables);
    }
    if (name === 'Functions') {
      traverseHelperDbFns.reset();
      path.traverse(visitDatabaseSchemasFns);
    }
  },
};

const visitDatabaseSchemas: Visitor = {
  TSPropertySignature(path) {
    const { node } = path;
    currentSchemaName = (node.key as any).name;

    traverseHelperDbSchemas.process(path);

    if (currentSchemaName === 'graphql_public') {
      return;
    }

    result[currentSchemaName] = {};

    traverseHelperDbSchemaSections.reset();
    path.traverse(visitDatabaseSchemasSection);
  },
};

traverse(parsed, {
  TSInterfaceDeclaration(path) {
    const { node } = path;
    const { id: { name } } = node;
    if (name === 'Database') {
      traverseHelperDbSchemas.reset();
      path.traverse(visitDatabaseSchemas);
    }
  },
});

// console.log(
//   `Writing parsed raw types to "${outputSupabaseRawParsedTypesPath}"`,
// );

// fs.writeFileSync(
//   outputSupabaseRawParsedTypesPath,
//   json(parsed),
// );

console.log(`Writing schema to "${outputSupabaseSchemaJsonPath}"`);
fs.writeFileSync(
  outputSupabaseSchemaJsonPath,
  json(result),
);

console.log(`Writing functions info to "${outputSupabaseFunctionsJsonPath}"`);
fs.writeFileSync(
  outputSupabaseFunctionsJsonPath,
  json(resultFunctions),
);
