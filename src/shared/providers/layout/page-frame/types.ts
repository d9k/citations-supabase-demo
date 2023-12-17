import React from 'react';

export type PageFrameComponentType = React.ElementType;
/** We can't store function in useState */
export type PageFrameComponentWrappedType = () => React.ElementType;
