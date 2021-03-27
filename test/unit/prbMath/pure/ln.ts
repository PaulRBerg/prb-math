import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { E, LN_E, LN_MAX_59x18, MAX_59x18, MAX_WHOLE_59x18, PI, ZERO_ADDRESS } from "../../../../helpers/constants";
import { bn, fp } from "../../../../helpers/numbers";

export default function shouldBehaveLikeLn(): void {
  describe("when x is zero", function () {
    it("reverts", async function () {
      const x: number = 0;
      await expect(this.prbMath.doLn(x)).to.be.reverted;
    });
  });

  describe("when x is a negative number", function () {
    it("reverts", async function () {
      await expect(this.prbMath.doLn(fp(-1))).to.reverted;
    });
  });

  describe("when x is a positive number", function () {
    it("works when x = 0.1", async function () {
      const x: BigNumber = fp(0.1);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-2302585092994045673"));
    });

    it("works when x = 0.2", async function () {
      const x: BigNumber = fp(0.2);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-1609437912434100364"));
    });

    it("works when x = 0.3", async function () {
      const x: BigNumber = fp(0.3);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-1203972804325935983"));
    });

    it("works when x = 0.4", async function () {
      const x: BigNumber = fp(0.4);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-916290731874155055"));
    });

    it("works when x = 0.5", async function () {
      const x: BigNumber = fp(0.5);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-693147180559945309"));
    });

    it("works when x = 0.6", async function () {
      const x: BigNumber = fp(0.6);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-510825623765990674"));
    });

    it("works when x = 0.7", async function () {
      const x: BigNumber = fp(0.7);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-356674943938732371"));
    });

    it("works when x = 0.8", async function () {
      const x: BigNumber = fp(0.8);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-223143551314209746"));
    });

    it("works when x = 0.9", async function () {
      const x: BigNumber = fp(0.9);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("-105360515657826293"));
    });

    it("works when x = 1", async function () {
      const x: BigNumber = fp(1);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(ZERO_ADDRESS);
    });

    it("works when x = 1.125", async function () {
      const x: BigNumber = fp(1.125);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("117783035656383443"));
    });

    it("works when x = 2", async function () {
      const x: BigNumber = fp(2);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("693147180559945309"));
    });

    it("works when x = e", async function () {
      const x: BigNumber = E;
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(LN_E);
    });

    it("works when x = pi", async function () {
      const x: BigNumber = PI;
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("1144729885849400162"));
    });

    it("works when x = 4", async function () {
      const x: BigNumber = fp(4);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("1386294361119890618"));
    });

    it("works when x = 8", async function () {
      const x: BigNumber = fp(8);
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(bn("2079441541679835927"));
    });

    it("works when x = max whole 59x18", async function () {
      const x: BigNumber = MAX_WHOLE_59x18;
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(LN_MAX_59x18);
    });

    it("works when x = max 59x18", async function () {
      const x: BigNumber = MAX_59x18;
      const result: BigNumber = await this.prbMath.doLn(x);
      expect(result).to.equal(LN_MAX_59x18);
    });
  });
}
