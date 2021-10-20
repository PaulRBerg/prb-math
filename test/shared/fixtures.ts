import type { Signer } from "@ethersproject/abstract-signer";
import { artifacts, waffle } from "hardhat";
import type { Artifact } from "hardhat/types";

import { PRBMathSD59x18Mock } from "../../src/types/PRBMathSD59x18Mock";
import { PRBMathSD59x18TypedMock } from "../../src/types/PRBMathSD59x18TypedMock";
import { PRBMathUD60x18Mock } from "../../src/types/PRBMathUD60x18Mock";
import { PRBMathUD60x18TypedMock } from "../../src/types/PRBMathUD60x18TypedMock";

type UnitFixturePRBMathSd59x18ReturnType = {
  prbMathSd59x18: PRBMathSD59x18Mock;
  prbMathSd59x18Typed: PRBMathSD59x18TypedMock;
};

export async function unitFixturePRBMathSd59x18(signers: Signer[]): Promise<UnitFixturePRBMathSd59x18ReturnType> {
  const deployer: Signer = signers[0];

  const prbMathSd59x18Artifact: Artifact = await artifacts.readArtifact("PRBMathSD59x18Mock");
  const prbMathSd59x18: PRBMathSD59x18Mock = <PRBMathSD59x18Mock>(
    await waffle.deployContract(deployer, prbMathSd59x18Artifact, [])
  );

  const prbMathSd59x18TypedArtifact: Artifact = await artifacts.readArtifact("PRBMathSD59x18TypedMock");
  const prbMathSd59x18Typed: PRBMathSD59x18TypedMock = <PRBMathSD59x18TypedMock>(
    await waffle.deployContract(deployer, prbMathSd59x18TypedArtifact, [])
  );

  return { prbMathSd59x18, prbMathSd59x18Typed };
}

type UnitFixturePRBMathUd60x18ReturnType = {
  prbMathUd60x18: PRBMathUD60x18Mock;
  prbMathUd60x18Typed: PRBMathUD60x18TypedMock;
};

export async function unitFixturePRBMathUd60x18(signers: Signer[]): Promise<UnitFixturePRBMathUd60x18ReturnType> {
  const deployer: Signer = signers[0];

  const prbMathUd60x18Artifact: Artifact = await artifacts.readArtifact("PRBMathUD60x18Mock");
  const prbMathUd60x18: PRBMathUD60x18Mock = <PRBMathUD60x18Mock>(
    await waffle.deployContract(deployer, prbMathUd60x18Artifact, [])
  );

  const prbMathUd60x18TypedArtifact: Artifact = await artifacts.readArtifact("PRBMathUD60x18TypedMock");
  const prbMathUd60x18Typed: PRBMathUD60x18TypedMock = <PRBMathUD60x18TypedMock>(
    await waffle.deployContract(deployer, prbMathUd60x18TypedArtifact, [])
  );

  return { prbMathUd60x18, prbMathUd60x18Typed };
}
