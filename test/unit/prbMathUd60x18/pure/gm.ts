import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SQRT_MAX_UD60x18_DIV_BY_SCALE,
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
      const result: BigNumber = await this.contracts.prbMathUD60x18.doGm(x, y);
      expect(result).to.equal(ZERO);
    });
  });

  context("when the product of x and y is not zero", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [SQRT_MAX_UD60x18_DIV_BY_SCALE.add(1), SQRT_MAX_UD60x18_DIV_BY_SCALE.add(1)],
        [MAX_WHOLE_UD60x18, fp(0.000000000000000003)],
        [MAX_UD60x18, fp(0.000000000000000002)],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUD60x18.doGm(x, y)).to.be.reverted;
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        [fp(1), fp(1), fp(1)],
        [fp(1), fp(4), fp(2)],
        [fp(2), fp(8), fp(4)],
        [E, fp(89.01), bn("15554879155787087514")],
        [PI, fp(8.2), bn("5075535416036056441")],
        [fp(322.47), fp(674.77), bn("466468736251423392217")],
        [fp(2404.8), fp(7899.210662), bn("4358442588812843362311")],
        [SQRT_MAX_UD60x18_DIV_BY_SCALE, SQRT_MAX_UD60x18_DIV_BY_SCALE, SQRT_MAX_UD60x18_DIV_BY_SCALE],
        [MAX_WHOLE_UD60x18, fp(0.000000000000000001), SQRT_MAX_UD60x18_DIV_BY_SCALE],
        [MAX_UD60x18, fp(0.000000000000000001), SQRT_MAX_UD60x18_DIV_BY_SCALE],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns %e",
        async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
          const result = await this.contracts.prbMathUD60x18.doGm(x, y);
          expect(expected).to.equal(result);
        },
      );
    });
  });
}
