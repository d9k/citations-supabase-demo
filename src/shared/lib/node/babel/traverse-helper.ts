import { Node, NodePath } from "@babel/traverse";
import { BaseNode } from "./BaseNode";

export type BabelParserTraverseHelperConstructorArgs = {
    maxLevel?: number;
}

export class BabelTraverseHelper {
    _pathToLevel: WeakMap<NodePath<BaseNode>, number>;
    maxLevel = 0;

    constructor(constructorArgs: BabelParserTraverseHelperConstructorArgs = {}) {
        this.reset();
        Object.assign(this, constructorArgs)
    }

    reset() {
        this._pathToLevel = new WeakMap();
    }

    process<N extends Node>(newPath: NodePath<N>) {
        const {maxLevel, _pathToLevel} = this;

        const newPathCasted = newPath as unknown as NodePath<BaseNode>;
        const newLevel = (_pathToLevel.get(newPathCasted) || 0) + 1;

        _pathToLevel.set(newPathCasted, newLevel);

        if (maxLevel && newLevel >= maxLevel) {
            newPath.skip();
        }
    }
}