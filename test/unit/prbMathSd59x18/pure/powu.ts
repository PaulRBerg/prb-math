import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, SQRT_MAX_SD59x18, ZERO } from "../../../../helpers/constants";
import { fp, fpPowOfTwo, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikePowu(): void {
  context("when the base is zero", function () {
    const x: BigNumber = ZERO;

    context("when the exponent is zero", function () {
      it("returns 1", async function () {
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathSd59x18.doPowu(x, y);
        expect(fp("1")).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [fp("1"), E, PI];

      forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doPowu(x, y);
        expect(ZERO).to.equal(result);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [fp("1"), E, PI, MAX_SD59x18];
      const expected: BigNumber = fp("1");

      forEach(testSets).it("takes %e and returns 1", async function (x: BigNumber) {
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathSd59x18.doPowu(x, y);
        expect(expected).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows uint256", function () {
        const testSets = [
          [MAX_WHOLE_SD59x18, 2],
          [MAX_SD59x18, 2],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSd59x18.doPowu(x, y)).to.be.reverted;
        });
      });

      context("when the result does not overflow uint256", function () {
        context("when the result overflows sd59x18", function () {
          const testSets = [
            [fp("38685626227668133590.597632"), 3], // smallest number whose cube doesn't fit within MAX_SD59x18
            [SQRT_MAX_SD59x18.add(1), 2],
          ];

          forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
            await expect(this.contracts.prbMathSd59x18.doPowu(x, y)).to.be.reverted;
          });
        });

        context("when the result does not overflow sd59x18", function () {
          const testSets = [
            [fp("0.001"), 3, sfp("1e-9")],
            [fp("0.1"), 2, fp("0.01")],
            [fp("1"), 1, fp("1")],
            [fp("2"), 5, fp("32")],
            [fp("2"), 100, fpPowOfTwo(100)],
            [E, 2, fp("7.389056098930650225")],
            [sfp("1e2"), 4, sfp("1e8")],
            [PI, 3, fp("31.006276680299820162")],
            [fp("5.491"), 19, fp("113077820843204.476043049664958629")],
            [fp("478.77"), 20, fp("400441047687151121501368529571950234763284476825512183.793320584974037932")],
            [fp("6452.166"), 7, fp("465520409372619407422434167.862736844121311696")],
            [sfp("1e18"), 2, sfp("1e36")],
            // Biggest number whose cube fits within MAX_SD59x18
            [
              fp("38685626227668133590.597631999999999999"),
              3,
              fp("57896044618658097711785492504343953922145259302939748255014.626107971862774100"),
            ],
            // Precision errors makes the result not equal to MAX_SD59x18
            [SQRT_MAX_SD59x18, 2, MAX_SD59x18.sub(fp("30389015870.437635377568666707"))],
            [MAX_WHOLE_SD59x18, 1, MAX_WHOLE_SD59x18],
            [MAX_SD59x18, 1, MAX_SD59x18],
          ];

          forEach(testSets).it(
            "takes %e and %e and returns %e",
            async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
              const result: BigNumber = await this.contracts.prbMathSd59x18.doPowu(x, y);
              expect(expected).to.equal(result);
            },
          );
        });
      });
    });
  });
}
