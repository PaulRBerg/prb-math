import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { gm } from "../../../../src/functions";

// Biggest number whose square fits within int256
const SQRT_MAX_SD59x18_DIV_BY_SCALE: BigNumber = toBn("240615969168004511545.033772477625056927");

export function shouldBehaveLikeGm(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [Zero, PI],
      [PI, Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doGm(x, y));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doGm(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the product of x and y is negative", function () {
      const testSets = [
        [toBn("-7.1"), toBn("20.05")],
        [toBn("-1"), PI],
        [PI, toBn("-1")],
        [toBn("7.1"), toBn("-20.05")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.GM_NEGATIVE_PRODUCT,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doGm(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.GM_NEGATIVE_PRODUCT,
        );
      });
    });

    context("when the product of x and y is positive", function () {
      context("when the product of x and y overflows", function () {
        const testSets = [
          [MIN_SD59x18, toBn("2e-18")],
          [MIN_WHOLE_SD59x18, toBn("3e-18")],
          [SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1), SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1).sub(1)],
        ].concat([
          [SQRT_MAX_SD59x18_DIV_BY_SCALE.add(1), SQRT_MAX_SD59x18_DIV_BY_SCALE.add(1)],
          [MAX_WHOLE_SD59x18, toBn("3e-18")],
          [MAX_SD59x18, toBn("2e-18")],
        ]);

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.revertedWith(PRBMathSD59x18Errors.GM_OVERFLOW);
          await expect(this.contracts.prbMathSd59x18Typed.doGm(x, y)).to.be.revertedWith(
            PRBMathSD59x18Errors.GM_OVERFLOW,
          );
        });
      });

      context("when the product of x and y does not overflow", function () {
        const testSets = [
          [MIN_WHOLE_SD59x18, toBn("-1e-18")],
          [SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1), SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1)],
          [toBn("-2404.8"), toBn("-7899.210662")],
          [toBn("-322.47"), toBn("-674.77")],
          [PI.mul(-1), toBn("-8.2")],
          [E.mul(-1), toBn("-89.01")],
          [toBn("-2"), toBn("-8")],
          [toBn("-1"), toBn("-4")],
          [toBn("-1"), toBn("-1")],
        ].concat([
          [toBn("1"), toBn("1")],
          [toBn("1"), toBn("4")],
          [toBn("2"), toBn("8")],
          [E, toBn("89.01")],
          [PI, toBn("8.2")],
          [toBn("322.47"), toBn("674.77")],
          [toBn("2404.8"), toBn("7899.210662")],
          [SQRT_MAX_SD59x18_DIV_BY_SCALE, SQRT_MAX_SD59x18_DIV_BY_SCALE],
          [MAX_WHOLE_SD59x18, toBn("1e-18")],
          [MAX_SD59x18, toBn("1e-18")],
        ]);

        forEach(testSets).it(
          "takes %e and %e and returns the correct value",
          async function (x: BigNumber, y: BigNumber) {
            const expected: BigNumber = gm(x, y);
            expect(expected).to.equal(await this.contracts.prbMathSd59x18.doGm(x, y));
            expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doGm(x, y));
          },
        );
      });
    });
  });
}
