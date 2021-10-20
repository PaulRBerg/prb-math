// eslint-disable @typescript-eslint/no-explicit-any
import type { Signer } from "@ethersproject/abstract-signer";
import type { Wallet } from "@ethersproject/wallet";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import chai from "chai";
import { ethers, waffle } from "hardhat";

import { near } from "./assertions";
import { Contracts, Signers } from "./types";

chai.use(near);

export function baseContext(description: string, hooks: () => void): void {
  describe(description, function () {
    before(async function () {
      this.contracts = {} as Contracts;
      this.signers = {} as Signers;

      const signers: SignerWithAddress[] = await ethers.getSigners();
      this.signers.admin = signers[0];
      this.signers.alice = signers[1];

      // Get rid of this when https://github.com/nomiclabs/hardhat/issues/849 gets fixed.
      this.loadFixture = waffle.createFixtureLoader(signers as Signer[] as Wallet[]);
    });

    hooks();
  });
}
