import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LOG2_MAX_SD59x18, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, ZERO } from "../../../../helpers/constants";
import { fp, fpPowOfTwo, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLog2(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is a power of two", function () {
      const testSets = [
        [fp("0.0625"), fp("-4")],
        [fp("0.125"), fp("-3")],
        [fp("0.25"), fp("-2")],
        [fp("0.5"), fp("-1")],
        [fp("1"), ZERO],
        [fp("2"), fp("1")],
        [fp("4"), fp("2")],
        [fp("8"), fp("3")],
        [fp("16"), fp("4")],
        [fpPowOfTwo(195), fp("195")],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog2(x);
        expect(expected).to.equal(result);
      });
    });

    context("when x is not a power of two", function () {
      const testSets = [
        [fp("0.0091"), fp("-6.779917739350753112")],
        [fp("0.083"), fp("-3.590744853315162277")],
        [fp("0.1"), fp("-3.321928094887362334")],
        [fp("0.2"), fp("-2.321928094887362334")],
        [fp("0.3"), fp("-1.736965594166206154")],
        [fp("0.4"), fp("-1.321928094887362334")],
        [fp("0.6"), fp("-0.736965594166206154")],
        [fp("0.7"), fp("-0.514573172829758229")],
        [fp("0.8"), fp("-0.321928094887362334")],
        [fp("0.9"), fp("-0.152003093445049973")],
        [fp("1.125"), fp("0.169925001442312346")],
        [E, fp("1.442695040888963394")],
        [PI, fp("1.651496129472318782")],
        [sfp("1e18"), fp("59.794705707972522245")],
        [MAX_WHOLE_SD59x18, LOG2_MAX_SD59x18],
        [MAX_SD59x18, LOG2_MAX_SD59x18],
      ];

      forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog2(x);
        expect(expected).to.equal(result);
      });
    });
  });
}
