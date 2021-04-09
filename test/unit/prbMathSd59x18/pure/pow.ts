import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_SD59x18, MAX_WHOLE_SD59x18, PI, SQRT_MAX_SD59x18, ZERO } from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    context("when the exponent is zero", function () {
      it("returns 1e18", async function () {
        const x: BigNumber = ZERO;
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathSD59x18.doPow(x, y);
        expect(result).to.equal(fp(1));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [fp(1), E, PI];

      forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
        const x: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathSD59x18.doPow(x, y);
        expect(result).to.equal(ZERO);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [fp(1), E, PI, MAX_SD59x18];
      const expected: BigNumber = fp(1);

      forEach(testSets).it("takes %e and returns 1e18", async function (x: BigNumber) {
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathSD59x18.doPow(x, y);
        expect(expected).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows", function () {
        const testSets = [
          [bn("38685626227668133590597632000000000000"), 3], // first number whose cube doesn't fit within MAX_SD59x18
          [SQRT_MAX_SD59x18.add(1), 2],
          [MAX_WHOLE_SD59x18, 2],
          [MAX_SD59x18, 2],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSD59x18.doPow(x, y)).to.be.reverted;
        });
      });

      context("when the result does not overflow", function () {
        const testSets = [
          [fp(0.001), 3, fp(0.000000001)],
          [fp(0.1), 2, fp(0.01)],
          [fp(1), 1, fp(1)],
          [fp(2), 5, fp(32)],
          [fp(2), 100, fpPowOfTwo(100)],
          [E, 2, bn("7389056098930650225")],
          [fp(100), 4, bn(1e26)],
          [PI, 3, bn("31006276680299820158")],
          [fp(5.491), 19, bn("113077820843204476043049664958463")],
          [fp(478.77), 20, bn("400441047687151121501368529571950234763284476825512183793320584974037932")],
          [fp(6452.166), 7, bn("465520409372619407422434167862736844121311696")],
          [bn(1e36), 2, bn(1e54)],
          // First number whose cube fits within MAX_SD59x18
          [
            bn("38685626227668133590597631999999999999"),
            3,
            bn("57896044618658097711785492504343953922145259302939748254975940481744194640509"),
          ],
          // Precision errors makes the result not equal to MAX_SD59x18
          [SQRT_MAX_SD59x18, 2, MAX_SD59x18.sub(bn("30389015870437635377568666707"))],
          [MAX_WHOLE_SD59x18, 1, MAX_WHOLE_SD59x18],
          [MAX_SD59x18, 1, MAX_SD59x18],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns %e",
          async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
            const result: BigNumber = await this.contracts.prbMathSD59x18.doPow(x, y);
            expect(expected).to.equal(result);
          },
        );
      });
    });
  });
}
