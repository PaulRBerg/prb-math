import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import { toBn } from "evm-bn";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI } from "../../../helpers/constants";
import { exp } from "../../../helpers/math";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeExp(): void {
  context("when x is zero", function () {
    it("returns 1", async function () {
      const x: BigNumber = Zero;
      const expected: BigNumber = toBn("1");
      expect(expected).to.equal(await this.contracts.prbMathUd60x18.doExp(x));
      expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doExp(x));
    });
  });

  context("when x is positive", function () {
    context("when x is greater than or equal to 133.084258667509499440", function () {
      const testSets = [toBn("133.084258667509499441"), toBn(MAX_WHOLE_UD60x18), toBn(MAX_UD60x18)];

      forEach(testSets).it("takes %e and reverts", async function (x: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doExp(x)).to.be.revertedWith(PRBMathUD60x18Errors.ExpInputTooBig);
        await expect(this.contracts.prbMathUd60x18Typed.doExp(x)).to.be.revertedWith(
          PRBMathUD60x18Errors.ExpInputTooBig,
        );
      });
    });

    context("when x is less than or equal to 133.084258667509499440", function () {
      const testSets = [
        ["1e-18"],
        ["1e-15"],
        ["1"],
        ["2"],
        [E],
        ["3"],
        [PI],
        ["4"],
        ["11.89215"],
        ["16"],
        ["20.82"],
        ["33.333333"],
        ["64"],
        ["71.002"],
        ["88.722839111672999627"],
        ["133.084258667509499440"],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = toBn(exp(x));
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doExp(toBn(x)));
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doExp(toBn(x)));
      });
    });
  });
}
