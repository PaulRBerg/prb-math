import "./type-extensions";

import { extendEnvironment } from "hardhat/config";
import { lazyObject } from "hardhat/plugins";

import { HardhatPRBMath } from "./HardhatPRBMath";

extendEnvironment(hre => {
  hre.prb = hre.prb || {};

  // We use "lazyObject" to initialize things only when they are actually needed.
  hre.prb.math = lazyObject(function () {
    return new HardhatPRBMath();
  });
});
