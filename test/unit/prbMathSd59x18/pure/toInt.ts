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
  ZERO,
} from "../../../../helpers/constants";
import { bn, fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeToInt(): void {
  context("when x is less the absolute value of scale", function () {
    const testSets = [[SCALE.mul(-1).add(1)], [bn("-1")]].concat([[ZERO], [bn("1")], [SCALE.sub(1)]]);

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doToInt(x);
      expect(ZERO).to.equal(result);
    });
  });

  context("when x is greater than or equal to the absolute value of scale", function () {
    const testSets = [
      [MIN_SD59x18, MIN_SD59x18.div(SCALE)],
      [MIN_WHOLE_SD59x18, MIN_WHOLE_SD59x18.div(SCALE)],
      [sfp("-4.2e27"), sfp("-4.2e9")],
      [fp("-1729"), bn("-1729")],
      [PI.mul(-1), bn("-3")],
      [E.mul(-1), bn("-2")],
      [SCALE.mul(-2), bn("-2")],
      [SCALE.mul(-2).add(1), bn("-1")],
      [SCALE.mul(-1).sub(1), bn("-1")],
      [SCALE.mul(-1), bn("-1")],
    ].concat([
      [SCALE, bn("1")],
      [SCALE.add(1), bn("1")],
      [SCALE.mul(2).sub(1), bn("1")],
      [SCALE.mul(2), bn("2")],
      [E, bn("2")],
      [PI, bn("3")],
      [fp("1729"), bn("1729")],
      [sfp("4.2e27"), sfp("4.2e9")],
      [MAX_WHOLE_SD59x18, MAX_WHOLE_SD59x18.div(SCALE)],
      [MAX_SD59x18, MAX_SD59x18.div(SCALE)],
    ]);

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathSd59x18.doToInt(x);
      expect(expected).to.equal(result);
    });
  });
}
