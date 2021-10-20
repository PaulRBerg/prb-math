import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { log10 } from "../../../../src/functions";

export function shouldBehaveLikeLog10(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
      );
      await expect(this.contracts.prbMathSd59x18Typed.doLog10(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
      );
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      it("reverts", async function () {
        const x: BigNumber = toBn("-1");
        await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doLog10(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
      });
    });

    context("when x is positive", function () {
      context("when x is a power of ten", function () {
        const testSets = [
          toBn("1e-18"),
          toBn("1e-17"),
          toBn("1e-14"),
          toBn("1e-10"),
          toBn("1e-8"),
          toBn("1e-7"),
          toBn("0.001"),
          toBn("0.1"),
          toBn("1"),
          toBn("10"),
          toBn("100"),
          toBn("1e18"),
          toBn("1e49"),
          toBn("1e57"),
          toBn("1e58"),
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = log10(x);
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doLog10(x));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doLog10(x));
        });
      });

      context("when x is not a power of ten", function () {
        const testSets = [
          toBn("7.892191e-12"),
          toBn("0.0091"),
          toBn("0.083"),
          toBn("0.1982"),
          toBn("0.313"),
          toBn("0.4666"),
          toBn("1.00000000000001"),
          E,
          PI,
          toBn("4"),
          toBn("16"),
          toBn("32"),
          toBn("42.12"),
          toBn("1010.892143"),
          toBn("440934.1881"),
          toBn("1000000000000000000.000000000001"),
          MAX_WHOLE_SD59x18,
          MAX_SD59x18,
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = log10(x);
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLog10(x));
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLog10(x));
        });
      });
    });
  });
}
