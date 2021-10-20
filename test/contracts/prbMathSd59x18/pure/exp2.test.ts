import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../../src/constants";
import { PRBMathSD59x18Errors } from "../../../../src/errors";
import { exp2 } from "../../../../src/functions";

export function shouldBehaveLikeExp2(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = toBn("1");
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp2(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp2(x));
    });
  });

  context("when x is negative", function () {
    context("when x is less than -59.794705707972522261", function () {
      const testSets = [toBn("-59.794705707972522262"), MIN_WHOLE_SD59x18, MIN_SD59x18];

      forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
        const expected: BigNumber = Zero;
        expect(expected).to.equal(await this.contracts.prbMathSd59x18.doExp2(x));
        expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doExp2(x));
      });
    });

    context("when x is greater than or equal to -59.794705707972522261", function () {
      const testSets = [
        toBn("-59.794705707972522261"),
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
        const expected: BigNumber = exp2(x);
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp2(x));
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 192", function () {
      const testSets = [toBn("192"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp2(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.EXP2_INPUT_TOO_BIG,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doExp2(x)).to.be.revertedWith(
          PRBMathSD59x18Errors.EXP2_INPUT_TOO_BIG,
        );
      });
    });

    context("when x is less than 192", function () {
      const testSets = [
        toBn("1e-18"),
        toBn("1e-15"),
        toBn("0.3212"),
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
        toBn("88.7494"),
        toBn("95"),
        toBn("127"),
        toBn("152.9065"),
        toBn("191.999999999999999999"),
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
        const expected: BigNumber = exp2(x);
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18.doExp2(x));
        expect(expected).to.be.near(await this.contracts.prbMathSd59x18Typed.doExp2(x));
      });
    });
  });
}
