import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_SD59x18, MAX_WHOLE_SD59x18, MIN_SD59x18, MIN_WHOLE_SD59x18 } from "../../../helpers/constants";
import { avg } from "../../../helpers/ethers.math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeAvg(): void {
  context("when both operands are zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = bn("0");
      const y: BigNumber = bn("0");
      const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when one operand is zero and the other is not zero", function () {
    const testSets = [
      [fp("4"), fp("0")],
      [fp("0"), fp("4")],
      [fp("0"), fp("4")],
      [fp("4"), fp("0")],
    ];

    forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
      const expected: BigNumber = avg(x, y);
      expect(expected).to.equal(result);
    });
  });

  context("when one operand is negative and the other is positive", function () {
    const testSets = [
      [fp(MIN_WHOLE_SD59x18), fp(MAX_WHOLE_SD59x18)],
      [fp("-4"), fp("4")],
      [fp("-2"), fp("8")],
      [fp("4"), fp("-4")],
      [fp("8"), fp("-2")],
      [fp(MIN_SD59x18), fp(MAX_SD59x18)],
    ];

    forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
      const expected: BigNumber = avg(x, y);
      expect(expected).to.equal(result);
    });
  });

  context("when both operands are negative", function () {
    const testSets = [
      [fp(MIN_WHOLE_SD59x18), fp(MIN_SD59x18)],
      [fp("1e-18"), fp("3e-18")],
      [fp("100"), fp("200")],
      [fp("4"), fp("8")],
      [fp("1"), fp("1")],
      [fp("1"), fp("2")],
    ];

    forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
      const expected: BigNumber = avg(x, y);
      expect(expected).to.equal(result);
    });
  });

  context("when both operands are positive", function () {
    context("when both operands are odd", function () {
      const testSets = [
        [fp("1e-18"), fp("3e-18")],
        [fp("1"), fp("1")],
        [fp("3"), fp("7")],
        [fp("99"), fp("199")],
        [fp("1000000000000000001"), fp("10000000000000000001")],
        [fp(MAX_SD59x18), fp(MAX_SD59x18)],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(result);
        },
      );
    });

    context("when both operands are even", function () {
      const testSets = [
        [fp("2e-18"), fp("4e-18")],
        [fp("2"), fp("2")],
        [fp("4"), fp("8")],
        [fp("100"), fp("200")],
        [fp("1e18"), fp("1e19")],
        [fp(MIN_WHOLE_SD59x18), fp(MIN_WHOLE_SD59x18)],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(result);
        },
      );
    });

    context("when one operand is even and the other is odd", function () {
      const testSets = [
        [fp("1e-18"), fp("2e-18")],
        [fp("1"), fp("2")],
        [fp("3"), fp("8")],
        [fp("99"), fp("200")],
        [fp("1e18"), fp("10000000000000000001")],
        [fp(MAX_WHOLE_SD59x18), fp(MAX_SD59x18)],
      ];

      forEach(testSets).it(
        "takes %e and %e and returns the correct value",
        async function (x: BigNumber, y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doAvg(x, y);
          const expected: BigNumber = avg(x, y);
          expect(expected).to.equal(result);
        },
      );
    });
  });
}
