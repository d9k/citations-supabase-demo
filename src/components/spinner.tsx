import React from "react";

export type Spinner = {
  active: boolean;
}

export default function Spinner({ active = true }: Spinner) {
  return (
    <div
      className={["spinner", active && "spinner--active"].join(" ")}
      role="progressbar"
      aria-busy={active ? "true" : "false"}
    />
  );
}
