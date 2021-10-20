import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import {
  E,
  MAX_SD59x18,
  MAX_WHOLE_SD59x18,
  MIN_SD59x18,
  MIN_WHOLE_SD59x18,
  PI,
  SCALE,
} from "../../../../src/constants";

export function shouldBehaveLikeToInt(): void {
  context("when x is less the absolute value of scale", function () {
    const testSets = [[toBn("1").mul(-1).add(1)], [toBn("-1e-18")]].concat([
      [Zero],
      [toBn("1e-18")],
      [toBn("1").sub(1)],
    ]);

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doToInt(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doToInt(x));
    });
  });

  context("when x is greater than or equal to the absolute value of scale", function () {
    const testSets = [
      MIN_SD59x18,
      MIN_WHOLE_SD59x18,
      toBn("-4.2e27"),
      toBn("-1729"),
      PI.mul(-1),
      E.mul(-1),
      toBn("1").mul(-2),
      toBn("1").mul(-2).add(1),
      toBn("1").mul(-1).sub(1),
      toBn("1").mul(-1),
    ].concat([
      toBn("1"),
      toBn("1").add(1),
      toBn("1").mul(2).sub(1),
      toBn("1").mul(2),
      E,
      PI,
      toBn("1729"),
      toBn("4.2e27"),
      MAX_WHOLE_SD59x18,
      MAX_SD59x18,
    ]);

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = x.div(SCALE);
      expect(expected).to.equal(await this.contracts.prbMathSd59x18.doToInt(x));
      expect(expected).to.equal(await this.contracts.prbMathSd59x18Typed.doToInt(x));
    });
  });
}
