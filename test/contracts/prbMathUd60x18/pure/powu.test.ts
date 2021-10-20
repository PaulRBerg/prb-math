import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn as toEvmBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18 } from "../../../../src/constants";
import { PRBMathErrors } from "../../../../src/errors";
import { powu } from "../../../../src/functions";

export function shouldBehaveLikePowu(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      const y: BigNumber = Zero;

      it("returns 1", async function () {
        const expected: BigNumber = toEvmBn("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [toEvmBn("1"), E, PI];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const x: BigNumber = Zero;
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [toEvmBn("1"), E, PI, MAX_UD60x18];
      const y: BigNumber = Zero;

      forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
        const expected: BigNumber = toEvmBn("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPowu(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows ud60x18", function () {
        const testSets = [
          [toEvmBn("48740834812604276470.692694885616578542"), toEvmBn("3e-18")], // smallest number whose cube doesn't fit within MAX_UD60x18
          [toEvmBn(SQRT_MAX_UD60x18).add(1), toEvmBn("2e-18")],
          [MAX_WHOLE_UD60x18, toEvmBn("2e-18")],
          [MAX_UD60x18, toEvmBn("2e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MUL_DIV_FIXED_POINT_OVERFLOW,
          );
          await expect(this.contracts.prbMathUd60x18Typed.doPowu(x, y)).to.be.revertedWith(
            PRBMathErrors.MUL_DIV_FIXED_POINT_OVERFLOW,
          );
        });
      });

      context("when the result does not overflow ud60x18", function () {
        const testSets = [
          [toEvmBn("0.001"), BigNumber.from("3")],
          [toEvmBn("0.1"), BigNumber.from("2")],
          [toEvmBn("1"), BigNumber.from("1")],
          [toEvmBn("2"), BigNumber.from("5")],
          [toEvmBn("2"), BigNumber.from("100")],
          [E, BigNumber.from("2")],
          [toEvmBn("100"), BigNumber.from("4")],
          [PI, BigNumber.from("3")],
          [toEvmBn("5.491"), BigNumber.from("19")],
          [toEvmBn("478.77"), BigNumber.from("20")],
          [toEvmBn("6452.166"), BigNumber.from("7")],
          [toEvmBn("1e18"), BigNumber.from("3")],
          [toEvmBn("48740834812604276470.692694885616578541"), BigNumber.from("3")], // Biggest number whose cube fits within MAX_UD60x18
          [toEvmBn(SQRT_MAX_UD60x18), BigNumber.from("2")],
          [MAX_WHOLE_UD60x18, BigNumber.from("1")],
          [MAX_UD60x18, BigNumber.from("1")],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns the correct value",
          async function (x: BigNumber, y: BigNumber) {
            const expected: BigNumber = powu(x, y);
            expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doPowu(x, y));
            expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doPowu(x, y));
          },
        );
      });
    });
  });
}
