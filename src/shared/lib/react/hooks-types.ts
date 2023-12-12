type Dispatch<A> = (value: A) => void;
type SetStateAction<S> = S | ((prevState: S) => S);

// export type UseStateReturnType<T extends {} | null> = ReturnType<
// typeof useState<NonUndefined<T>>
// >;
// export type UseStateSetter<T extends {} | null> = UseStateReturnType<T>[1];
export type UseStateSetter<S> = Dispatch<SetStateAction<S>>;
