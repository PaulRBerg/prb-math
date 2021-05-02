import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  PI,
  SQRT_2,
  SQRT_MAX_SD59x18_DIV_BY_SCALE,
  ZERO,
} from "../../../../helpers/constants";
import { fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("retrieves zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathSD59x18.doSqrt(x);
      expect(ZERO).to.equal(result);
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-1");
      await expect(this.contracts.prbMathSD59x18.doSqrt(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context(
      "when x is greater than or equal to 57896044618658097711785492504343953926634.992332820282019729",
      function () {
        const testSets = [
          fp("57896044618658097711785492504343953926634.992332820282019729"),
          MAX_WHOLE_SD59x18,
          MAX_SD59x18,
        ];

        forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
          await expect(this.contracts.prbMathSD59x18.doSqrt(x)).to.be.reverted;
        });
      },
    );

    context("when x is less than 57896044618658097711785492504343953926634.992332820282019729", function () {
      const testSets = [
        [fp("0.000000000000000001"), fp("0.000000001")],
        [fp("0.000000000000001"), fp("0.000000031622776601")],
        [fp("1"), fp("1")],
        [fp("2"), SQRT_2],
        [E, fp("1.648721270700128146")],
        [fp("3"), fp("1.732050807568877293")],
        [PI, fp("1.772453850905516027")],
        [fp("4"), fp("2")],
        [fp("16"), fp("4")],
        [fps("1e17"), fp("316227766.016837933199889354")],
        [fps("1e18"), fps("1e9")],
        [fp("12489131238983290393813.123784889921092801"), fp("111754781727.598977910452220959")],
        [fp("1889920002192904839344128288891377.732371920009212883"), fp("43473210166640613.973238162807779776")],
        [fps("1e40"), fps("1e20")],
        [fps("5e40"), fp("223606797749978969640.917366873127623544")],
        [fp("57896044618658097711785492504343953926634.992332820282019728"), SQRT_MAX_SD59x18_DIV_BY_SCALE],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSD59x18.doSqrt(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
