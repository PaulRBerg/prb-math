import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  HALF_SCALE,
  MAX_SD59x18,
  MAX_UD60x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SCALE,
  SQRT_MAX_SD59x18,
  ZERO,
} from "../../../../helpers/constants";
import { fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [MIN_SD59x18.add(1), ZERO],
      [fp("0.5"), ZERO],
      [ZERO, fp("0.5")],
    ].concat([
      [ZERO, fp("0.5")],
      [fp("0.5"), ZERO],
      [MAX_SD59x18, ZERO],
    ]);

    forEach(testSets).it("takes %e and %e and returns zero", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSD59x18.doMul(x, y);
      expect(ZERO).to.equal(result);
    });
  });

  context("when neither of the operands is zero", function () {
    context("when one of the operands is min sd59x18", function () {
      const testSets = [
        [MIN_SD59x18, fp("0.000000000000000001")],
        [fp("0.000000000000000001"), MIN_SD59x18],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathSD59x18.doMul(x, y)).to.be.reverted;
      });
    });

    context("when both operands are not min sd59x18", function () {
      context("when the result overflows", function () {
        const testSets = [
          [MIN_SD59x18.add(1), MIN_SD59x18.add(1)],
          [MIN_SD59x18.add(1), fp("2")],
          [MIN_WHOLE_SD59x18, MIN_WHOLE_SD59x18],
          [SQRT_MAX_SD59x18.mul(-1), SQRT_MAX_SD59x18.mul(-1).sub(1)],
        ].concat([
          [fp("2"), MAX_UD60x18],
          [SQRT_MAX_SD59x18, SQRT_MAX_SD59x18.add(1)],
          [MAX_WHOLE_SD59x18, MAX_WHOLE_SD59x18],
          [MAX_SD59x18, MAX_SD59x18],
        ]);

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSD59x18.doMul(x, y)).to.be.reverted;
        });
      });

      context("when the result does not overflow", function () {
        context("when the operands have the same sign", function () {
          const testSets = [
            // We need to add 1 because the absolute value of MIN_SD59x18 is greater by MAX_SD59x18 by 1.
            [MIN_SD59x18.add(HALF_SCALE).add(1), fp("-0.000000000000000001"), MAX_SD59x18.div(SCALE)],
            [MIN_WHOLE_SD59x18.add(HALF_SCALE), fp("-0.000000000000000001"), MAX_WHOLE_SD59x18.div(SCALE)],
            [fps("-1e18"), fps("-1e6"), fps("1e24")],
            [fp("-12983.989"), fp("-782.99"), fp("10166333.54711")],
            [fp("-9817"), fp("-2348"), fp("23050316")],
            [fp("-314.271"), fp("-188.19"), fp("59142.65949")],
            [fp("-18.3"), fp("-12.04"), fp("220.332")],
            [PI.mul(-1), E.mul(-1), fp("8.539734222673567063")],
            [fp("-2.098"), fp("-1.119"), fp("2.347662")],
            [fp("-1"), fp("-1"), fp("1")],
            [fp("-0.01"), fp("-0.05"), fp("0.0005")],
            [fp("-0.001"), fp("-0.01"), fp("0.00001")],
            [fp("-0.00001"), fp("-0.00001"), fp("0.0000000001")],
            [fp("-0.000000000000000006"), fp("-0.1"), fp("0.000000000000000001")],
            [fp("-0.000000000000000001"), fp("-0.000000000000000001"), ZERO],
          ].concat([
            [fp("0.000000000000000001"), fp("0.000000000000000001"), ZERO],
            [fp("0.000000000000000006"), fp("0.1"), fp("0.000000000000000001")],
            [fp("0.000000001"), fp("0.000000001"), fp("0.000000000000000001")],
            [fp("0.00001"), fp("0.00001"), fp("0.0000000001")],
            [fp("0.001"), fp("0.01"), fp("0.00001")],
            [fp("0.01"), fp("0.05"), fp("0.0005")],
            [fp("1"), fp("1"), fp("1")],
            [fp("2.098"), fp("1.119"), fp("2.347662")],
            [PI, E, fp("8.539734222673567063")],
            [fp("18.3"), fp("12.04"), fp("220.332")],
            [fp("314.271"), fp("188.19"), fp("59142.65949")],
            [fp("9817"), fp("2348"), fp("23050316")],
            [fp("12983.989"), fp("782.99"), fp("10166333.54711")],
            [fps("1e18"), fps("1e6"), fps("1e24")],
            [MAX_WHOLE_SD59x18.sub(HALF_SCALE), fp("0.000000000000000001"), MAX_WHOLE_SD59x18.div(SCALE)],
            [MAX_SD59x18.sub(HALF_SCALE), fp("0.000000000000000001"), MAX_SD59x18.div(SCALE)],
          ]);

          forEach(testSets).it(
            "takes %e and %e and returns %e",
            async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
              const result: BigNumber = await this.contracts.prbMathSD59x18.doMul(x, y);
              expect(expected).to.equal(result);
            },
          );
        });

        context("when the operands do not have the same sign", function () {
          const testSets = [
            // Need to add 1 because the absolute value of MIN_SD59x18 is greater by MAX_SD59x18 by 1.
            [MIN_SD59x18.add(HALF_SCALE).add(1), fp("0.000000000000000001"), MIN_SD59x18.div(SCALE)],
            [MIN_WHOLE_SD59x18.add(HALF_SCALE), fp("0.000000000000000001"), MIN_WHOLE_SD59x18.div(SCALE)],
            [fps("-1e18"), fps("1e6"), fps("-1e24")],
            [fp("-12983.989"), fp("782.99"), fp("-10166333.54711")],
            [fp("-9817"), fp("2348"), fp("-23050316")],
            [fp("-314.271"), fp("188.19"), fp("-59142.65949")],
            [fp("-18.3"), fp("12.04"), fp("-220.332")],
            [PI.mul(-1), E, fp("-8.539734222673567063")],
            [fp("-2.098"), fp("1.119"), fp("-2.347662")],
            [fp("-1"), fp("1"), fp("-1")],
            [fp("-0.01"), fp("0.05"), fp("-0.0005")],
            [fp("-0.001"), fp("0.01"), fp("-0.00001")],
            [fp("-0.00001"), fp("0.00001"), fp("-0.0000000001")],
            [fp("-0.000000000000000006"), fp("0.1"), fp("-0.000000000000000001")],
            [fp("-0.000000000000000001"), fp("0.000000000000000001"), ZERO],
          ].concat([
            [fp("0.000000000000000001"), fp("-0.000000000000000001"), ZERO],
            [fp("0.000000000000000006"), fp("-0.1"), fp("-0.000000000000000001")],
            [fp("0.000000001"), fp("-0.000000001"), fp("-0.000000000000000001")],
            [fp("0.00001"), fp("-0.00001"), fp("-0.0000000001")],
            [fp("0.001"), fp("-0.01"), fp("-0.00001")],
            [fp("0.01"), fp("-0.05"), fp("-0.0005")],
            [fp("1"), fp("-1"), fp("-1")],
            [fp("2.098"), fp("-1.119"), fp("-2.347662")],
            [PI, E.mul(-1), fp("-8.539734222673567063")],
            [fp("18.3"), fp("-12.04"), fp("-220.332")],
            [fp("314.271"), fp("-188.19"), fp("-59142.65949")],
            [fp("9817"), fp("-2348"), fp("-23050316")],
            [fp("12983.989"), fp("-782.99"), fp("-10166333.54711")],
            [fps("1e18"), fps("-1e6"), fps("-1e24")],
            [MAX_WHOLE_SD59x18.sub(HALF_SCALE), fp("-0.000000000000000001"), MIN_WHOLE_SD59x18.div(SCALE)],
            [MAX_SD59x18.sub(HALF_SCALE), fp("-0.000000000000000001"), MIN_SD59x18.add(1).div(SCALE)],
          ]);

          forEach(testSets).it(
            "takes %e and %e and returns %e",
            async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
              const result: BigNumber = await this.contracts.prbMathSD59x18.doMul(x, y);
              expect(expected).to.equal(result);
            },
          );
        });
      });
    });
  });
}
