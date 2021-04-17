import hre from "hardhat";
import { Artifact } from "hardhat/types";

import { PRBMathUD60x18Mock } from "../../../typechain/PRBMathUD60x18Mock";
import { baseContext } from "../../contexts";
import { shouldBehaveLikePrbMathUd60x18 } from "./PRBMathUD60x18.behavior";

const { deployContract } = hre.waffle;

baseContext("Unit tests", function () {
  describe("PRBMathUD60x18", function () {
    beforeEach(async function () {
      const prbMathUD60x18MockArtifact: Artifact = await hre.artifacts.readArtifact("PRBMathUD60x18Mock");
      this.contracts.prbMathUD60x18 = <PRBMathUD60x18Mock>(
        await deployContract(this.signers.admin, prbMathUD60x18MockArtifact, [])
      );
    });

    shouldBehaveLikePrbMathUd60x18();
  });
});
