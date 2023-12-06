// deno-lint-ignore-file no-explicit-any

export type IterateElementInfo = {
  path: (string | number)[];
  value: any;
};
export type IterateNestedObjCallback = (
  args: IterateElementInfo,
) => void;

export type IterateNestedObjArgs = {
  obj: any;
  callback: IterateNestedObjCallback;
  leafsOnly?: boolean;
};

/** https://stackoverflow.com/a/54272512/1760643 */
export const iterateNestedObj = (
  { obj, callback, leafsOnly }: IterateNestedObjArgs,
) => {
  const rootElementInfo = { value: obj, path: [] };

  /** stack has only objects */
  const objectsInfoToProcess: IterateElementInfo[] = [rootElementInfo];

  if (!leafsOnly) {
    callback(rootElementInfo);
  }

  while (objectsInfoToProcess?.length > 0) {
    const currentObjectElementInfo = objectsInfoToProcess.pop();

    if (currentObjectElementInfo) {
      const { path: objectPath, value: objectValue } = currentObjectElementInfo;

      Object.keys(objectValue).forEach((key) => {
        let newValueIsObject = false;
        const value = objectValue[key];
        const path = [...objectPath, key];

        if (typeof value === 'object' && value !== null) {
          newValueIsObject = true;
        }

        const elementInfo = { value, path };

        if (newValueIsObject) {
          objectsInfoToProcess.push(elementInfo);
        }

        if (!leafsOnly || !newValueIsObject) {
          callback(elementInfo);
        }
      });
    }
  }
};
