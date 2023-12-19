export type SupabaseRelationInfo = {
  columns: string[];
  foreignKeyName: string;
  isOneToOne: boolean;
  referencedColumns: string[];
  referencedRelation: string;
};

export type DbFieldFkInfo = {
  fkName: string;
  foreignSchema?: string;
  foreignTable: string;
  foreignField: string;
  isOneToOne: boolean;
};

export type DbFieldInfo = {
  description?: string;
  name: string;
  type: string;
  nullable: boolean;
  fkInfo?: DbFieldFkInfo;
};

export type DbTable = {
  [fieldName: string]: DbFieldInfo;
};

export type DbSchema = { [tableName: string]: DbTable };
export type DbStructure = { [schemaName: string]: DbSchema };
