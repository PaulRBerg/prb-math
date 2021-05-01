import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  LN_E,
  LN_MAX_UD60x18,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SCALE,
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLn(): void {
  context("when x is less than 1", function () {
    const testSets = [ZERO, fp("0.0625"), fp("0.1"), fp("0.5"), fp("0.8"), SCALE.sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathUD60x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is greater than or equal to 1", function () {
    const testSets = [
      [fp("1"), ZERO],
      [fp("1.125"), fp("0.117783035656383442")],
      [fp("2"), fp("0.693147180559945309")],
      [E, LN_E],
      [PI, fp("1.144729885849400163")],
      [fp("4"), fp("1.386294361119890619")],
      [fp("8"), fp("2.079441541679835928")],
      [bn("1e36"), fp("41.446531673892822311")],
      [MAX_WHOLE_UD60x18, LN_MAX_UD60x18],
      [MAX_UD60x18, LN_MAX_UD60x18],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUD60x18.doLn(x);
      expect(expected).to.equal(result);
    });
  });
}
