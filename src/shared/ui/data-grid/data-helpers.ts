export const VALUE_FALSE = 'no';
export const VALUE_TRUE = 'yes';
export const VALUE_UNDEFINED = '';

export function booleanToStringValue(v: boolean) {
  if (v === true) {
    return VALUE_TRUE;
  }
  if (v === false) {
    return VALUE_FALSE;
  }
  return VALUE_UNDEFINED;
}

export function stringValueToBoolean(v: string) {
  if (v === VALUE_TRUE) {
    return true;
  }
  if (v === VALUE_FALSE) {
    return false;
  }
  return undefined;
}
