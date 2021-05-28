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
        const result: BigNumber = await this.contracts.prbMathSd59x18.doPow(x, y);
        expect(fp("1")).to.equal(result);
      });
    });

    context("when the exponent is not zero", function () {
      const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

      forEach(testSets).it("takes 0 and %e and returns 0", async function (y: BigNumber) {
        const result: BigNumber = await this.contracts.prbMathSd59x18.doPow(x, y);
        expect(bn("0")).to.equal(result);
      });
    });
  });

  context("when the base is not zero", function () {
    context("when the base is negative", function () {
      const testSets = [[fp(PI).mul(-1)], [fp(E).mul(-1)], [fp("-1")]];

      forEach(testSets).it("takes %e and 1 and reverts", async function (x: BigNumber) {
        const y: BigNumber = fp("1");
        await expect(this.contracts.prbMathSd59x18.doPow(x, y)).to.be.reverted;
      });
    });

    context("when the base is positive", function () {
      context("when the exponent is zero", function () {
        const y: BigNumber = bn("0");
        const testSets = [[fp("1")], [fp(E)], [fp(PI)]];

        forEach(testSets).it("takes %e and 0 and returns 1", async function (x: BigNumber) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doPow(x, y);
          expect(fp("1")).to.equal(result);
        });
      });

      context("when the exponent is not zero", function () {
        const testSets = [
          ["1e-18", "-1e-18"],
          ["1e-12", "-4.4e-9"],
          ["0.1", "-0.8"],
          ["0.24", "-11"],
          ["0.5", "-0.7373"],
          ["0.799291", "-69"],
          ["1", "-1"],
          ["1", "-" + PI],
          ["2", "-1.5"],
          [E, "-" + E],
          [E, "-1.66976"],
          [PI, "-" + PI],
          ["11", "-28.57142"],
          ["32.15", "-23.99"],
          ["406", "-0.25"],
          ["1729", "-0.98"],
          ["33441", "-2.1891"],
          ["340282366920938463463374607431768211455", "-1"], // 2^128 - 1
        ].concat([
          ["1e-18", "1e-18"],
          ["1e-12", "4.4e-9"],
          ["0.1", "0.8"],
          ["0.24", "11"],
          ["0.5", "0.7373"],
          ["0.799291", "69"],
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
        ]);

        forEach(testSets).it("takes %e and %e and returns the correct value", async function (x: string, y: string) {
          const result: BigNumber = await this.contracts.prbMathSd59x18.doPow(fp(x), fp(y));
          const expected: BigNumber = fp(pow(x, y));
          expect(expected).to.be.near(result);
        });
      });
    });
  });
}
