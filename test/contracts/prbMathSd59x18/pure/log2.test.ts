import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { log2 } from "../../../../src/functions";

export function shouldBehaveLikeLog2(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
      );
      await expect(this.contracts.prbMathSd59x18Typed.doLog2(x)).to.be.revertedWith(
        PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
      );
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      it("reverts", async function () {
        const x: BigNumber = toBn("-1");
        await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doLog2(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.LOG_INPUT_TOO_SMALL,
        );
      });
    });

    context("when x is positive", function () {
      context("when x is a power of two", function () {
        const testSets = [
          toBn("0.0625"),
          toBn("0.125"),
          toBn("0.25"),
          toBn("0.5"),
          toBn("1"),
          toBn("2"),
          toBn("4"),
          toBn("8"),
          toBn("16"),
          toBn("195"),
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = log2(x);
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLog2(x));
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLog2(x));
        });
      });

      context("when x is not a power of two", function () {
        const testSets = [
          toBn("0.0091"),
          toBn("0.083"),
          toBn("0.1"),
          toBn("0.2"),
          toBn("0.3"),
          toBn("0.4"),
          toBn("0.6"),
          toBn("0.7"),
          toBn("0.8"),
          toBn("0.9"),
          toBn("1.125"),
          E,
          PI,
          toBn("1e18"),
          MAX_WHOLE_SD59x18,
          MAX_SD59x18,
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = log2(x);
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doLog2(x));
          expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doLog2(x));
        });
      });
    });
  });
}
