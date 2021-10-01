import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import { prb } from "hardhat";
import { PRBMathUD60x18Errors } from "hardhat-prb-math";
import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "hardhat-prb-math/dist/constants";
import forEach from "mocha-each";

import { SQRT_MAX_UD60x18_DIV_BY_SCALE } from "../../../helpers/constants";

export default function shouldBehaveLikeGm(): void {
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
        [toBn(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1), toBn(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1)],
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
        [toBn(SQRT_MAX_UD60x18_DIV_BY_SCALE), toBn(SQRT_MAX_UD60x18_DIV_BY_SCALE)],
        [MAX_WHOLE_UD60x18, toBn("1e-18")],
        [MAX_UD60x18, toBn("1e-18")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = prb.math.gm(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doGm(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doGm(x, y));
        },
      );
    });
  });
}
