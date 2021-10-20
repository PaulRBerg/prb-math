import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_SD59x18, MIN_SD59x18, PI, SCALE } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { div } from "../../../../src/functions";
import { PanicCodes } from "../../../shared/errors";

export function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    const y: BigNumber = Zero;

    it("reverts", async function () {
      const x: BigNumber = toBn("1");
      await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
      await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(PanicCodes.DIVISION_BY_ZERO);
    });
  });

  context("when the denominator is not zero", function () {
    context("when the denominator is min sd59x18", function () {
      const y: BigNumber = MIN_SD59x18;

      it("reverts", async function () {
        const x: BigNumber = toBn("1");
        await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.DIV_INPUT_TOO_SMALL,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.DIV_INPUT_TOO_SMALL,
        );
      });
    });

    context("when the denominator is not min sd59x18", function () {
      context("when the numerator is zero", function () {
        const x: BigNumber = Zero;
        const testSets = [toBn("-1e18"), PI.mul(-1), toBn("-1"), toBn("-1e-18")].concat([
          toBn("1e-18"),
          toBn("1"),
          PI,
          toBn("1e18"),
        ]);

        forEach(testSets).it("takes %e and returns 0", async function (y: BigNumber) {
          const expected: BigNumber = Zero;
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(x, y));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(x, y));
        });
      });

      context("when the numerator is not zero", function () {
        context("when the numerator is min sd59x18", function () {
          const x: BigNumber = MIN_SD59x18;

          it("reverts", async function () {
            const y: BigNumber = toBn("1");
            await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.DIV_INPUT_TOO_SMALL,
            );
            await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.DIV_INPUT_TOO_SMALL,
            );
          });
        });

        context("when the numerator is not min sd59x18", function () {
          context("when the result overflows sd59x18", function () {
            const testSets = [
              [MIN_SD59x18.div(SCALE).sub(1), toBn("1e-18")],
              [MIN_SD59x18.div(SCALE).sub(1), toBn("1e-18")],
            ].concat([
              [MAX_SD59x18.div(SCALE).add(1), toBn("1e-18")],
              [MAX_SD59x18.div(SCALE).add(1), toBn("1e-18")],
            ]);

            forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
              await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
                PRBMathSD59x18Errors.DIV_OVERFLOW,
              );
              await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
                PRBMathSD59x18Errors.DIV_OVERFLOW,
              );
            });
          });

          context("when the result does not overflow sd59x18", function () {
            context("when the numerator and the denominator have the same sign", function () {
              const testSets = [
                [toBn("-57896044618658097711785492504343953926634.992332820282019728"), toBn("-1e-18")],
                [toBn("-1e18"), toBn("-1")],
                [toBn("-2503"), toBn("-918882.11")],
                [toBn("-772.05"), toBn("-199.98")],
                [toBn("-100.135"), toBn("-100.134")],
                [toBn("-22"), toBn("-7")],
                [toBn("-4"), toBn("-2")],
                [toBn("-2"), toBn("-5")],
                [toBn("-2"), toBn("-2")],
                [toBn("-0.1"), toBn("-0.01")],
                [toBn("-0.05"), toBn("-0.02")],
                [toBn("-1e-5"), toBn("-0.00002")],
                [toBn("-1e-5"), toBn("-1e-5")],
                [toBn("-1e-18"), toBn("-1")],
                [toBn("-1e-18"), toBn("-1.000000000000000001")],
                [toBn("-1e-18"), MIN_SD59x18.add(1)],
              ].concat([
                [toBn("1e-18"), MAX_SD59x18],
                [toBn("1e-18"), toBn("1.000000000000000001")],
                [toBn("1e-18"), toBn("1")],
                [toBn("1e-5"), toBn("1e-5")],
                [toBn("1e-5"), toBn("0.00002")],
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
                [toBn("57896044618658097711785492504343953926634.992332820282019728"), toBn("1e-18")],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns the correct value",
                async function (x: BigNumber, y: BigNumber) {
                  const expected: BigNumber = div(x, y);
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(x, y));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(x, y));
                },
              );
            });

            context("when the numerator and the denominator do not have the same sign", function () {
              const testSets = [
                [toBn("-57896044618658097711785492504343953926634.992332820282019728"), toBn("1e-18")],
                [toBn("-1e18"), toBn("1")],
                [toBn("-2503"), toBn("918882.11")],
                [toBn("-772.05"), toBn("199.98")],
                [toBn("-100.135"), toBn("100.134")],
                [toBn("-22"), toBn("7")],
                [toBn("-4"), toBn("2")],
                [toBn("-2"), toBn("5")],
                [toBn("-2"), toBn("2")],
                [toBn("-0.1"), toBn("0.01")],
                [toBn("-0.05"), toBn("0.02")],
                [toBn("-1e-5"), toBn("2e-5")],
                [toBn("-1e-5"), toBn("1e-5")],
                [toBn("-1e-18"), toBn("1")],
                [toBn("-1e-18"), toBn("1.000000000000000001")],
                [toBn("-1e-18"), MAX_SD59x18],
              ].concat([
                [toBn("1e-18"), MIN_SD59x18.add(1)],
                [toBn("1e-18"), toBn("-1.000000000000000001")],
                [toBn("1e-18"), toBn("-1")],
                [toBn("1e-5"), toBn("-1e-5")],
                [toBn("1e-5"), toBn("-2e-5")],
                [toBn("0.05"), toBn("-0.02")],
                [toBn("0.1"), toBn("-0.01")],
                [toBn("2"), toBn("-2")],
                [toBn("2"), toBn("-5")],
                [toBn("4"), toBn("-2")],
                [toBn("22"), toBn("-7")],
                [toBn("100.135"), toBn("-100.134")],
                [toBn("772.05"), toBn("-199.98")],
                [toBn("2503"), toBn("-918882.11")],
                [toBn("1e18"), toBn("-1")],
                [toBn("57896044618658097711785492504343953926634.992332820282019728"), toBn("-1e-18")],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns the correct value",
                async function (x: BigNumber, y: BigNumber) {
                  const expected: BigNumber = div(x, y);
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(x, y));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(x, y));
                },
              );
            });
          });
        });
      });
    });
  });
}
