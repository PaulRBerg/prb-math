import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  HALF_UNIT,
  MAX_59x18,
  MAX_WHOLE_59x18,
  MIN_59x18,
  MIN_WHOLE_59x18,
  PI,
  SQRT_MAX_59x18,
  UNIT,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeMul(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [MIN_59x18, ZERO],
      [fp(-0.5), ZERO],
      [ZERO, fp(-0.5)],
    ].concat([
      [ZERO, fp(0.5)],
      [fp(0.5), ZERO],
      [MAX_59x18, ZERO],
    ]);

    forEach(testSets).it("takes %e and %e and returns zero", async function (x: BigNumber, y: BigNumber) {
      const result: BigNumber = await this.contracts.prbMath.doMul(x, y);
      expect(result).to.equal(ZERO);
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the double scaled product overflows", function () {
      const testSets = [
        [MIN_59x18, MIN_59x18],
        [MIN_59x18, bn(-1)],
        [MIN_WHOLE_59x18, MIN_WHOLE_59x18],
        [SQRT_MAX_59x18.mul(-1), SQRT_MAX_59x18.mul(-1).sub(1)],
      ].concat([
        [SQRT_MAX_59x18, SQRT_MAX_59x18.add(1)],
        [MAX_WHOLE_59x18, MAX_WHOLE_59x18],
        [MAX_59x18, MAX_59x18],
      ]);

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMath.doMul(x, y)).to.be.reverted;
      });
    });

    context("when the double scaled product does not overflow", function () {
      context("when the half unit step causes an overflow", function () {
        const testSets = [
          [MIN_59x18, bn(1)],
          [MIN_59x18.add(HALF_UNIT).sub(1), bn(1)],
          [MAX_59x18.sub(HALF_UNIT).add(1), bn(1)],
          [MAX_59x18, bn(1)],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMath.doMul(x, y)).to.be.reverted;
        });
      });

      context("when the half unit step does not cause an overflow", function () {
        context("when the operands have the same sign", function () {
          const testSets = [
            // Need to add 1 because the absolute value of MIN_59x18 is higher by MAX_59x18 by 1.
            [MIN_59x18.add(HALF_UNIT).add(1), fp(-0.000000000000000001), MAX_59x18.div(UNIT)],
            [MIN_WHOLE_59x18.add(HALF_UNIT), fp(-0.000000000000000001), MAX_WHOLE_59x18.div(UNIT)],
            [bn(-1e36), bn(-1e24), bn(1e42)],
            [fp(-12983.989), fp(-782.99), fp(10166333.54711)],
            [fp(-9817), fp(-2348), fp(23050316)],
            [fp(-314.271), fp(-188.19), fp(59142.65949)],
            [fp(-18.3), fp(-12.04), fp(220.332)],
            [PI.mul(-1), E.mul(-1), bn("8539734222673567063")],
            [fp(-2.098), fp(-1.119), fp(2.347662)],
            [fp(-1), fp(-1), fp(1)],
            [fp(-0.01), fp(-0.05), fp(0.0005)],
            [fp(-0.001), fp(-0.01), fp(0.00001)],
            [fp(-0.00001), fp(-0.00001), fp(0.0000000001)],
            [fp(-0.000000000000000006), fp(-0.1), fp(0.000000000000000001)],
            [fp(-0.000000000000000001), fp(-0.000000000000000001), ZERO],
          ].concat([
            [fp(0.000000000000000001), fp(0.000000000000000001), ZERO],
            [fp(0.000000000000000006), fp(0.1), fp(0.000000000000000001)],
            [fp(0.000000001), fp(0.000000001), fp(0.000000000000000001)],
            [fp(0.00001), fp(0.00001), fp(0.0000000001)],
            [fp(0.001), fp(0.01), fp(0.00001)],
            [fp(0.01), fp(0.05), fp(0.0005)],
            [fp(1), fp(1), fp(1)],
            [fp(2.098), fp(1.119), fp(2.347662)],
            [PI, E, bn("8539734222673567063")],
            [fp(18.3), fp(12.04), fp(220.332)],
            [fp(314.271), fp(188.19), fp(59142.65949)],
            [fp(9817), fp(2348), fp(23050316)],
            [fp(12983.989), fp(782.99), fp(10166333.54711)],
            [bn(1e36), bn(1e24), bn(1e42)],
            [MAX_WHOLE_59x18.sub(HALF_UNIT), fp(0.000000000000000001), MAX_WHOLE_59x18.div(UNIT)],
            [MAX_59x18.sub(HALF_UNIT), fp(0.000000000000000001), MAX_59x18.div(UNIT)],
          ]);

          forEach(testSets).it(
            "takes %e and %e and returns %e",
            async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
              const result: BigNumber = await this.contracts.prbMath.doMul(x, y);
              expect(result).to.equal(expected);
            },
          );
        });

        context("when the operands do not have the same sign", function () {
          const testSets = [
            // Need to add 1 because the absolute value of MIN_59x18 is higher by MAX_59x18 by 1.
            [MIN_59x18.add(HALF_UNIT).add(1), fp(0.000000000000000001), MIN_59x18.div(UNIT)],
            [MIN_WHOLE_59x18.add(HALF_UNIT), fp(0.000000000000000001), MIN_WHOLE_59x18.div(UNIT)],
            [bn(-1e36), bn(1e24), bn(-1e42)],
            [fp(-12983.989), fp(782.99), fp(-10166333.54711)],
            [fp(-9817), fp(2348), fp(-23050316)],
            [fp(-314.271), fp(188.19), fp(-59142.65949)],
            [fp(-18.3), fp(12.04), fp(-220.332)],
            [PI.mul(-1), E, bn("-8539734222673567063")],
            [fp(-2.098), fp(1.119), fp(-2.347662)],
            [fp(-1), fp(1), fp(-1)],
            [fp(-0.01), fp(0.05), fp(-0.0005)],
            [fp(-0.001), fp(0.01), fp(-0.00001)],
            [fp(-0.00001), fp(0.00001), fp(-0.0000000001)],
            [fp(-0.000000000000000006), fp(0.1), fp(-0.000000000000000001)],
            [fp(-0.000000000000000001), fp(0.000000000000000001), ZERO],
          ].concat([
            [fp(0.000000000000000001), fp(-0.000000000000000001), ZERO],
            [fp(0.000000000000000006), fp(-0.1), fp(-0.000000000000000001)],
            [fp(0.000000001), fp(-0.000000001), fp(-0.000000000000000001)],
            [fp(0.00001), fp(-0.00001), fp(-0.0000000001)],
            [fp(0.001), fp(-0.01), fp(-0.00001)],
            [fp(0.01), fp(-0.05), fp(-0.0005)],
            [fp(1), fp(-1), fp(-1)],
            [fp(2.098), fp(-1.119), fp(-2.347662)],
            [PI, E.mul(-1), bn("-8539734222673567063")],
            [fp(18.3), fp(-12.04), fp(-220.332)],
            [fp(314.271), fp(-188.19), fp(-59142.65949)],
            [fp(9817), fp(-2348), fp(-23050316)],
            [fp(12983.989), fp(-782.99), fp(-10166333.54711)],
            [bn(1e36), bn(-1e24), bn(-1e42)],
            [MAX_WHOLE_59x18.sub(HALF_UNIT), fp(-0.000000000000000001), MIN_WHOLE_59x18.div(UNIT)],
            [MAX_59x18.sub(HALF_UNIT), fp(-0.000000000000000001), MIN_59x18.add(1).div(UNIT)],
          ]);

          forEach(testSets).it(
            "takes %e and %e and returns %e",
            async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
              const result: BigNumber = await this.contracts.prbMath.doMul(x, y);
              expect(result).to.equal(expected);
            },
          );
        });
      });
    });
  });
}
