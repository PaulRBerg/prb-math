import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SQRT_MAX_UD60x18_DIV_BY_SCALE } from "../../../helpers/constants";
import { gm } from "../../../helpers/math";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeGm(): void {
  context("when the product of x and y is zero", function () {
    const testSets = [
      [Zero, fp(PI)],
      [fp(PI), Zero],
    ];

    forEach(testSets).it("takes %e and %e and returns 0", async function (x: BigNumber, y: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doGm(x, y));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doGm(x, y));
    });
  });

  context("when the product of x and y is not zero", function () {
    context("when the product of x and y overflows", function () {
      const testSets = [
        [fp(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1), fp(SQRT_MAX_UD60x18_DIV_BY_SCALE).add(1)],
        [fp(MAX_WHOLE_UD60x18), fp("3e-18")],
        [fp(MAX_UD60x18), fp("2e-18")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doGm(x, y)).to.be.revertedWith(PRBMathUD60x18Errors.GmOverflow);
        await expect(this.contracts.prbMathUd60x18Typed.doGm(x, y)).to.be.revertedWith(PRBMathUD60x18Errors.GmOverflow);
      });
    });

    context("when the product of x and y does not overflow", function () {
      const testSets = [
        ["1", "1"],
        ["1", "4"],
        ["2", "8"],
        [E, "89.01"],
        [PI, "8.2"],
        ["322.47", "674.77"],
        ["2404.8", "7899.210662"],
        [SQRT_MAX_UD60x18_DIV_BY_SCALE, SQRT_MAX_UD60x18_DIV_BY_SCALE],
        [MAX_WHOLE_UD60x18, "1e-18"],
        [MAX_UD60x18, "1e-18"],
      ];

      forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
        const expected: BigNumber = fp(gm(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doGm(fp(x), fp(y)));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doGm(fp(x), fp(y)));
      });
    });
  });
}
