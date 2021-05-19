import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE } from "../../../../helpers/constants";
import { bn } from "../../../../helpers/numbers";

export default function shouldBehaveLikeToUint(): void {
  context("when x is less than the scale", function () {
    const testSets = [[bn("0")], [bn("1")], [fp(SCALE).sub(1)]];

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doToUint(x);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when x is greater than or equal to the scale", function () {
    const testSets = [
      [fp(SCALE)],
      [fp(SCALE).add(1)],
      [fp(SCALE).mul(2).sub(1)],
      [fp(SCALE).mul(2)],
      [fp(E)],
      [fp(PI)],
      [fp("1729")],
      [fp("4.2e27")],
      [fp(MAX_WHOLE_UD60x18)],
      [fp(MAX_UD60x18)],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doToUint(x);
      const expected: BigNumber = x.div(fp(SCALE));
      expect(expected).to.equal(result);
    });
  });
}
