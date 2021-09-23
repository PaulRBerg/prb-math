import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { PanicCodes } from "../../shared/errors";
import { inv } from "../../shared/mirrors";

export default function shouldBehaveLikeInv(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doInv(x)).to.be.revertedWith(PanicCodes.DivisionByZero);
      await expect(this.contracts.prbMathUd60x18Typed.doInv(x)).to.be.revertedWith(PanicCodes.DivisionByZero);
    });
  });

  context("when x is not zero", function () {
    const testSets = [
      [fp("1e-18")],
      [fp("1e-5")],
      [fp("0.05")],
      [fp("0.1")],
      [fp("1")],
      [fp("2")],
      [fp(PI)],
      [fp("4")],
      [fp("22")],
      [fp("100.135")],
      [fp("772.05")],
      [fp("2503")],
      [fp("1e18")],
      [fp("1e18").add(1)],
      [fp(MAX_WHOLE_UD60x18)],
      [fp(MAX_UD60x18)],
    ];

    forEach(testSets).it("takes %e and returns the correct value", async function (x: BigNumber) {
      const expected: BigNumber = inv(x);
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doInv(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doInv(x));
    });
  });
}
