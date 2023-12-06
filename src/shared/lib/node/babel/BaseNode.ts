import { Node, SourceLocation } from "@babel/types";

/* from node_modules/@babel/types/lib/index.d.ts */
export interface BaseNode {
    type: Node["type"];
    leadingComments?: Comment[] | null;
    innerComments?: Comment[] | null;
    trailingComments?: Comment[] | null;
    start?: number | null;
    end?: number | null;
    loc?: SourceLocation | null;
    range?: [number, number];
    extra?: Record<string, unknown>;
}