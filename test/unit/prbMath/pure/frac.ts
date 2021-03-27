import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";

import { MAX_59x18, MAX_WHOLE_59x18, MIN_59x18, MIN_WHOLE_59x18, PI, UNIT } from "../../../../helpers/constants";
import { bn, fp, solidityMod } from "../../../../helpers/numbers";

export default function shouldBehaveLikeFrac(): void {
  it("works when x = min 59x18", async function () {
    const x: BigNumber = MIN_59x18;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(solidityMod(MIN_59x18, UNIT));
  });

  it("works when x = min whole 59x18", async function () {
    const x: BigNumber = MIN_WHOLE_59x18;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = -1e18", async function () {
    const x: BigNumber = bn(-1e18).mul(UNIT);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = -4.2", async function () {
    const x: BigNumber = fp(-4.2);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(fp(-0.2));
  });

  it("works when x = -pi", async function () {
    const x: BigNumber = PI.mul(-1);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(solidityMod(x, UNIT));
  });

  it("works when x = -1", async function () {
    const x: BigNumber = fp(-1);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = -1.125", async function () {
    const x: BigNumber = fp(-1.125);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(fp(-0.125));
  });

  it("works when x = -2", async function () {
    const x: BigNumber = fp(-2);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = -0.5", async function () {
    const x: BigNumber = fp(-0.5);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(x);
  });

  it("works when x = -0.1", async function () {
    const x: BigNumber = fp(-0.1);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(x);
  });

  it("works when x = 0", async function () {
    const x: number = 0;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = 0.1", async function () {
    const x: BigNumber = fp(0.1);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(x);
  });

  it("works when x = 0.5", async function () {
    const x: BigNumber = fp(0.5);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(x);
  });

  it("works when x = 1", async function () {
    const x: BigNumber = fp(1);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = 1.125", async function () {
    const x: BigNumber = fp(1.125);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(fp(0.125));
  });

  it("works when x = 2", async function () {
    const x: BigNumber = fp(2);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = pi", async function () {
    const x: BigNumber = PI;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(solidityMod(PI, UNIT));
  });

  it("works when x = 4.2", async function () {
    const x: BigNumber = fp(4.2);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(fp(0.2));
  });

  it("works when x = 1e18", async function () {
    const x: BigNumber = bn(1e18).mul(UNIT);
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = max whole 59x18", async function () {
    const x: BigNumber = MAX_WHOLE_59x18;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(0);
  });

  it("works when x = max 59x18", async function () {
    const x: BigNumber = MAX_59x18;
    const result: BigNumber = await this.prbMath.doFrac(x);
    expect(result).to.equal(solidityMod(MAX_59x18, UNIT));
  });
}
