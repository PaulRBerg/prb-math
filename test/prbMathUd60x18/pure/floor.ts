import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { floor } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeFloor(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = bn("0");
      const expected: BigNumber = bn("0");
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFloor(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFloor(x));
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
      const expected: BigNumber = fp(floor(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doFloor(fp(x)));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doFloor(fp(x)));
    });
  });
}
