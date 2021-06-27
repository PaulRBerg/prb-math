import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, SCALE } from "../../../helpers/constants";
import { bn } from "../../../helpers/numbers";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeFromUint(): void {
  context("when x is greater than max ud60x18 divided by scale", function () {
    const testSets = [[fp(MAX_WHOLE_UD60x18).div(fp(SCALE)).add(1)], [fp(MAX_WHOLE_UD60x18)], [fp(MAX_UD60x18)]];

    forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
      await expect(this.contracts.prbMathUd60x18.doFromUint(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.FromUintOverflow,
      );
      await expect(this.contracts.prbMathUd60x18Typed.doFromUint(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.FromUintOverflow,
      );
    });
  });

  context("when x is less than or equal to max ud60x18 divided by scale", function () {
    const testSets = [
      [bn("1")],
      [bn("2")],
      [bn("1729")],
      [fp("1")],
      [fp("5")],
      [fp("1e18")],
      [fp("2.7182e20")],
      [fp("3.1415e24")],
      [fp(MAX_WHOLE_UD60x18).div(fp(SCALE))],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = x.mul(fp(SCALE));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFromUint(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFromUint(x));
    });
  });
}
