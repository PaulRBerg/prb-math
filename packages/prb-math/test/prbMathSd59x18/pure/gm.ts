import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SQRT_MAX_SD59x18_DIV_BY_SCALE,
} from "../../../helpers/constants";
import { gm } from "../../../helpers/math";
import { PRBMathSD59x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeGm(): void {
  context("when one of the operands is zero", function () {
    const testSets = [
      [Zero, toBn(PI)],
      [toBn(PI), Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doGm(x, y));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doGm(x, y));
    });
  });

  context("when neither of the operands is zero", function () {
    context("when the product of x and y is negative", function () {
      const testSets = [
        [toBn("-7.1"), toBn("20.05")],
        [toBn("-1"), toBn(PI)],
        [toBn(PI), toBn("-1")],
        [toBn("7.1"), toBn("-20.05")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.GmNegativeProduct,
        );
        await expect(this.contracts.prbMathSd59x18Typed.doGm(x, y)).to.be.revertedWith(
          PRBMathSD59x18Errors.GmNegativeProduct,
        );
      });
    });

    context("when the product of x and y is positive", function () {
      context("when the product of x and y overflows", function () {
        const testSets = [
          [toBn(MIN_SD59x18), toBn("2e-18")],
          [toBn(MIN_WHOLE_SD59x18), toBn("3e-18")],
          [toBn(SQRT_MAX_SD59x18_DIV_BY_SCALE).mul(-1), toBn(SQRT_MAX_SD59x18_DIV_BY_SCALE).mul(-1).sub(1)],
        ].concat([
          [toBn(SQRT_MAX_SD59x18_DIV_BY_SCALE).add(1), toBn(SQRT_MAX_SD59x18_DIV_BY_SCALE).add(1)],
          [toBn(MAX_WHOLE_SD59x18), toBn("3e-18")],
          [toBn(MAX_SD59x18), toBn("2e-18")],
        ]);

        forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
          await expect(this.contracts.prbMathSd59x18.doGm(x, y)).to.be.revertedWith(PRBMathSD59x18Errors.GmOverflow);
          await expect(this.contracts.prbMathSd59x18Typed.doGm(x, y)).to.be.revertedWith(
            PRBMathSD59x18Errors.GmOverflow,
          );
        });
      });

      context("when the product of x and y does not overflow", function () {
        const testSets = [
          [MIN_WHOLE_SD59x18, "-1e-18"],
          [`-${SQRT_MAX_SD59x18_DIV_BY_SCALE}`, `-${SQRT_MAX_SD59x18_DIV_BY_SCALE}`],
          ["-2404.8", "-7899.210662"],
          ["-322.47", "-674.77"],
          [`-${PI}`, "-8.2"],
          [`-${E}`, "-89.01"],
          ["-2", "-8"],
          ["-1", "-4"],
          ["-1", "-1"],
        ].concat([
          ["1", "1"],
          ["1", "4"],
          ["2", "8"],
          [E, "89.01"],
          [PI, "8.2"],
          ["322.47", "674.77"],
          ["2404.8", "7899.210662"],
          [SQRT_MAX_SD59x18_DIV_BY_SCALE, SQRT_MAX_SD59x18_DIV_BY_SCALE],
          [MAX_WHOLE_SD59x18, "1e-18"],
          [MAX_SD59x18, "1e-18"],
        ]);

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const expected: BigNumber = toBn(gm(x, y));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18.doGm(toBn(x), toBn(y)));
          expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doGm(toBn(x), toBn(y)));
        });
      });
    });
  });
}
