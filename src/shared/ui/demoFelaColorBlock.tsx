// import { styled } from "@compiled/react";

import { useFela } from "react-fela";

import { ReactNode } from "react";
// import { WithChildren } from "/~/shared/react/WithChildren.tsx";

// export const ColoredBlockInner = styled.div`
//   background-color: #ff5630;
// `;


interface WithChildren {
  children?: ReactNode;
  someBaseProp: string;
}

// export type DemoFelaColorBlockProps = WithChildren & {
//   borderColor?: string;
// }

interface DemoFelaColorBlockProps extends WithChildren {
  borderColor?: string;
}


// interface WithChildren {
//   children: ReactNode;
// }

// export type DemoFelaColorBlockProps = {
//   borderColor?: string;
//   children?: ReactNode;
// }

export const DemoFelaColorBlock = ({
  borderColor,
  children,
  someBaseProp,
}: DemoFelaColorBlockProps) => {
    const { css } = useFela()
    console.log(someBaseProp);
    // const css = (props:any) => '';

    return (
        <div className={`demo-fela-color-block ${css({
            /** @See [Fela shorthand expand with merge SSR · Issue #789 · robinweser/fela](https://github.com/robinweser/fela/issues/789)
             * Prop `className` did not match (client/server)
             * */
            // backgroundColor: '#ff5630',
            border: borderColor ? `1 px solid ${borderColor}` : undefined,
            background: '#ff5630',
            display: 'flex',
            padding: 4,
            paddingBottom: 20,
            marginBottom: 12,
            flexDirection: 'column',
            // invalidKey: 'invalidValue',
            ':hover': {
              background: 'green',
              foo: {
                  background: 'blue'
              }
            },
            // 'nested': {
            //   background: 'yellow'
            // },
        })}`}>
            <h2>Fela colored block</h2>
            {children}
            <div className={css({
                display: 'flex',
                justifyContent: 'center',
                "> *:not(:last-child)": {
                    marginRight: 24,
                  }
              })}>
              <div>1</div>
              <div>2</div>
              <div>3</div>
            </div>
        </div>
    );
}
