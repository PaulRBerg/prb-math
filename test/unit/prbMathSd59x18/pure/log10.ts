import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, EPSILON, EPSILON_MAGNITUDE, MAX_SD59x18, MAX_WHOLE_SD59x18, PI } from "../../../../helpers/constants";
import { max } from "../../../../helpers/ethers.math";
import { log10 } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLog10(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = bn("0");
      await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is negative", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("-0.1");
      await expect(this.contracts.prbMathSd59x18.doLog10(x)).to.be.reverted;
    });
  });

  context("when x is positive", function () {
    context("when x is a power of ten", function () {
      const testSets = [
        ["1e-18"],
        ["1e-17"],
        ["1e-14"],
        ["1e-10"],
        ["1e-8"],
        ["1e-7"],
        ["0.001"],
        ["0.1"],
        ["1"],
        ["10"],
        ["100"],
        ["1e18"],
        ["1e49"],
        ["1e57"],
        ["1e58"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog10(fp(x));
        const expected: BigNumber = fp(log10(x));
        const delta: BigNumber = expected.sub(result).abs();
        expect(delta).to.be.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE)));
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        ["7.892191e-12"],
        ["0.0091"],
        ["0.083"],
        ["0.1982"],
        ["0.313"],
        ["0.4666"],
        ["1.00000000000001"],
        [E],
        [PI],
        ["4"],
        ["16"],
        ["32"],
        ["42.12"],
        ["1010.892143"],
        ["440934.1881"],
        ["1000000000000000000.000000000001"],
        [MAX_WHOLE_SD59x18],
        [MAX_SD59x18],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doLog10(fp(x));
        const expected: BigNumber = fp(log10(x));
        const delta: BigNumber = expected.sub(result).abs();
        expect(delta).to.be.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE)));
      });
    });
  });
}
