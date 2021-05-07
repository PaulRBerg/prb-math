import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, SCALE } from "../../../../helpers/constants";
import { bn, fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeFromUint(): void {
  context("when x is greater than max ud60x18 divided by scale", function () {
    const testSets = [[MAX_WHOLE_UD60x18.div(SCALE).add(1)], [MAX_WHOLE_UD60x18], [MAX_UD60x18]];

    forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
      await expect(this.contracts.prbMathUd60x18.doFromUint(x)).to.be.reverted;
    });
  });

  context("when x is less than or equal to max ud60x18 divided by scale", function () {
    const testSets = [
      [bn("1"), fp("1")],
      [bn("2"), fp("2")],
      [bn("1729"), fp("1729")],
      [fp("1"), fps("1e18")],
      [fp("5"), fps("5e18")],
      [fps("1e18"), fps("1e36")],
      [fps("2.7182e20"), fps("2.7182e38")],
      [fps("3.1415e24"), fps("3.1415e42")],
      [MAX_WHOLE_UD60x18.div(SCALE), MAX_WHOLE_UD60x18],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doFromUint(x);
      expect(expected).to.equal(result);
    });
  });
}
