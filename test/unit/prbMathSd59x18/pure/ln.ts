import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, EPSILON, EPSILON_MAGNITUDE, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../../helpers/constants";
import { max } from "../../../../helpers/ethers.math";
import { ln } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLn(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = bn("0");
      await expect(this.contracts.prbMathSd59x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    const testSets = [
      ["0.1"],
      ["0.2"],
      ["0.3"],
      ["0.4"],
      ["0.5"],
      ["0.6"],
      ["0.7"],
      ["0.8"],
      ["0.9"],
      ["1"],
      ["1.125"],
      ["2"],
      [E],
      [PI],
      ["4"],
      ["8"],
      ["1e18"],
      [MAX_WHOLE_SD59x18],
      [MAX_SD59x18],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doLn(fp(x));
      const expected: BigNumber = fp(ln(x));
      const delta: BigNumber = expected.sub(result).abs();
      expect(delta).to.be.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE)));
    });
  });
}
