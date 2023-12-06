import isNil from 'lodash/isNil';

export const envNameRequire = (envVariableName: string): string => {
  const envVarValue = process.env[envVariableName];
  if (typeof envVarValue === 'undefined') {
    throw Error(`.env: no variable with name "${envVariableName}"`);
  }
  return envVarValue;
};

export const envValueRequire = (envVariableName: string): string => {
  const envVarValue = process.env[envVariableName];
  if (isNil(envVarValue)) {
    throw Error(`.env: variable "${envVariableName}" doesn't have value`);
  }
  return envVarValue;
};
