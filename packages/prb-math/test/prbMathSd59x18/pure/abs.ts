import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
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
          const x: BigNumber = toBn(MIN_SD59x18);
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
          [toBn(MIN_SD59x18).add(1)],
          [toBn(MIN_WHOLE_SD59x18)],
          [toBn("-1e18")],
          [toBn("-4.2")],
          [toBn("-2")],
          [toBn(PI).mul(-1)],
          [toBn("-1.125")],
          [toBn("-1")],
          [toBn("-0.5")],
          [toBn("-0.1")],
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
          [toBn("0.1")],
          [toBn("0.5")],
          [toBn("1")],
          [toBn("1.125")],
          [toBn("2")],
          [toBn(PI).mul(-1)],
          [toBn("4.2")],
          [toBn("1e18")],
          [toBn(MAX_WHOLE_SD59x18)],
          [toBn(MAX_SD59x18)],
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
