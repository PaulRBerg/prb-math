import { BigNumber } from "@ethersproject/bignumber";
import { Zero } from "@ethersproject/constants";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, MAX_UD60x18, MAX_WHOLE_UD60x18, PI, SCALE } from "../../../helpers/constants";
import { log10 } from "../../../helpers/math";
import { PRBMathUD60x18Errors } from "../../shared/errors";

export default function shouldBehaveLikeLog10(): void {
  context("when x is less than 1", function () {
    const testSets = [Zero, fp("1e-18"), fp("1e-17"), fp("1e4"), fp("0.1"), fp("0.5"), fp(SCALE).sub(1)];

    forEach(testSets).it("takes %e and reverts", async function () {
      const x: BigNumber = Zero;
      await expect(this.contracts.prbMathUd60x18.doLog10(x)).to.be.revertedWith(PRBMathUD60x18Errors.LogInputTooSmall);
      await expect(this.contracts.prbMathUd60x18Typed.doLog10(x)).to.be.revertedWith(
        PRBMathUD60x18Errors.LogInputTooSmall,
      );
    });
  });

  context("when x is greater than or equal to 1", function () {
    context("when x is a power of ten", function () {
      const testSets = [["1"], ["10"], ["100"], ["1e18"], ["1e49"], ["1e57"], ["1e58"]];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(log10(x));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doLog10(fp(x)));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doLog10(fp(x)));
      });
    });

    context("when x is not a power of ten", function () {
      const testSets = [
        ["1.000000000000010000"],
        [E],
        [PI],
        ["4"],
        ["16"],
        ["32"],
        ["42.12"],
        ["1010.892143"],
        ["440934.1881"],
        ["1000000000000000000.000000000001"],
        [MAX_WHOLE_UD60x18],
        [MAX_UD60x18],
      ];

      forEach(testSets).it("takes %e and returns the correct value", async function (x: string) {
        const expected: BigNumber = fp(log10(x));
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doLog10(fp(x)));
        expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doLog10(fp(x)));
      });
    });
  });
}
