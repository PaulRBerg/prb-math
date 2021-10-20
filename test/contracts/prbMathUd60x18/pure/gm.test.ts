import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";
import { gm } from "../../../../src/functions";

// Biggest number whose square fits within uint256
export const SQRT_MAX_UD60x18_DIV_BY_SCALE: BigNumber = toBn("340282366920938463463.374607431768211455");

export function shouldBehaveLikeGm(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [Zero, PI],
      [PI, Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doGm(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doGm(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [SQRT_MAX_UD60x18_DIV_BY_SCALE.add(1), SQRT_MAX_UD60x18_DIV_BY_SCALE.add(1)],
        [MAX_WHOLE_UD60x18, toBn("3e-18")],
        [MAX_UD60x18, toBn("2e-18")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doGm(x, y)).to.be.revertedWith(PRBMathUD60x18Errors.GM_OVERFLOW);
        await expect(this.contracts.prbMathUd60x18Typed.doGm(x, y)).to.be.revertedWith(
          PRBMathUD60x18Errors.GM_OVERFLOW,
        );
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        [toBn("1"), toBn("1")],
        [toBn("1"), toBn("4")],
        [toBn("2"), toBn("8")],
        [E, toBn("89.01")],
        [PI, toBn("8.2")],
        [toBn("322.47"), toBn("674.77")],
        [toBn("2404.8"), toBn("7899.210662")],
        [SQRT_MAX_UD60x18_DIV_BY_SCALE, SQRT_MAX_UD60x18_DIV_BY_SCALE],
        [MAX_WHOLE_UD60x18, toBn("1e-18")],
        [MAX_UD60x18, toBn("1e-18")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = gm(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doGm(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doGm(x, y));
        },
      );
    });
  });
}
