import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { ln } from "../../../helpers/math";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeLn(): void {
  context("when x is less than 1", function () {
    const testSets = [Zero, fp("0.0625"), fp("0.1"), fp("0.5"), fp("0.8"), fp("1").sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doLn(x)).to.be.revertedWith(PRBMathUD60x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathUd60x18Typed.doLn(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is greater than or equal to 1", function () {
    const testSets = [["1"], ["1.125"], ["2"], [E], [PI], ["4"], ["8"], ["1e18"], [MAX_WHOLE_UD60x18], [MAX_UD60x18]];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
      const expected: BigNumber = fp(ln(x));
      expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doLn(fp(x)));
      expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doLn(fp(x)));
    });
  });
}
