import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_UD60x18, PI, SCALE } from "../../../../src/constants";
import { PRBMathErrors } from "../../../../src/errors";
import { div } from "../../../../src/functions";
import { PanicCodes } from "../../../shared/errors";

export function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    const y: BigNumber = Zero;

    it("reverts", async function () {
      const x: BigNumber = toBn("1");
      await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
      await expect(this.contracts.prbMathUd60x18Typed.doDiv(x, y)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
    });
  });

  context("when the denominator is not zero", function () {
    context("when the numerator is zero", function () {
      const x: BigNumber = Zero;
      const testSets = [toBn("1e-18"), toBn("1"), PI, toBn("1e18")];

      forEach(testSets).it("takes %e and returns 0", async function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doDiv(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doDiv(x, y));
      });
    });

    context("when the numerator is not zero", function () {
      context("when the result overflows ud60x18", function () {
        const testSets = [
          [MAX_UD60x18.div(SCALE).add(1), toBn("1e-18")],
          [MAX_UD60x18.div(SCALE).add(1), toBn("1e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.revertedWith(PRBMathErrors.MUL_DIV_OVERFLOW);
          await expect(this.contracts.prbMathUd60x18Typed.doDiv(x, y)).to.be.revertedWith(
            PRBMathErrors.MUL_DIV_OVERFLOW,
          );
        });
      });

      context("when the result does not overflow ud60x18", function () {
        const testSets = [
          [toBn("1e-18"), MAX_UD60x18],
          [toBn("1e-18"), toBn("1.000000000000000001")],
          [toBn("1e-18"), toBn("1")],
          [toBn("1e-5"), toBn("1e-5")],
          [toBn("1e-5"), toBn("2e-5")],
          [toBn("0.05"), toBn("0.02")],
          [toBn("0.1"), toBn("0.01")],
          [toBn("2"), toBn("2")],
          [toBn("2"), toBn("5")],
          [toBn("4"), toBn("2")],
          [toBn("22"), toBn("7")],
          [toBn("100.135"), toBn("100.134")],
          [toBn("772.05"), toBn("199.98")],
          [toBn("2503"), toBn("918882.11")],
          [toBn("1e18"), toBn("1")],
          [toBn("115792089237316195423570985008687907853269.984665640564039457"), toBn("1e-18")],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns the correct value",
          async function (x: BigNumber, y: BigNumber) {
            const expected: BigNumber = div(x, y);
            expect(expected).to.equal(await this.contracts.prbMathUd60x18.doDiv(x, y));
            expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doDiv(x, y));
          },
        );
      });
    });
  });
}
