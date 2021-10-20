import type { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, SCALE } from "../../../../src/constants";
import { PRBMathUD60x18Errors } from "../../../../src/errors";

export function shouldBehaveLikeFromUint(): void {
  context("when x is greater than max ud60x18 divided by scale", function () {
    const testSets = [MAX_WHOLE_UD60x18.div(SCALE).add(1), MAX_WHOLE_UD60x18, MAX_UD60x18];

    forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
      await expect(this.contracts.prbMathUd60x18.doFromUint(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.FROM_UINT_OVERFLOW,
      );
      await expect(this.contracts.prbMathUd60x18Typed.doFromUint(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.FROM_UINT_OVERFLOW,
      );
    });
  });

  context("when x is less than or equal to max ud60x18 divided by scale", function () {
    const testSets = [
      [toBn("1e-18")],
      [toBn("2e-18")],
      [toBn("1729e-18")],
      [toBn("1")],
      [toBn("5")],
      [toBn("1e18")],
      [toBn("2.7182e20")],
      [toBn("3.1415e24")],
      MAX_WHOLE_UD60x18.div(SCALE),
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = x.mul(SCALE);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFromUint(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFromUint(x));
    });
  });
}
