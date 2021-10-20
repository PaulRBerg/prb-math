import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../../src/constants";
import { frac } from "../../../../src/functions";

export function shouldBehaveLikeFrac(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFrac(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFrac(x));
    });
  });

  context("when x is not zero", function () {
    const testSets = [
      toBn("0.1"),
      toBn("0.5"),
      toBn("1"),
      toBn("1.125"),
      toBn("2"),
      PI,
      toBn("4.2"),
      toBn("1e18"),
      MAX_WHOLE_UD60x18,
      MAX_UD60x18,
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = frac(x);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFrac(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFrac(x));
    });
  });
}
