import { continueFromInitialStream } from "ultra/lib/stream.ts";
import React from "react";

export type Spinner = {
  active?: boolean;
}

export default function Spinner({ active = true }: Spinner) {
  console.log('Spinner log');
  return (
    <div
      className={["spinner", active && "spinner--active"].join(" ")}
      role="progressbar"
      aria-busy={active ? "true" : "false"}
    />
  );
}
