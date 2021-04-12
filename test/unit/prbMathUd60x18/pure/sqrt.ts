import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SQRT_2,
  SQRT_MAX_UD60x18_DIV_BY_SCALE,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeSqrt(): void {
  context("when x is zero", function () {
    it("retrieves zero", async function () {
      const x: BigNumber = ZERO;
      const result: BigNumber = await this.contracts.prbMathUD60x18.doSqrt(x);
      expect(ZERO).to.equal(result);
    });
  });

  context("when x is positive", function () {
    context("when x is 115792089237316195423570985008687907853269984665640564039458 or greater", function () {
      const testSets = [
        bn("115792089237316195423570985008687907853269984665640564039458"),
        MAX_WHOLE_UD60x18,
        MAX_UD60x18,
      ];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathUD60x18.doSqrt(x)).to.be.reverted;
      });
    });

    context("when x is less than 115792089237316195423570985008687907853269984665640564039458", function () {
      const testSets = [
        [fp(0.000000000000000001), fp(0.000000001)],
        [fp(0.000000000000001), fp(0.000000031622776601)],
        [fp(1), fp(1)],
        [fp(2), SQRT_2],
        [E, bn("1648721270700128146")],
        [fp(3), bn("1732050807568877293")],
        [PI, bn("1772453850905516027")],
        [fp(4), fp(2)],
        [fp(16), fp(4)],
        [bn(1e35), bn("316227766016837933199889354")],
        [bn(1e36), bn(1e27)],
        [bn("12489131238983290393813123784889921092801"), bn("111754781727598977910452220959")],
        [bn("1889920002192904839344128288891377732371920009212883"), bn("43473210166640613973238162807779776")],
        [bn(1e58), bn(1e38)],
        [bn(5e58), bn("223606797749978969640917366873127623544")],
        [bn("115792089237316195423570985008687907853269984665640564039457"), SQRT_MAX_UD60x18_DIV_BY_SCALE],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathUD60x18.doSqrt(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
