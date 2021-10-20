import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { exp } from "../../../../src/functions";

export function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = toBn("1");
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp(x));
    });
  });

  context("when x is negative", function () {
    context("when x is less than -41.446531673892822322", function () {
      const testSets = [toBn("-41.446531673892822323"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp(x));
      });
    });

    context("when x is greater than or equal to -41.446531673892822322", function () {
      const testSets = [
        toBn("-41.446531673892822322"),
        toBn("-33.333333"),
        toBn("-20.82"),
        toBn("-16"),
        toBn("-11.89215"),
        toBn("-4"),
        PI.mul(-1),
        toBn("-3"),
        E.mul(-1),
        toBn("-2"),
        toBn("-1"),
        toBn("-1e-15"),
        toBn("-1e-18"),
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = exp(x);
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp(x));
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 133.084258667509499440", function () {
      const testSets = [toBn("133.084258667509499441"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp(x)).to.be.revertedWith(PRBMathSD59x18Errors.EXP_INPUT_TOO_BIG);
        await expect(this.contracts.prbMathSd59x18Typed.doExp(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.EXP_INPUT_TOO_BIG,
        );
      });
    });

    context("when x is less than or equal to 133.084258667509499440", function () {
      const testSets = [
        toBn("1e-18"),
        toBn("1e-15"),
        toBn("1"),
        toBn("2"),
        E,
        toBn("3"),
        PI,
        toBn("4"),
        toBn("11.89215"),
        toBn("16"),
        toBn("20.82"),
        toBn("33.333333"),
        toBn("64"),
        toBn("71.002"),
        toBn("88.722839111672999627"),
        toBn("133.084258667509499440"),
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = exp(x);
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp(x));
      });
    });
  });
}
