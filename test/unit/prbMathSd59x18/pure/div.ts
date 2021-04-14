import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SCALE,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = SCALE;
      const y: BigNumber = ZERO;
      await expect(this.contracts.prbMathSD59x18.doDiv(x, y)).to.be.reverted;
    });
  });

  context("when the denominator is not zero", function () {
    context("when the denominator is min sd59x18", function () {
      it("reverts", async function () {
        const x: BigNumber = SCALE;
        const y: BigNumber = MIN_SD59x18;
        await expect(this.contracts.prbMathSD59x18.doDiv(x, y)).to.be.reverted;
      });
    });

    context("when the denominator is not min sd59x18", function () {
      context("when the numerator is zero", function () {
        const testSets = [
          bn(-1e36),
          fp(-0.000000000000000001),
          PI.mul(-1),
          fp(-1),
          fp(0.000000000000000001),
          fp(1),
          PI,
          bn(1e36),
        ];

        forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSD59x18.doDiv(ZERO, y);
          expect(ZERO).to.equal(result);
        });
      });

      context("when the numerator is not zero", function () {
        context("when the result overflows max sd59x18", function () {
          const testSets = [
            [MIN_SD59x18.div(SCALE).sub(1), fp(-0.000000000000000001)],
            [MIN_SD59x18.div(SCALE).sub(1), fp(0.000000000000000001)],
            [MAX_SD59x18.div(SCALE).add(1), fp(-0.000000000000000001)],
            [MAX_SD59x18.div(SCALE).add(1), fp(0.000000000000000001)],
          ];

          forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
            await expect(this.contracts.prbMathSD59x18.doDiv(x, y)).to.be.reverted;
          });
        });

        context("when the result does not overflow max sd59x18", function () {
          context("when the numerator and the denominator have the same sign", function () {
            const testSets = [
              [MIN_SD59x18.div(SCALE), fp(-0.000000000000000001), MAX_WHOLE_SD59x18],
              [bn(-1e36), fp(-1), bn(1e36)],
              [fp(-2503), fp(-918882.11), bn("2723962054283546")],
              [fp(-772.05), fp(-199.98), bn("3860636063606360636")],
              [fp(-100.135), fp(-100.134), bn("1000009986617931971")],
              [fp(-22), fp(-7), bn("3142857142857142857")],
              [fp(-4), fp(-2), fp(2)],
              [fp(-2), fp(-5), fp(0.4)],
              [fp(-2), fp(-2), fp(1)],
              [fp(-0.1), fp(-0.01), fp(10)],
              [fp(-0.05), fp(-0.02), fp(2.5)],
              [fp(-0.00001), fp(-0.00002), fp(0.5)],
              [fp(-0.00001), fp(-0.00001), fp(1)],
              [fp(-0.000000000000000001), fp(-1), fp(0.000000000000000001)],
              [fp(-0.000000000000000001), fp(-1).sub(1), ZERO],
              [fp(-0.000000000000000001), MIN_SD59x18.add(1), ZERO],
            ].concat([
              [fp(0.000000000000000001), MAX_SD59x18, ZERO],
              [fp(0.000000000000000001), fp(1).add(1), ZERO],
              [fp(0.000000000000000001), fp(1), fp(0.000000000000000001)],
              [fp(0.00001), fp(0.00001), fp(1)],
              [fp(0.00001), fp(0.00002), fp(0.5)],
              [fp(0.05), fp(0.02), fp(2.5)],
              [fp(0.1), fp(0.01), fp(10)],
              [fp(2), fp(2), fp(1)],
              [fp(2), fp(5), fp(0.4)],
              [fp(4), fp(2), fp(2)],
              [fp(22), fp(7), bn("3142857142857142857")],
              [fp(100.135), fp(100.134), bn("1000009986617931971")],
              [fp(772.05), fp(199.98), bn("3860636063606360636")],
              [fp(2503), fp(918882.11), bn("2723962054283546")],
              [bn(1e36), fp(1), bn(1e36)],
              [MAX_SD59x18.div(SCALE), fp(0.000000000000000001), MAX_WHOLE_SD59x18],
            ]);

            forEach(testSets).it(
              "takes %e and %e and returns %e",
              async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
                const result: BigNumber = await this.contracts.prbMathSD59x18.doDiv(x, y);
                expect(expected).to.equal(result);
              },
            );
          });

          context("when the numerator and the denominator do not have the same sign", function () {
            const testSets = [
              [MIN_WHOLE_SD59x18.div(SCALE), fp(0.000000000000000001), MIN_WHOLE_SD59x18],
              [bn(-1e36), fp(1), bn(-1e36)],
              [fp(-2503), fp(918882.11), bn("-2723962054283546")],
              [fp(-772.05), fp(199.98), bn("-3860636063606360636")],
              [fp(-100.135), fp(100.134), bn("-1000009986617931971")],
              [fp(-22), fp(7), bn("-3142857142857142857")],
              [fp(-4), fp(2), fp(-2)],
              [fp(-2), fp(5), fp(-0.4)],
              [fp(-2), fp(2), fp(-1)],
              [fp(-0.1), fp(0.01), fp(-10)],
              [fp(-0.05), fp(0.02), fp(-2.5)],
              [fp(-0.00001), fp(0.00002), fp(-0.5)],
              [fp(-0.00001), fp(0.00001), fp(-1)],
              [fp(-0.000000000000000001), fp(1), fp(-0.000000000000000001)],
              [fp(-0.000000000000000001), fp(1).add(1), ZERO],
              [fp(-0.000000000000000001), MAX_SD59x18, ZERO],
            ].concat([
              [fp(0.000000000000000001), MIN_SD59x18.add(1), ZERO],
              [fp(0.000000000000000001), fp(-1).sub(1), ZERO],
              [fp(0.000000000000000001), fp(-1), fp(-0.000000000000000001)],
              [fp(0.00001), fp(-0.00001), fp(-1)],
              [fp(0.00001), fp(-0.00002), fp(-0.5)],
              [fp(0.05), fp(-0.02), fp(-2.5)],
              [fp(0.1), fp(-0.01), fp(-10)],
              [fp(2), fp(-2), fp(-1)],
              [fp(2), fp(-5), fp(-0.4)],
              [fp(4), fp(-2), fp(-2)],
              [fp(22), fp(-7), bn("-3142857142857142857")],
              [fp(100.135), fp(-100.134), bn("-1000009986617931971")],
              [fp(772.05), fp(-199.98), bn("-3860636063606360636")],
              [fp(2503), fp(-918882.11), bn("-2723962054283546")],
              [bn(1e36), fp(-1), bn(-1e36)],
              [MAX_SD59x18.div(SCALE), fp(-0.000000000000000001), MIN_WHOLE_SD59x18],
            ]);

            forEach(testSets).it(
              "takes %e and %e and returns %e",
              async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
                const result: BigNumber = await this.contracts.prbMathSD59x18.doDiv(x, y);
                expect(expected).to.equal(result);
              },
            );
          });
        });
      });
    });
  });
}
