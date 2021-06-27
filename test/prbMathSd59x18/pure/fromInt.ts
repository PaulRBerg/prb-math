import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, SCALE } from "../../../helpers/constants";
import { bn } from "../../../helpers/numbers";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeFromInt(): void {
  context("when x is less than min sd59x18 divided by scale", function () {
    const testSets = [[fp(MIN_WHOLE_SD59x18).div(fp(SCALE)).sub(1)], [fp(MIN_WHOLE_SD59x18)], [fp(MIN_SD59x18)]];

    forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
      await expect(this.contracts.prbMathSd59x18.doFromInt(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.FromIntUnderflow,
      );
      await expect(this.contracts.prbMathSd59x18Typed.doFromInt(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.FromIntUnderflow,
      );
    });
  });

  context("when x is greater than or equal to sd59x18 divided by scale", function () {
    context("when x is greater than max sd59x18 divided by scale", function () {
      const testSets = [[fp(MAX_WHOLE_SD59x18).div(fp(SCALE)).add(1)], [fp(MAX_WHOLE_SD59x18)], [fp(MAX_SD59x18)]];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doFromInt(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.FromIntOverflow,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doFromInt(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.FromIntOverflow,
        );
      });
    });

    context("when x is less than or equal to max sd59x18 divided by scale", function () {
      const testSets = [
        [fp(MIN_WHOLE_SD59x18).div(fp(SCALE))],
        [fp("-3.1415e24")],
        [fp("-2.7182e20")],
        [fp("-1e18")],
        [fp("-5")],
        [fp("-1")],
        [bn("-1729")],
        [bn("-2")],
        [bn("-1")],
      ].concat([
        [bn("1")],
        [bn("2")],
        [bn("1729")],
        [fp("1")],
        [fp("5")],
        [fp("1e18")],
        [fp("2.7182e20")],
        [fp("3.1415e24")],
        [fp(MAX_WHOLE_SD59x18).div(fp(SCALE))],
      ]);

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = x.mul(fp(SCALE));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doFromInt(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doFromInt(x));
      });
    });
  });
}
