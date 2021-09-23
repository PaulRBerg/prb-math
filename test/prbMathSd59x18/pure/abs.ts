import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../helpers/constants";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeAbs(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doAbs(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doAbs(x));
    });
  });

  context("when x is not zero", function () {
    context("when x is negative", function () {
      context("when x = min sd59x18", function () {
        it("reverts", async function () {
          const x: BigNumber = fp(MIN_SD59x18);
          await expect(this.contracts.prbMathSd59x18.doAbs(x)).to.be.revertedWith(
            PRBMathSD59x18Errors.AbsInputTooSmall,
          );
          await expect(this.contracts.prbMathSd59x18Typed.doAbs(x)).to.be.revertedWith(
            PRBMathSD59x18Errors.AbsInputTooSmall,
          );
        });
      });

      context("when x > min sd59x18", function () {
        const testSets = [
          [fp(MIN_SD59x18).add(1)],
          [fp(MIN_WHOLE_SD59x18)],
          [fp("-1e18")],
          [fp("-4.2")],
          [fp("-2")],
          [fp(PI).mul(-1)],
          [fp("-1.125")],
          [fp("-1")],
          [fp("-0.5")],
          [fp("-0.1")],
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = x.abs();
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doAbs(x));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doAbs(x));
        });
      });
    });

    context("when x is positive", function () {
      context("when x > min sd59x18", function () {
        const testSets = [
          [fp("0.1")],
          [fp("0.5")],
          [fp("1")],
          [fp("1.125")],
          [fp("2")],
          [fp(PI).mul(-1)],
          [fp("4.2")],
          [fp("1e18")],
          [fp(MAX_WHOLE_SD59x18)],
          [fp(MAX_SD59x18)],
        ];

        forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
          const expected: BigNumber = x.abs();
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doAbs(x));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doAbs(x));
        });
      });
    });
  });
}
