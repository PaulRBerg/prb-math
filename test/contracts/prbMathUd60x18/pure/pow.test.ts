import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, PI } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";
import { pow } from "../../../../src/functions";

export function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      const y: BigNumber = Zero;

      it("returns 1", async function () {
        const expected: BigNumber = toBn("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const x: BigNumber = Zero;
      const testSets = [toBn("1"), E, PI];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is less than the scale", function () {
      const testSets = [
        [toBn("1e-18"), toBn("1")],
        [toBn("1e-11"), toBn("1")],
        [toBn("1").sub(1), toBn("1")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doPow(x, y)).to.be.revertedWith(
          PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL,
        );
        await expect(this.contracts.prbMathUd60x18Typed.doPow(x, y)).to.be.revertedWith(
          PRBMathUD60x18Errors.LOG_INPUT_TOO_SMALL,
        );
      });
    });

    context("when the base is greater than or equal to the scale", function () {
      context("when the exponent is zero", function () {
        const y: BigNumber = Zero;
        const testSets = [toBn("1"), E, PI];

        forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
          const expected: BigNumber = toBn("1");
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
        });
      });

      context("when the exponent is not zero", function () {
        context("when the exponent is greater than or equal to 192", function () {
          const testSets = [
            [toBn("6277101735386680763835789423207666416102355444464034512896"), toBn("1")], // 2^192
            [MAX_UD60x18, toBn("1")],
          ];

          forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
            await expect(this.contracts.prbMathUd60x18.doPow(x, y)).to.be.revertedWith(
              PRBMathUD60x18Errors.EXP2_INPUT_TOO_BIG,
            );
            await expect(this.contracts.prbMathUd60x18Typed.doPow(x, y)).to.be.revertedWith(
              PRBMathUD60x18Errors.EXP2_INPUT_TOO_BIG,
            );
          });
        });

        context("when the exponent is less than 192", function () {
          const testSets = [
            [toBn("1"), toBn("1")],
            [toBn("1"), PI],
            [toBn("2"), toBn("1.5")],
            [E, E],
            [E, toBn("1.66976")],
            [PI, PI],
            [toBn("11"), toBn("28.5")],
            [toBn("32.15"), toBn("23.99")],
            [toBn("406"), toBn("0.25")],
            [toBn("1729"), toBn("0.98")],
            [toBn("33441"), toBn("2.1891")],
            [toBn("340282366920938463463374607431768211455"), toBn("1")], // 2^128 - 1
            [toBn("6277101735386680763835789423207666416102355444464034512895"), toBn("1")], // 2^192 - 1
          ];

          forEach(testSets).it(
            "takes %e and %e and returns the correct value",
            async function (x: BigNumber, y: BigNumber) {
              const expected: BigNumber = pow(x, y);
              expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doPow(x, y));
              expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
            },
          );
        });
      });
    });
  });
}
