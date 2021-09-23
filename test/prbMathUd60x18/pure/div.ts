import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, PI, SCALE } from "../../../helpers/constants";
import { mbn } from "../../../helpers/math";
import { PRBMathErrors, PanicCodes } from "../../shared/errors";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("1");
      const y: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.revertedWith(PanicCodes.DivisionByZero);
      await expect(this.contracts.prbMathUd60x18Typed.doDiv(x, y)).to.be.revertedWith(PanicCodes.DivisionByZero);
    });
  });

  context("when the denominator is not zero", function () {
    context("when the numerator is zero", function () {
      const testSets = ["1e-18", "1", PI, "1e18"];

      forEach(testSets).it("takes %e and returns 0", async function (y: string) {
        const x: BigNumber = Zero;
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doDiv(x, fp(y)));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doDiv(x, fp(y)));
      });
    });

    context("when the numerator is not zero", function () {
      context("when the result overflows ud60x18", function () {
        const testSets = [
          [fp(MAX_UD60x18).div(fp(SCALE)).add(1), fp("1e-18")],
          [fp(MAX_UD60x18).div(fp(SCALE)).add(1), fp("1e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.revertedWith(PRBMathErrors.MulDivOverflow);
          await expect(this.contracts.prbMathUd60x18Typed.doDiv(x, y)).to.be.revertedWith(PRBMathErrors.MulDivOverflow);
        });
      });

      context("when the result does not overflow ud60x18", function () {
        const testSets = [
          ["1e-18", MAX_UD60x18],
          ["1e-18", "1.000000000000000001"],
          ["1e-18", "1"],
          ["1e-5", "1e-5"],
          ["1e-5", "2e-5"],
          ["0.05", "0.02"],
          ["0.1", "0.01"],
          ["2", "2"],
          ["2", "5"],
          ["4", "2"],
          ["22", "7"],
          ["100.135", "100.134"],
          ["772.05", "199.98"],
          ["2503", "918882.11"],
          ["1e18", "1"],
          ["115792089237316195423570985008687907853269.984665640564039457", "1e-18"],
        ];

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const expected: BigNumber = fp(String(mbn(x).div(mbn(y))));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doDiv(fp(x), fp(y)));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doDiv(fp(x), fp(y)));
        });
      });
    });
  });
}
