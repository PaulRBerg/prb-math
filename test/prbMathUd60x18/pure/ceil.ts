import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { ceil } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikeCeil(): void {
  context("when x is zero", function () {
    it("returns 0", async function () {
      const x: BigNumber = bn("0");
      const expected: BigNumber = bn("0");
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doCeil(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doCeil(x));
    });
  });

  context("when x is not zero", function () {
    context("when x > max whole ud60x18", function () {
      const testSets = [[fp(MAX_WHOLE_UD60x18).add(1)], [fp(MAX_UD60x18)]];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doCeil(x)).to.be.reverted;
        await expect(this.contracts.prbMathUd60x18Typed.doCeil(x)).to.be.reverted;
      });
    });

    context("when x <= max whole ud60x18", function () {
      const testSets = [["0.1"], ["0.5"], ["1"], ["1.125"], ["2"], [PI], ["4.2"], ["1e18"], [MAX_WHOLE_UD60x18]];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(ceil(x));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doCeil(fp(x)));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doCeil(fp(x)));
      });
    });
  });
}
