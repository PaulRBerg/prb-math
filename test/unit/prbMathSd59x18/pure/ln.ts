import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, LN_E, LN_MAX_SD59x18, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, ZERO } from "../../../../helpers/constants";
import { fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLn(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathSD59x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSD59x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    const testSets = [
      [fp("0.1"), fp("-2.302585092994045674")],
      [fp("0.2"), fp("-1.609437912434100365")],
      [fp("0.3"), fp("-1.203972804325935984")],
      [fp("0.4"), fp("-0.916290731874155055")],
      [fp("0.5"), fp("-0.693147180559945309")],
      [fp("0.6"), fp("-0.510825623765990674")],
      [fp("0.7"), fp("-0.356674943938732371")],
      [fp("0.8"), fp("-0.223143551314209746")],
      [fp("0.9"), fp("-0.105360515657826292")],
      [fp("1"), ZERO],
      [fp("1.125"), fp("0.117783035656383442")],
      [fp("2"), fp("0.693147180559945309")],
      [E, LN_E],
      [PI, fp("1.144729885849400163")],
      [fp("4"), fp("1.386294361119890619")],
      [fp("8"), fp("2.079441541679835928")],
      [fps("1e18"), fp("41.446531673892822311")],
      [MAX_WHOLE_SD59x18, LN_MAX_SD59x18],
      [MAX_SD59x18, LN_MAX_SD59x18],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSD59x18.doLn(x);
      expect(expected).to.equal(result);
    });
  });
}
