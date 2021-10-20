import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { inv } from "../../../../src/functions";
import { PanicCodes } from "../../../shared/errors";

export function shouldBehaveLikeInv(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doInv(x)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
      await expect(this.contracts.prbMathSd59x18Typed.doInv(x)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      const testSets = [
        MIN_SD59x18,
        MIN_WHOLE_SD59x18,
        toBn("-1e18").sub(1),
        toBn("-1e18"),
        toBn("-2503"),
        toBn("-772.05"),
        toBn("-100.135"),
        toBn("-22"),
        toBn("-4"),
        PI.mul(-1),
        toBn("-2"),
        toBn("-1"),
        toBn("-0.1"),
        toBn("-0.05"),
        toBn("-1e-5"),
        toBn("-1e-18"),
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = inv(x);
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doInv(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doInv(x));
      });
    });

    context("when x is positive", function () {
      const testSets = [
        toBn("1e-18"),
        toBn("1e-5"),
        toBn("0.05"),
        toBn("0.1"),
        toBn("1"),
        toBn("2"),
        PI,
        toBn("4"),
        toBn("22"),
        toBn("100.135"),
        toBn("772.05"),
        toBn("2503"),
        toBn("1e18"),
        toBn("1e18").add(1),
        MAX_WHOLE_SD59x18,
        MAX_SD59x18,
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = inv(x);
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doInv(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doInv(x));
      });
    });
  });
}
