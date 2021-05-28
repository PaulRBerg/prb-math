import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { frac } from "../../../helpers/ethers.math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeFrac(): void {
  context("when x is zero", function () {
    it("works", async function () {
      const x: BigNumber = bn("0");
      const result: BigNumber = await this.contracts.prbMathUd60x18.doFrac(x);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when x is not zero", function () {
    const testSets = [
      [fp("0.1")],
      [fp("0.5")],
      [fp("1")],
      [fp("1.125")],
      [fp("2")],
      [fp(PI)],
      [fp("4.2")],
      [fp("1e18")],
      [fp(MAX_WHOLE_UD60x18)],
      [fp(MAX_UD60x18)],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doFrac(x);
      const expected: BigNumber = frac(x);
      expect(expected).to.equal(result);
    });
  });
}
