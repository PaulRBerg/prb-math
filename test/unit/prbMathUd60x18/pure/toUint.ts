import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE, ZERO } from "../../../../helpers/constants";
import { bn, fp, fps } from "../../../../helpers/numbers";

export default function shouldBehaveLikeToUint(): void {
  context("when x is less than scale", function () {
    const testSets = [[ZERO], [bn("1")], [SCALE.sub(1)]];

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doToUint(x);
      expect(ZERO).to.equal(result);
    });
  });

  context("when x is greater than or equal to scale", function () {
    const testSets = [
      [SCALE, bn("1")],
      [SCALE.add(1), bn("1")],
      [SCALE.mul(2).sub(1), bn("1")],
      [SCALE.mul(2), bn("2")],
      [E, bn("2")],
      [PI, bn("3")],
      [fp("1729"), bn("1729")],
      [fps("4.2e27"), fps("4.2e9")],
      [MAX_WHOLE_UD60x18, MAX_WHOLE_UD60x18.div(SCALE)],
      [MAX_UD60x18, MAX_UD60x18.div(SCALE)],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doToUint(x);
      expect(expected).to.equal(result);
    });
  });
}
