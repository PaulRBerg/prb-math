import { expect } from "earljs";

import { HardhatPRBMath } from "../src/HardhatPRBMath";
import { useHardhatEnvironment } from "./shared/env";

describe("Hardhat Runtime Environment", function () {
  useHardhatEnvironment();

  it('should add "prb.math"', function () {
    expect(this.hre.prb.math).toBeA(HardhatPRBMath);
  });
});
