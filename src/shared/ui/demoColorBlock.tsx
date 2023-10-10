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

export const DemoColorBlock = ({children}: WithChildren) => {
    const { css } = useFela()
    // const css = (props:any) => '';

    return (
        <div className={css({
            backgroundColor: '#ff5630',
        })}>
            <h2>Colored block</h2>
            {children}
        </div>
    );
}