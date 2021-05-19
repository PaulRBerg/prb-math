import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, EPSILON, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../../helpers/constants";
import { log2 } from "../../../../helpers/math";
import { bn } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog2(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = bn("0");
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
      const testSets = [["0.0625"], ["0.125"], ["0.25"], ["0.5"], ["1"], ["2"], ["4"], ["8"], ["16"], ["195"]];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog2(fp(x));
        const expected: BigNumber = fp(log2(x));
        const delta: BigNumber = expected.sub(result).abs();
        expect(delta).to.be.lte(EPSILON);
      });
    });

    context("when x is not a power of two", function () {
      const testSets = [
        ["0.0091"],
        ["0.083"],
        ["0.1"],
        ["0.2"],
        ["0.3"],
        ["0.4"],
        ["0.6"],
        ["0.7"],
        ["0.8"],
        ["0.9"],
        ["1.125"],
        [E],
        [PI],
        ["1e18"],
        [MAX_WHOLE_SD59x18],
        [MAX_SD59x18],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog2(fp(x));
        const expected: BigNumber = fp(log2(x));
        expect(expected).to.be.near(result);
      });
    });
  });
}
