import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18, ZERO } from "../../../../helpers/constants";
import { bn, fp, fpPowOfTwo } from "../../../../helpers/numbers";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    context("when the exponent is zero", function () {
      it("retrieves 1e18", async function () {
        const x: BigNumber = ZERO;
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathUD60x18.doPow(x, y);
        expect(fp(1)).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [fp(1), E, PI];

      forEach(testSets).it("takes %e and returns zero", async function (y: BigNumber) {
        const x: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathUD60x18.doPow(x, y);
        expect(ZERO).to.equal(result);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the exponent is zero", function () {
      const testSets = [fp(1), E, PI, MAX_UD60x18];
      const expected: BigNumber = fp(1);

      forEach(testSets).it("takes %e and returns 1e18", async function (x: BigNumber) {
        const y: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathUD60x18.doPow(x, y);
        expect(expected).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      context("when the result overflows ud60x18", function () {
        const testSets = [
          [bn("48740834812604276470692694885616578542"), 3], // smallest number whose cube doesn't fit within MAX_UD60x18
          [SQRT_MAX_UD60x18.add(1), 2],
          [MAX_WHOLE_UD60x18, 2],
          [MAX_UD60x18, 2],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUD60x18.doPow(x, y)).to.be.reverted;
        });
      });

      context("when the result does not overflow ud60x18", function () {
        const testSets = [
          [fp(0.001), 3, fp(0.000000001)],
          [fp(0.1), 2, fp(0.01)],
          [fp(1), 1, fp(1)],
          [fp(2), 5, fp(32)],
          [fp(2), 100, fpPowOfTwo(100)],
          [E, 2, bn("7389056098930650225")],
          [fp(100), 4, bn(1e26)],
          [PI, 3, bn("31006276680299820162")],
          [fp(5.491), 19, bn("113077820843204476043049664958629")],
          [fp(478.77), 20, bn("400441047687151121501368529571950234763284476825512183793320584974037932")],
          [fp(6452.166), 7, bn("465520409372619407422434167862736844121311696")],
          [bn(1e36), 2, bn(1e54)],
          // Biggest number whose cube fits within MAX_UD60x18
          [
            bn("48740834812604276470692694885616578541"),
            3,
            bn("115792089237316195423570985008687907850073444262747922508502840585837564041865"),
          ],
          // Precision errors makes the result not equal to MAX_UD60x18
          [SQRT_MAX_UD60x18, 2, MAX_UD60x18.sub(bn("680564733841876926926749214863"))],
          [MAX_WHOLE_UD60x18, 1, MAX_WHOLE_UD60x18],
          [MAX_UD60x18, 1, MAX_UD60x18],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns %e",
          async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
            const result: BigNumber = await this.contracts.prbMathUD60x18.doPow(x, y);
            expect(expected).to.equal(result);
          },
        );
      });
    });
  });
}
