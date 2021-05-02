import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  ZERO,
} from "../../../../helpers/constants";
import { fp, fps, solidityMod, solidityModByScale } from "../../../../helpers/numbers";

export default function shouldBehaveLikeFrac(): void {
  context("when x is zero", function () {
    it("works", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSD59x18.doFrac(x);
      expect(ZERO).to.equal(result);
    });
  });

  context("when x is negative", function () {
    const testSets = [
      [MIN_SD59x18, solidityModByScale(MIN_SD59x18)],
      [MIN_WHOLE_SD59x18, ZERO],
      [fps("-1e18"), ZERO],
      [fp("-4.2"), fp("-0.2")],
      [PI.mul(-1), solidityMod(PI.mul(-1), fp("1"))],
      [fp("-2"), ZERO],
      [fp("-1.125"), fp("-0.125")],
      [fp("-1"), ZERO],
      [fp("-0.5"), fp("-0.5")],
      [fp("-0.1"), fp("-0.1")],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSD59x18.doFrac(x);
      expect(expected).to.equal(result);
    });
  });

  context("when x is positive", function () {
    const testSets = [
      [fp("0.1"), fp("0.1")],
      [fp("0.5"), fp("0.5")],
      [fp("1"), ZERO],
      [fp("1.125"), fp("0.125")],
      [fp("2"), ZERO],
      [PI, solidityModByScale(PI)],
      [fp("4.2"), fp("0.2")],
      [fps("1e18"), ZERO],
      [MAX_WHOLE_SD59x18, ZERO],
      [MAX_SD59x18, solidityModByScale(MAX_SD59x18)],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSD59x18.doFrac(x);
      expect(expected).to.equal(result);
    });
  });
}
