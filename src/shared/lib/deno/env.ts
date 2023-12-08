import { isNil } from 'lodash';

export const envNameRequire = (envVariableName: string): string | null => {
  const envVarValue = Deno.env.get(envVariableName);
  if (typeof envVarValue === 'undefined') {
    throw Error(`.env: no variable with name "${envVariableName}"`);
  }
  return envVarValue;
};

export const envValueRequire = (
  envVariableName: string,
): string => {
  const envVarValue = Deno.env.get(envVariableName);
  if (isNil(envVarValue)) {
    throw Error(`.env: variable "${envVariableName}" doesn't have value`);
  }
  return envVarValue as string;
};

export const envGetNonRequired = (
  envVariableName: string,
): string | undefined | null => {
  return Deno.env.get(envVariableName);
};
