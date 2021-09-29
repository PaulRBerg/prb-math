import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_SD59x18, MIN_SD59x18, PI, SCALE } from "../../../helpers/constants";
import { mbn } from "../../../helpers/math";
import { PRBMathSD59x18Errors, PanicCodes } from "../../shared/errors";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = toBn("1");
      const y: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(PanicCodes.DivisionByZero);
      await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(PanicCodes.DivisionByZero);
    });
  });

  context("when the denominator is not zero", function () {
    context("when the denominator is min sd59x18", function () {
      it("reverts", async function () {
        const x: BigNumber = toBn("1");
        const y: BigNumber = toBn(MIN_SD59x18);
        await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.DivInputTooSmall,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.DivInputTooSmall,
        );
      });
    });

    context("when the denominator is not min sd59x18", function () {
      context("when the numerator is zero", function () {
        const testSets = ["-1e18", `-${PI}`, "-1", "-1e-18"].concat(["1e-18", "1", PI, "1e18"]);

        forEach(testSets).it("takes %e and returns 0", async function (y: string) {
          const x: BigNumber = Zero;
          const expected: BigNumber = Zero;
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(x, toBn(y)));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(x, toBn(y)));
        });
      });

      context("when the numerator is not zero", function () {
        context("when the numerator is min sd59x18", function () {
          it("reverts", async function () {
            const x: BigNumber = toBn(MIN_SD59x18);
            const y: BigNumber = toBn("1");
            await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.DivInputTooSmall,
            );
            await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.DivInputTooSmall,
            );
          });
        });

        context("when the numerator is not min sd59x18", function () {
          context("when the result overflows sd59x18", function () {
            const testSets = [
              [toBn(MIN_SD59x18).div(toBn(SCALE)).sub(1), toBn("1e-18")],
              [toBn(MIN_SD59x18).div(toBn(SCALE)).sub(1), toBn("1e-18")],
            ].concat([
              [toBn(MAX_SD59x18).div(toBn(SCALE)).add(1), toBn("1e-18")],
              [toBn(MAX_SD59x18).div(toBn(SCALE)).add(1), toBn("1e-18")],
            ]);

            forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
              await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.revertedWith(
                PRBMathSD59x18Errors.DivOverflow,
              );
              await expect(this.contracts.prbMathSd59x18Typed.doDiv(x, y)).to.be.revertedWith(
                PRBMathSD59x18Errors.DivOverflow,
              );
            });
          });

          context("when the result does not overflow sd59x18", function () {
            context("when the numerator and the denominator have the same sign", function () {
              const testSets = [
                ["-57896044618658097711785492504343953926634.992332820282019728", "-1e-18"],
                ["-1e18", "-1"],
                ["-2503", "-918882.11"],
                ["-772.05", "-199.98"],
                ["-100.135", "-100.134"],
                ["-22", "-7"],
                ["-4", "-2"],
                ["-2", "-5"],
                ["-2", "-2"],
                ["-0.1", "-0.01"],
                ["-0.05", "-0.02"],
                ["-1e-5", "-0.00002"],
                ["-1e-5", "-1e-5"],
                ["-1e-18", "-1"],
                ["-1e-18", "-1.000000000000000001"],
                ["-1e-18", mbn(MIN_SD59x18).add(mbn("1e-18")).toString()],
              ].concat([
                ["1e-18", MAX_SD59x18],
                ["1e-18", "1.000000000000000001"],
                ["1e-18", "1"],
                ["1e-5", "1e-5"],
                ["1e-5", "0.00002"],
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
                ["57896044618658097711785492504343953926634.992332820282019728", "1e-18"],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns the correct value",
                async function (x: string, y: string) {
                  const expected: BigNumber = toBn(String(mbn(x).div(mbn(y))));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(toBn(x), toBn(y)));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(toBn(x), toBn(y)));
                },
              );
            });

            context("when the numerator and the denominator do not have the same sign", function () {
              const testSets = [
                ["-57896044618658097711785492504343953926634.992332820282019728", "1e-18"],
                ["-1e18", "1"],
                ["-2503", "918882.11"],
                ["-772.05", "199.98"],
                ["-100.135", "100.134"],
                ["-22", "7"],
                ["-4", "2"],
                ["-2", "5"],
                ["-2", "2"],
                ["-0.1", "0.01"],
                ["-0.05", "0.02"],
                ["-1e-5", "2e-5"],
                ["-1e-5", "1e-5"],
                ["-1e-18", "1"],
                ["-1e-18", "1.000000000000000001"],
                ["-1e-18", MAX_SD59x18],
              ].concat([
                ["1e-18", mbn(MIN_SD59x18).add(mbn("1e-18")).toString()],
                ["1e-18", "-1.000000000000000001"],
                ["1e-18", "-1"],
                ["1e-5", "-1e-5"],
                ["1e-5", "-2e-5"],
                ["0.05", "-0.02"],
                ["0.1", "-0.01"],
                ["2", "-2"],
                ["2", "-5"],
                ["4", "-2"],
                ["22", "-7"],
                ["100.135", "-100.134"],
                ["772.05", "-199.98"],
                ["2503", "-918882.11"],
                ["1e18", "-1"],
                ["57896044618658097711785492504343953926634.992332820282019728", "-1e-18"],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns the correct value",
                async function (x: string, y: string) {
                  const expected: BigNumber = toBn(String(mbn(x).div(mbn(y))));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18.doDiv(toBn(x), toBn(y)));
                  expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doDiv(toBn(x), toBn(y)));
                },
              );
            });
          });
        });
      });
    });
  });
}
