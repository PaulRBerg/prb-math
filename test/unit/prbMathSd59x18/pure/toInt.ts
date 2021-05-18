import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SCALE,
} from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeToInt(): void {
  context("when x is less the absolute value of scale", function () {
    const testSets = [[fp("1").mul(-1).add(1)], [bn("-1")]].concat([[bn("0")], [bn("1")], [fp("1").sub(1)]]);

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doToInt(x);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when x is greater than or equal to the absolute value of scale", function () {
    const testSets = [
      [fp(MIN_SD59x18)],
      [fp(MIN_WHOLE_SD59x18)],
      [fp("-4.2e27")],
      [fp("-1729")],
      [fp(PI).mul(-1)],
      [fp(E).mul(-1)],
      [fp("1").mul(-2)],
      [fp("1").mul(-2).add(1)],
      [fp("1").mul(-1).sub(1)],
      [fp("1").mul(-1)],
    ].concat([
      [fp("1")],
      [fp("1").add(1)],
      [fp("1").mul(2).sub(1)],
      [fp("1").mul(2)],
      [fp(E)],
      [fp(PI)],
      [fp("1729")],
      [fp("4.2e27")],
      [fp(MAX_WHOLE_SD59x18)],
      [fp(MAX_SD59x18)],
    ]);

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doToInt(x);
      const expected: BigNumber = x.div(fp(SCALE));
      expect(expected).to.equal(result);
    });
  });
}
