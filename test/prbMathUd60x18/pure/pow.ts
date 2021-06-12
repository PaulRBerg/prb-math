import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import fp from "evm-fp";
import forEach from "mocha-each";

import { E, PI } from "../../../helpers/constants";
import { pow } from "../../../helpers/math";
import { bn } from "../../../helpers/numbers";

export default function shouldBehaveLikePow(): void {
  context("when the base is zero", function () {
    const x: BigNumber = bn("0");

    context("when the exponent is zero", function () {
      const y: BigNumber = bn("0");

      it("takes 0 and 0 and returns 1", async function () {
        const expected: BigNumber = fp("1");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const x: BigNumber = bn("0");
        const expected: BigNumber = bn("0");
        expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
        expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is lower than the scale", function () {
      const testSets = [
        [fp("1e-18"), fp("1")],
        [fp("1e-11"), fp("1")],
        [fp("1").sub(1), fp("1")],
      ];

      forEach(testSets).it("takes %e and %e and reverts", async function (x: BigNumber, y: BigNumber) {
        await expect(this.contracts.prbMathUd60x18.doPow(x, y)).to.be.reverted;
        await expect(this.contracts.prbMathUd60x18Typed.doPow(x, y)).to.be.reverted;
      });
    });

    context("when the base is greater than or equal to the scale", function () {
      context("when the exponent is zero", function () {
        const y: BigNumber = bn("0");
        const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

        forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
          const expected: BigNumber = fp("1");
          expect(expected).to.equal(await this.contracts.prbMathUd60x18.doPow(x, y));
          expect(expected).to.equal(await this.contracts.prbMathUd60x18Typed.doPow(x, y));
        });
      });

      context("when the exponent is not zero", function () {
        const testSets = [
          ["1", "1"],
          ["1", PI],
          ["2", "1.5"],
          [E, E],
          [E, "1.66976"],
          [PI, PI],
          ["11", "28.57142"],
          ["32.15", "23.99"],
          ["406", "0.25"],
          ["1729", "0.98"],
          ["33441", "2.1891"],
          ["340282366920938463463374607431768211455", "1"], // 2^128 - 1
        ];

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const expected: BigNumber = fp(pow(x, y));
          expect(expected).to.be.near(await this.contracts.prbMathUd60x18.doPow(fp(x), fp(y)));
          expect(expected).to.be.near(await this.contracts.prbMathUd60x18Typed.doPow(fp(x), fp(y)));
        });
      });
    });
  });
}
