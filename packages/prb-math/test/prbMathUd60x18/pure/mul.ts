import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, HALF_SCALE, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18 } from "../../../helpers/constants";
import { PRBMathErrors } from "../../shared/errors";
import { mul } from "../../shared/mirrors";

export default function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [Zero, toBn(MAX_UD60x18)],
      [Zero, toBn("0.5")],
      [toBn("0.5"), Zero],
      [toBn(MAX_UD60x18), Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doMul(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doMul(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the result overflows", function () {
      const testSets = [
        [toBn(SQRT_MAX_UD60x18).add(1), toBn(SQRT_MAX_UD60x18).add(1)],
        [toBn(MAX_WHOLE_UD60x18), toBn(MAX_WHOLE_UD60x18)],
        [toBn(MAX_UD60x18), toBn(MAX_UD60x18)],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doMul(x, y)).to.be.revertedWith(
          PRBMathErrors.MulDivFixedPointOverflow,
        );
        await expect(this.contracts.prbMathUd60x18Typed.doMul(x, y)).to.be.revertedWith(
          PRBMathErrors.MulDivFixedPointOverflow,
        );
      });
    });

    context("when the result does not overflow", function () {
      const testSets = [
        [toBn("1e-18"), toBn("1e-18")],
        [toBn("6e-18"), toBn("0.1")],
        [toBn("1e-9"), toBn("1e-9")],
        [toBn("1e-5"), toBn("1e-5")],
        [toBn("0.001"), toBn("0.01")],
        [toBn("0.01"), toBn("0.05")],
        [toBn("1"), toBn("1")],
        [toBn("2.098"), toBn("1.119")],
        [toBn(PI), toBn(E)],
        [toBn("18.3"), toBn("12.04")],
        [toBn("314.271"), toBn("188.19")],
        [toBn("9817"), toBn("2348")],
        [toBn("12983.989"), toBn("782.99")],
        [toBn("1e18"), toBn("1e6")],
        [toBn(SQRT_MAX_UD60x18), toBn(SQRT_MAX_UD60x18)],
        [toBn(MAX_WHOLE_UD60x18), toBn("1e-18")],
        [toBn(MAX_WHOLE_UD60x18), toBn("0.01")],
        [toBn(MAX_WHOLE_UD60x18), toBn("0.5")],
        [toBn(MAX_UD60x18).sub(toBn(HALF_SCALE)), toBn("1e-18")],
        [toBn(MAX_UD60x18), toBn("0.01")],
        [toBn(MAX_UD60x18), toBn("0.5")],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const expected: BigNumber = mul(x, y);
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doMul(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doMul(x, y));
        },
      );
    });
  });
}
