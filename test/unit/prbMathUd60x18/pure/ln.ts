import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  EPSILON,
  EPSILON_MAGNITUDE,
  MAX_UD60x18,
  MAX_WHOLE_UD60x18,
  PI,
  SCALE,
} from "../../../../helpers/constants";
import { max } from "../../../../helpers/ethers.math";
import { ln } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLn(): void {
  context("when x is less than 1", function () {
    const testSets = [bn("0"), fp("0.0625"), fp("0.1"), fp("0.5"), fp("0.8"), fp("1").sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = bn("0");
      await expect(this.contracts.prbMathUd60x18.doLn(x)).to.be.reverted;
    });
  });

  context("when x is greater than or equal to 1", function () {
    const testSets = [["1"], ["1.125"], ["2"], [E], [PI], ["4"], ["8"], ["1e18"], [MAX_WHOLE_UD60x18], [MAX_UD60x18]];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doLn(fp(x));
      const expected: BigNumber = fp(ln(x));
      const delta: BigNumber = expected.sub(result).abs();
      expect(delta).to.be.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE)));
    });
  });
}
