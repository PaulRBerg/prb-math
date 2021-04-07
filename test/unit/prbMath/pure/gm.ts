import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_59x18,
  MAX_WHOLE_59x18,
  MIN_59x18,
  MIN_WHOLE_59x18,
  PI,
  SQRT_MAX_59x18,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeGm(): void {
  context("when the product of x and y is zero", function () {
    const testSets = [
      [ZERO, PI],
      [PI, ZERO],
    ];

    forEach(testSets).it("takes %e and %e and returns zero", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMath.doGm(x, y);
      expect(result).to.equal(ZERO);
    });
  });

  context("when the product of x and y is negative", function () {
    const testSets = [
      [fp(-7.1), fp(20.05)],
      [fp(-1), PI],
      [PI, fp(-1)],
      [fp(7.1), fp(-20.05)],
    ];

    forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
      await expect(this.contracts.prbMath.doGm(x, y)).to.be.reverted;
    });
  });

  context("when the product of x and y is positive", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [MIN_59x18, -1],
        [MIN_59x18, -2],
        [MIN_WHOLE_59x18, -3],
        [SQRT_MAX_59x18.mul(-1), SQRT_MAX_59x18.mul(-1).sub(1)],
        [SQRT_MAX_59x18, SQRT_MAX_59x18.add(1)],
        [MAX_WHOLE_59x18, 3],
        [MAX_59x18, 2],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMath.doGm(x, y)).to.be.reverted;
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        [MIN_WHOLE_59x18, -1, SQRT_MAX_59x18],
        [SQRT_MAX_59x18.mul(-1), SQRT_MAX_59x18.mul(-1), SQRT_MAX_59x18],
        [fp(-2404.8), fp(-7899.210662), bn("4358442588812843362311")],
        [fp(-322.47), fp(-674.77), bn("466468736251423392217")],
        [PI.mul(-1), fp(-8.2), bn("5075535416036056441")],
        [E.mul(-1), fp(-89.01), bn("15554879155787087514")],
        [fp(-2), fp(-8), fp(4)],
        [fp(-1), fp(-4), fp(2)],
        [fp(-1), fp(-1), fp(1)],
      ].concat([
        [fp(1), fp(1), fp(1)],
        [fp(1), fp(4), fp(2)],
        [fp(2), fp(8), fp(4)],
        [E, fp(89.01), bn("15554879155787087514")],
        [PI, fp(8.2), bn("5075535416036056441")],
        [fp(322.47), fp(674.77), bn("466468736251423392217")],
        [fp(2404.8), fp(7899.210662), bn("4358442588812843362311")],
        [MAX_59x18, 1, SQRT_MAX_59x18],
        [MAX_WHOLE_59x18, 1, SQRT_MAX_59x18],
        [SQRT_MAX_59x18, SQRT_MAX_59x18, SQRT_MAX_59x18],
      ]);

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          const result = await this.contracts.prbMath.doGm(x, y);
          expect(result).to.equal(expected);
        },
      );
    });
  });
}
