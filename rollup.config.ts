import { nodeResolve } from "@rollup/plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import { terser } from "rollup-plugin-terser";

import pkg from "./package.json";

export default [
  {
    input: pkg.main,
    output: {
      exports: "named",
      file: "./dist/browser/prb-math.min.js",
      format: "iife",
      name: "PRBMath",
      sourcemap: false,
    },
    plugins: [
      nodeResolve({
        browser: true,
      }),
      commonjs({
        namedExports: { PRBMath: ["PRBMath"] },
      }),
      terser(),
    ],
  },
];
