import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18, PI } from "../../../helpers/constants";
import { exp } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = bn("0");
      const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
      expect(fp("1")).to.equal(result);
    });
  });

  context("when x is negative", function () {
    context("when x is less than -41.446531673892822322", function () {
      const testSets = [fp("-41.446531673892822323"), fp(MIN_WHOLE_SD59x18), fp(MIN_SD59x18)];

      forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(x);
        expect(bn("0")).to.equal(result);
      });
    });

    context("when x is greater than or equal to -41.446531673892822322", function () {
      const testSets = [
        ["-41.446531673892822322"],
        ["-33.333333"],
        ["-20.82"],
        ["-16"],
        ["-11.89215"],
        ["-4"],
        ["-" + PI],
        ["-3"],
        ["-" + E],
        ["-2"],
        ["-1"],
        ["-1e-15"],
        ["-1e-18"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(fp(x));
        const expected: BigNumber = fp(exp(x));
        expect(expected).to.be.near(result);
      });
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 88.722839111672999628", function () {
      const testSets = [fp("88.722839111672999628"), MAX_WHOLE_SD59x18, MAX_SD59x18];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doExp(x)).to.be.reverted;
      });
    });

    context("when x is less than 88.722839111672999628", function () {
      const testSets = [
        ["1e-18"],
        ["1e-15"],
        ["1"],
        ["2"],
        [E],
        ["3"],
        [PI],
        ["4"],
        ["11.89215"],
        ["16"],
        ["20.82"],
        ["33.333333"],
        ["64"],
        ["71.002"],
        ["88.722839111672999627"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doExp(fp(x));
        const expected: BigNumber = fp(exp(x));
        expect(expected).to.be.near(result);
      });
    });
  });
}
