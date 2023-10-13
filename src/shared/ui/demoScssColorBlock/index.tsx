import styles from "./style.scss.d.ts";
import { WithChildren } from "/~/shared/react/WithChildren.tsx";

console.log(styles);

export const DemoScssColorBlock = ({children}: WithChildren) => {
    return (
        <div>
            <h2>Scss colored block</h2>
            {children}
        </div>
    );
}