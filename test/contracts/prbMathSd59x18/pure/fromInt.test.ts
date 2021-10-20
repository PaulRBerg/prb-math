import type { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, SCALE } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";

export function shouldBehaveLikeFromInt(): void {
  context("when x is less than min sd59x18 divided by scale", function () {
    const testSets = [MIN_WHOLE_SD59x18.div(SCALE).sub(1), MIN_WHOLE_SD59x18, MIN_SD59x18];

    forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
      await expect(this.contracts.prbMathSd59x18.doFromInt(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.FROM_INT_UNDERFLOW,
      );
      await expect(this.contracts.prbMathSd59x18Typed.doFromInt(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.FROM_INT_UNDERFLOW,
      );
    });
  });

  context("when x is greater than or equal to sd59x18 divided by scale", function () {
    context("when x is greater than max sd59x18 divided by scale", function () {
      const testSets = [MAX_WHOLE_SD59x18.div(SCALE).add(1), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doFromInt(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.FROM_INT_OVERFLOW,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doFromInt(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.FROM_INT_OVERFLOW,
        );
      });
    });

    context("when x is less than or equal to max sd59x18 divided by scale", function () {
      const testSets = [
        MIN_WHOLE_SD59x18.div(SCALE),
        toBn("-3.1415e24"),
        toBn("-2.7182e20"),
        toBn("-1e18"),
        toBn("-5"),
        toBn("-1"),
        toBn("-1729e-18"),
        toBn("-2e-18"),
        toBn("-1e-18"),
      ].concat([
        toBn("1e-18"),
        toBn("2e-18"),
        toBn("1729e-18"),
        toBn("1"),
        toBn("5"),
        toBn("1e18"),
        toBn("2.7182e20"),
        toBn("3.1415e24"),
        MAX_WHOLE_SD59x18.div(SCALE),
      ]);

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = x.mul(SCALE);
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doFromInt(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doFromInt(x));
      });
    });
  });
}
