// import { styled } from "@compiled/react";

import { useFela } from "react-fela";

import { ReactNode } from "react";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

// export const ColoredBlockInner = styled.div`
//   background-color: #ff5630;
// `;

// export type ColoredBlockProps = {
//     children: ReactNode;
// }

export const DemoFelaColorBlock = ({children}: WithChildren) => {
    const { css } = useFela()
    // const css = (props:any) => '';

    return (
        <div className={css({
            /** @See [Fela shorthand expand with merge SSR · Issue #789 · robinweser/fela](https://github.com/robinweser/fela/issues/789)
             * Prop `className` did not match (client/server)
             * */
            // backgroundColor: '#ff5630',
            background: '#ff5630',
        })}>
            <h2>Fela colored block</h2>
            {children}
        </div>
    );
}
