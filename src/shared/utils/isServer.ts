export const isServer = (): boolean => {
    // deno-lint-ignore no-explicit-any
    return (window as any).isServer;
}