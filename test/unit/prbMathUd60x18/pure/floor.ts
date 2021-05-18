import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../../helpers/constants";
import { floor } from "../../../../helpers/math";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeFloor(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = bn("0");
      const result: BigNumber = await this.contracts.prbMathUd60x18.doFloor(x);
      expect(bn("0")).to.equal(result);
    });
  });

  context("when x is not zero", function () {
    const testSets = [
      ["0.1"],
      ["0.5"],
      ["1"],
      ["1.125"],
      ["2"],
      [PI],
      ["4.2"],
      ["1e18"],
      [MAX_WHOLE_UD60x18],
      [MAX_UD60x18],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doFloor(fp(x));
      const expected: BigNumber = fp(floor(x));
      expect(expected).to.equal(result);
    });
  });
}
