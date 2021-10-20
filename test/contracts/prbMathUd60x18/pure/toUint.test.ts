import type { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE } from "../../../../src/constants";

export function shouldBehaveLikeToUint(): void {
  context("when x is less than the scale", function () {
    const testSets = [Zero, toBn("1e-18"), SCALE.sub(1)];

    forEach(testSets).it("takes %e and returns 0", async function (x: BigNumber) {
      const expected: BigNumber = Zero;
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doToUint(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doToUint(x));
    });
  });

  context("when x is greater than or equal to the scale", function () {
    const testSets = [
      SCALE,
      SCALE.add(1),
      SCALE.mul(2).sub(1),
      SCALE.mul(2),
      E,
      PI,
      toBn("1729"),
      toBn("4.2e27"),
      MAX_WHOLE_UD60x18,
      MAX_UD60x18,
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = x.div(SCALE);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doToUint(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doToUint(x));
    });
  });
}
