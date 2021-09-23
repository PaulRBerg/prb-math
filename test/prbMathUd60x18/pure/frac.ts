import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { frac } from "../../shared/mirrors";

export default function shouldBehaveLikeFrac(): void {
  context("when x is zero", function () {
    it("works", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFrac(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFrac(x));
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
      const expected: BigNumber = frac(x);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFrac(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFrac(x));
    });
  });
}
