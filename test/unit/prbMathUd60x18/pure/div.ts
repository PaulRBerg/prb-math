import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { EPSILON, MAX_UD60x18, PI, SCALE } from "../../../../helpers/constants";
import { mbn } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeDiv(): void {
  context("when the denominator is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = fp("1");
      const y: BigNumber = bn("0");
      await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.reverted;
    });
  });

  context("when the denominator is not zero", function () {
    context("when the numerator is zero", function () {
      const testSets = ["1e-18", "1", PI, "1e18"];

      forEach(testSets).it("takes %e and returns 0", async function (y: string) {
        const x: BigNumber = bn("0");
        const result: BigNumber = await this.contracts.prbMathUd60x18.doDiv(x, fp(y));
        expect(bn("0")).to.equal(result);
      });
    });

    context("when the numerator is not zero", function () {
      context("when the scaled numerator overflows", function () {
        const testSets = [
          [fp(MAX_UD60x18).div(fp(SCALE)).add(1), fp("1e-18")],
          [fp(MAX_UD60x18).div(fp(SCALE)).add(1), fp("1e-18")],
        ];

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathUd60x18.doDiv(x, y)).to.be.reverted;
        });
      });

      context("when the scaled numerator does not overflow", function () {
        const testSets = [
          ["1e-18", MAX_UD60x18],
          ["1e-18", "1.000000000000000001"],
          ["1e-18", "1"],
          ["1e-5", "1e-5"],
          ["1e-5", "2e-5"],
          ["0.05", "0.02"],
          ["0.1", "0.01"],
          ["2", "2"],
          ["2", "5"],
          ["4", "2"],
          ["22", "7"],
          ["100.135", "100.134"],
          ["772.05", "199.98"],
          ["2503", "918882.11"],
          ["1e18", "1"],
          ["115792089237316195423570985008687907853269.984665640564039457", "1e-18"],
        ];

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const result: BigNumber = await this.contracts.prbMathUd60x18.doDiv(fp(x), fp(y));
          const expected: BigNumber = fp(mbn(x).div(mbn(y)));
          const delta: BigNumber = expected.sub(result).abs();
          expect(delta).to.be.lte(EPSILON);
        });
      });
    });
  });
}
