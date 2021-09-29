import "hardhat/types/runtime";

import type { HardhatPRBMath } from "./HardhatPRBMath";
declare module "hardhat/types/runtime" {
  export interface HardhatRuntimeEnvironment {
    prb: {
      math: HardhatPRBMath;
    };
  }
}
