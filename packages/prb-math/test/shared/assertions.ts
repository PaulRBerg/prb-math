import { BigNumber } from "@ethersproject/bignumber";
import { toBn } from "evm-bn";

const EPSILON: BigNumber = toBn("1e-6");
const EPSILON_MAGNITUDE: BigNumber = BigNumber.from("1000000");

function max(x: BigNumber, y: BigNumber): BigNumber {
  return x.gte(y) ? x : y;
}

export function near(chai: Chai.ChaiStatic): void {
  const Assertion = chai.Assertion;

  Assertion.addMethod("near", function (actual: BigNumber): void {
    const expected = (this._obj as BigNumber).abs();
    const delta: BigNumber = expected.sub(actual.abs()).abs();
    this.assert(
      delta.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE))),
      "expected #{exp} to be near #{act}",
      "expected #{exp} to not be near #{act}",
      String(expected),
      String(actual),
    );
  });
}
