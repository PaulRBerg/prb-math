import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { pow } from "../../../../src/functions";

export function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    const x: BigNumber = Zero;

    context("when the exponent is zero", function () {
      const y: BigNumber = Zero;

      it("returns 1", async function () {
        const expected: BigNumber = toBn("1");
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPow(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [toBn("1"), E, PI];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPow(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is negative", function () {
      const testSets = [PI.mul(-1), E.mul(-1), toBn("-1")];
      const y: BigNumber = toBn("1");

      forEach(testSets).it("takes %e and 1 and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doPow(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doPow(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
      });
    });

    context("when the base is positive", function () {
      context("when the exponent is zero", function () {
        const testSets = [toBn("1"), E, PI];
        const y: BigNumber = Zero;

        forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
          const expected: BigNumber = toBn("1");
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doPow(x, y));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doPow(x, y));
        });
      });

      context("when the exponent is not zero", function () {
        context("when the exponent is greater than or equal to 192", function () {
          const testSets = [
            [toBn("6277101735386680763835789423207666416102355444464034512896"), toBn("1")], // 2^192
            [MAX_SD59x18, toBn("1")],
          ];

          forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
            await expect(this.contracts.prbMathSd59x18.doPow(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.EXP2_INPUT_TOO_BIG,
            );
            await expect(this.contracts.prbMathSd59x18Typed.doPow(x, y)).to.be.revertedWith(
              PRBMathSD59x18Errors.EXP2_INPUT_TOO_BIG,
            );
          });
        });

        context("when the exponent is less than 192", function () {
          const testSets = [
            [toBn("1e-18"), toBn("-1e-18")],
            [toBn("1e-12"), toBn("-4.4e-9")],
            [toBn("0.1"), toBn("-0.8")],
            [toBn("0.24"), toBn("-11")],
            [toBn("0.5"), toBn("-0.7373")],
            [toBn("0.799291"), toBn("-69")],
            [toBn("1"), toBn("-1")],
            [toBn("1"), PI.mul(-1)],
            [toBn("2"), toBn("-1.5")],
            [E, E.mul(-1)],
            [E, toBn("-1.66976")],
            [PI, PI.mul(-1)],
            [toBn("11"), toBn("-28.5")],
            [toBn("32.15"), toBn("-23.99")],
            [toBn("406"), toBn("-0.25")],
            [toBn("1729"), toBn("-0.98")],
            [toBn("33441"), toBn("-2.1891")],
            [toBn("340282366920938463463374607431768211455"), toBn("-1")], // 2^128 - 1
            [toBn("6277101735386680763835789423207666416102355444464034512895"), toBn("-1")], // 2^192 - 1
          ].concat([
            [toBn("1e-18"), toBn("1e-18")],
            [toBn("1e-12"), toBn("4.4e-9")],
            [toBn("0.1"), toBn("0.8")],
            [toBn("0.24"), toBn("11")],
            [toBn("0.5"), toBn("0.7373")],
            [toBn("0.799291"), toBn("69")],
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
          ]);

          forEach(testSets).it(
            "takes %e and %e and returns the correct value",
            async function (x: BigNumber, y: BigNumber) {
              const expected: BigNumber = pow(x, y);
              expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doPow(x, y));
              expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doPow(x, y));
            },
          );
        });
      });
    });
  });
}
