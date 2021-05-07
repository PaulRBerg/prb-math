import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, PI, ZERO } from "../../../../helpers/constants";
import { fp, fpPowOfTwo, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    const x: BigNumber = ZERO;

    context("when the exponent is zero", function () {
      const y: BigNumber = ZERO;

      it("takes 0 and 0 and returns 1", async function () {
        const result: BigNumber = await this.contracts.prbMathUd60x18.doPow(x, y);
        expect(fp("1")).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[fp("1")], [E], [PI]];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const x: BigNumber = ZERO;
        const result: BigNumber = await this.contracts.prbMathUd60x18.doPow(x, y);
        expect(ZERO).to.equal(result);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is lower than the scale", function () {
      const testSets = [
        [sfp("1e-18"), fp("1")],
        [sfp("1e-11"), fp("1")],
        [fp("1").sub(1), fp("1")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doPow(x, y)).to.be.reverted;
      });
    });

    context("when the base is greater than or equal to the scale", function () {
      context("when the exponent is zero", function () {
        const y: BigNumber = ZERO;
        const testSets = [[fp("1")], [E], [PI]];

        forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathUd60x18.doPow(x, y);
          expect(fp("1")).to.equal(result);
        });
      });

      context("when the exponent is not zero", function () {
        const testSets = [
          [fp("1"), fp("1"), fp("1")],
          [fp("1"), PI, fp("1")],
          [fp("2"), fp("1.5"), fp("2.828427124746190097")],
          [E, E, fp("15.154262241479263805")],
          [E, fp("1.66976"), fp("5.310893029888037564")],
          [PI, PI, fp("36.462159607207910473")],
          [fp("11"), fp("28.57142"), fp("567633205010260915186829099843.055402334779500961")],
          [fp("32.15"), fp("23.99"), fp("1436387590627448555144259729881342500.46875")],
          [fp("406"), fp("0.25"), fp("4.488812947719016318")],
          [fp("1729"), fp("0.98"), fp("1489.495149922256917980")],
          [fp("33441"), fp("2.1891"), fp("8018621589.681923269054472305")],
          [fpPowOfTwo(128).sub(1), fp("1"), fp("340282366920938457799039877606991801285")],
        ];

        forEach(testSets).it(
          "takes %e and %e and returns %e",
          async function (x: BigNumber, y: BigNumber, expected: BigNumber) {
            const result: BigNumber = await this.contracts.prbMathUd60x18.doPow(x, y);
            expect(expected).to.equal(result);
          },
        );
      });
    });
  });
}
