import type { Signer } from "@ethersproject/abstract-signer";
import { artifacts, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";

import { PRBMathSD59x18Mock } from "../../src/types/PRBMathSD59x18Mock";
import { PRBMathUD60x18Mock } from "../../src/types/PRBMathUD60x18Mock";

type UnitFixturePRBMathSd59x18ReturnType = {
  prbMathSd59x18: PRBMathSD59x18Mock;
};

export async function unitFixturePRBMathSd59x18(signers: Signer[]): Promise<UnitFixturePRBMathSd59x18ReturnType> {
  const deployer: Signer = signers[0];

  const prbMathSd59x18Artifact: Artifact = await artifacts.readArtifact("PRBMathSD59x18Mock");
  const prbMathSd59x18: PRBMathSD59x18Mock = <PRBMathSD59x18Mock>(
    await waffle.deployContract(deployer, prbMathSd59x18Artifact, [])
  );

  return { prbMathSd59x18 };
}

type UnitFixturePRBMathUd60x18ReturnType = {
  prbMathUd60x18: PRBMathUD60x18Mock;
};

export async function unitFixturePRBMathUd60x18(signers: Signer[]): Promise<UnitFixturePRBMathUd60x18ReturnType> {
  const deployer: Signer = signers[0];

  const prbMathUd60x18Artifact: Artifact = await artifacts.readArtifact("PRBMathUD60x18Mock");
  const prbMathUd60x18: PRBMathUD60x18Mock = <PRBMathUD60x18Mock>(
    await waffle.deployContract(deployer, prbMathUd60x18Artifact, [])
  );

  return { prbMathUd60x18 };
}
