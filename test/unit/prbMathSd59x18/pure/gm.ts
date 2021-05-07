import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SQRT_MAX_SD59x18_DIV_BY_SCALE,
  ZERO,
} from "../../../../helpers/constants";
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeGm(): void {
  context("when the product of x and y is zero", function () {
    const testSets = [
      [ZERO, PI],
      [PI, ZERO],
    ];

    forEach(testSets).it("takes %e and %e and returns zero", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doGm(x, y);
      expect(ZERO).to.equal(result);
    });
  });

  context("when the product of x and y is negative", function () {
    const testSets = [
      [fp("-7.1"), fp("20.05")],
      [fp("-1"), PI],
      [PI, fp("-1")],
      [fp("7.1"), fp("-20.05")],
    ];

    forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
      await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.reverted;
    });
  });

  context("when the product of x and y is positive", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [MIN_SD59x18, sfp("1e-18")],
        [MIN_SD59x18, sfp("2e-18")],
        [MIN_WHOLE_SD59x18, sfp("3e-18")],
        [SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1), SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1).sub(1)],
        [SQRT_MAX_SD59x18_DIV_BY_SCALE.add(1), SQRT_MAX_SD59x18_DIV_BY_SCALE.add(1)],
        [MAX_WHOLE_SD59x18, sfp("3e-18")],
        [MAX_SD59x18, sfp("2e-18")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.reverted;
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        [MIN_WHOLE_SD59x18, sfp("-1e-18"), SQRT_MAX_SD59x18_DIV_BY_SCALE],
        [SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1), SQRT_MAX_SD59x18_DIV_BY_SCALE.mul(-1), SQRT_MAX_SD59x18_DIV_BY_SCALE],
        [fp("-2404.8"), fp("-7899.210662"), fp("4358.442588812843362311")],
        [fp("-322.47"), fp("-674.77"), fp("466.468736251423392217")],
        [PI.mul(-1), fp("-8.2"), fp("5.075535416036056441")],
        [E.mul(-1), fp("-89.01"), fp("15.554879155787087514")],
        [fp("-2"), fp("-8"), fp("4")],
        [fp("-1"), fp("-4"), fp("2")],
        [fp("-1"), fp("-1"), fp("1")],
      ].concat([
        [fp("1"), fp("1"), fp("1")],
        [fp("1"), fp("4"), fp("2")],
        [fp("2"), fp("8"), fp("4")],
        [E, fp("89.01"), fp("15.554879155787087514")],
        [PI, fp("8.2"), fp("5.075535416036056441")],
        [fp("322.47"), fp("674.77"), fp("466.468736251423392217")],
        [fp("2404.8"), fp("7899.210662"), fp("4358.442588812843362311")],
        [SQRT_MAX_SD59x18_DIV_BY_SCALE, SQRT_MAX_SD59x18_DIV_BY_SCALE, SQRT_MAX_SD59x18_DIV_BY_SCALE],
        [MAX_WHOLE_SD59x18, sfp("1e-18"), SQRT_MAX_SD59x18_DIV_BY_SCALE],
        [MAX_SD59x18, sfp("1e-18"), SQRT_MAX_SD59x18_DIV_BY_SCALE],
      ]);

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          const result = await this.contracts.prbMathSd59x18.doGm(x, y);
          expect(expected).to.equal(result);
        },
      );
    });
  });
}
