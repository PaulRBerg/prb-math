import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import forEach from "mocha-each";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, PI, ZERO } from "../../../../helpers/constants";
import { fp, sfp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeInv(): void {
  context("when x is zero", function () {
    it("reverts", async function () {
      const x: BigNumber = ZERO;
      await expect(this.contracts.prbMathUd60x18.doInv(x)).to.be.reverted;
    });
  });

  context("when x is not zero", function () {
    const testSets = [
      [sfp("1e-18"), sfp("1e18")],
      [sfp("1e-5"), sfp("1e5")],
      [fp("0.05"), fp("20")],
      [fp("0.1"), fp("10")],
      [fp("1"), fp("1")],
      [fp("2"), fp("0.5")],
      [PI, fp("0.318309886183790671")],
      [fp("4"), fp("0.25")],
      [fp("22"), fp("0.045454545454545454")],
      [fp("100.135"), fp("0.00998651820042942")],
      [fp("772.05"), fp("0.001295252898128359")],
      [fp("2503"), fp("0.000399520575309628")],
      [sfp("1e18"), sfp("1e-18")],
      [sfp("1e18").add(1), ZERO],
      [MAX_WHOLE_UD60x18, ZERO],
      [MAX_UD60x18, ZERO],
    ];

    forEach(testSets).it("takes %e and returns %e", async function (x: BigNumber, expected: BigNumber) {
      const result: BigNumber = await this.contracts.prbMathUd60x18.doInv(x);
      expect(expected).to.equal(result);
    });
  });
}
