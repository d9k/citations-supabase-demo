export const ComposeProviders = ({providers, children = null}) => {
    const C = providers.reduce(
        (Aggr, providerData) => ({ children }) => {
            console.log(providerData);
            const [Provider, providerArgs = {}] = providerData;

            return (
                <Aggr>
                    <Provider {...providerArgs}>
                        {children}
                    </Provider>
                </Aggr>
            );
        },
        ({children}) => <>{children}</>
    );

    return <C>{children}</C>;
}
