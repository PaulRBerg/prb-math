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
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = SCALE;
      const y: BigNumber = ZERO;
      await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.reverted;
    });
  });

  context("when the denominator is not zero", function () {
    context("when the denominator is min sd59x18", function () {
      it("reverts", async function () {
        const x: BigNumber = SCALE;
        const y: BigNumber = MIN_SD59x18;
        await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.reverted;
      });
    });

    context("when the denominator is not min sd59x18", function () {
      context("when the numerator is zero", function () {
        const testSets = [sfp("-1e18"), PI.mul(-1), fp("-1"), sfp("-1e-18"), sfp("1e-18"), fp("1"), PI, sfp("1e18")];

        forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doDiv(ZERO, y);
          expect(ZERO).to.equal(result);
        });
      });

      context("when the numerator is not zero", function () {
        context("when the numerator is min sd59x18", function () {
          it("reverts", async function () {
            const x: BigNumber = MIN_SD59x18;
            const y: BigNumber = fp("1");
            await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.reverted;
          });
        });

        context("when the numerator is not min sd59x18", function () {
          context("when the result overflows sd59x18", function () {
            const testSets = [
              [MIN_SD59x18.div(SCALE).sub(1), sfp("1e-18")],
              [MIN_SD59x18.div(SCALE).sub(1), sfp("1e-18")],
              [MAX_SD59x18.div(SCALE).add(1), sfp("1e-18")],
              [MAX_SD59x18.div(SCALE).add(1), sfp("1e-18")],
            ];

            forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
              await expect(this.contracts.prbMathSd59x18.doDiv(x, y)).to.be.reverted;
            });
          });

          context("when the result does not overflow sd59x18", function () {
            context("when the numerator and the denominator have the same sign", function () {
              const testSets = [
                [MIN_SD59x18.div(SCALE), sfp("-1e-18"), MAX_WHOLE_SD59x18],
                [sfp("-1e18"), fp("-1"), sfp("1e18")],
                [fp("-2503"), fp("-918882.11"), fp("0.002723962054283546")],
                [fp("-772.05"), fp("-199.98"), fp("3.860636063606360636")],
                [fp("-100.135"), fp("-100.134"), fp("1.000009986617931971")],
                [fp("-22"), fp("-7"), fp("3.142857142857142857")],
                [fp("-4"), fp("-2"), fp("2")],
                [fp("-2"), fp("-5"), fp("0.4")],
                [fp("-2"), fp("-2"), fp("1")],
                [fp("-0.1"), fp("-0.01"), fp("10")],
                [fp("-0.05"), fp("-0.02"), fp("2.5")],
                [sfp("-1e-5"), fp("-0.00002"), fp("0.5")],
                [sfp("-1e-5"), sfp("-1e-5"), fp("1")],
                [sfp("-1e-18"), fp("-1"), sfp("1e-18")],
                [sfp("-1e-18"), fp("-1").sub(1), ZERO],
                [sfp("-1e-18"), MIN_SD59x18.add(1), ZERO],
              ].concat([
                [sfp("1e-18"), MAX_SD59x18, ZERO],
                [sfp("1e-18"), fp("1").add(1), ZERO],
                [sfp("1e-18"), fp("1"), sfp("1e-18")],
                [sfp("1e-5"), sfp("1e-5"), fp("1")],
                [sfp("1e-5"), fp("0.00002"), fp("0.5")],
                [fp("0.05"), fp("0.02"), fp("2.5")],
                [fp("0.1"), fp("0.01"), fp("10")],
                [fp("2"), fp("2"), fp("1")],
                [fp("2"), fp("5"), fp("0.4")],
                [fp("4"), fp("2"), fp("2")],
                [fp("22"), fp("7"), fp("3.142857142857142857")],
                [fp("100.135"), fp("100.134"), fp("1.000009986617931971")],
                [fp("772.05"), fp("199.98"), fp("3.860636063606360636")],
                [fp("2503"), fp("918882.11"), fp("0.002723962054283546")],
                [sfp("1e18"), fp("1"), sfp("1e18")],
                [MAX_SD59x18.div(SCALE), sfp("1e-18"), MAX_WHOLE_SD59x18],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns %e",
                async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
                  const result: BigNumber = await this.contracts.prbMathSd59x18.doDiv(x, y);
                  expect(expected).to.equal(result);
                },
              );
            });

            context("when the numerator and the denominator do not have the same sign", function () {
              const testSets = [
                [MIN_WHOLE_SD59x18.div(SCALE), sfp("1e-18"), MIN_WHOLE_SD59x18],
                [sfp("-1e18"), fp("1"), sfp("-1e18")],
                [fp("-2503"), fp("918882.11"), fp("-0.002723962054283546")],
                [fp("-772.05"), fp("199.98"), fp("-3.860636063606360636")],
                [fp("-100.135"), fp("100.134"), fp("-1.000009986617931971")],
                [fp("-22"), fp("7"), fp("-3.142857142857142857")],
                [fp("-4"), fp("2"), fp("-2")],
                [fp("-2"), fp("5"), fp("-0.4")],
                [fp("-2"), fp("2"), fp("-1")],
                [fp("-0.1"), fp("0.01"), fp("-10")],
                [fp("-0.05"), fp("0.02"), fp("-2.5")],
                [sfp("-1e-5"), fp("0.00002"), fp("-0.5")],
                [sfp("-1e-5"), sfp("1e-5"), fp("-1")],
                [sfp("-1e-18"), fp("1"), sfp("-1e-18")],
                [sfp("-1e-18"), fp("1").add(1), ZERO],
                [sfp("-1e-18"), MAX_SD59x18, ZERO],
              ].concat([
                [sfp("1e-18"), MIN_SD59x18.add(1), ZERO],
                [sfp("1e-18"), fp("-1").sub(1), ZERO],
                [sfp("1e-18"), fp("-1"), sfp("-1e-18")],
                [sfp("1e-5"), sfp("-1e-5"), fp("-1")],
                [sfp("1e-5"), fp("-0.00002"), fp("-0.5")],
                [fp("0.05"), fp("-0.02"), fp("-2.5")],
                [fp("0.1"), fp("-0.01"), fp("-10")],
                [fp("2"), fp("-2"), fp("-1")],
                [fp("2"), fp("-5"), fp("-0.4")],
                [fp("4"), fp("-2"), fp("-2")],
                [fp("22"), fp("-7"), fp("-3.142857142857142857")],
                [fp("100.135"), fp("-100.134"), fp("-1.000009986617931971")],
                [fp("772.05"), fp("-199.98"), fp("-3.860636063606360636")],
                [fp("2503"), fp("-918882.11"), fp("-0.002723962054283546")],
                [sfp("1e18"), fp("-1"), sfp("-1e18")],
                [MAX_SD59x18.div(SCALE), sfp("-1e-18"), MIN_WHOLE_SD59x18],
              ]);

              forEach(testSets).it(
                "takes %e and %e and returns %e",
                async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
                  const result: BigNumber = await this.contracts.prbMathSd59x18.doDiv(x, y);
                  expect(expected).to.equal(result);
                },
              );
            });
          });
        });
      });
    });
  });
}
