import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, SCALE } from "../../../helpers/constants";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeFromInt(): void {
  context("when x is less than min sd59x18 divided by scale", function () {
    const testSets = [
      [toBn(MIN_WHOLE_SD59x18).div(toBn(SCALE)).sub(1)],
      [toBn(MIN_WHOLE_SD59x18)],
      [toBn(MIN_SD59x18)],
    ];

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
      const testSets = [
        [toBn(MAX_WHOLE_SD59x18).div(toBn(SCALE)).add(1)],
        [toBn(MAX_WHOLE_SD59x18)],
        [toBn(MAX_SD59x18)],
      ];

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
        [toBn(MIN_WHOLE_SD59x18).div(toBn(SCALE))],
        [toBn("-3.1415e24")],
        [toBn("-2.7182e20")],
        [toBn("-1e18")],
        [toBn("-5")],
        [toBn("-1")],
        [toBn("-1729e-18")],
        [toBn("-2e-18")],
        [toBn("-1e-18")],
      ].concat([
        [toBn("1e-18")],
        [toBn("2e-18")],
        [toBn("1729e-18")],
        [toBn("1")],
        [toBn("5")],
        [toBn("1e18")],
        [toBn("2.7182e20")],
        [toBn("3.1415e24")],
        [toBn(MAX_WHOLE_SD59x18).div(toBn(SCALE))],
      ]);

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = x.mul(toBn(SCALE));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doFromInt(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doFromInt(x));
      });
    });
  });
}
