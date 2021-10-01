import type { BigNumber } from "@ethersproject/bignumber";

import { EPSILON, EPSILON_MAGNITUDE } from "../../helpers/constants";

function max(x: BigNumber, y: BigNumber): BigNumber {
  return x.gte(y) ? x : y;
}

export function near(chai: Chai.ChaiStatic): void {
  const Assertion = chai.Assertion;

  Assertion.addMethod("near", function (actual: BigNumber): void {
    const expected = <BigNumber>this._obj;
    const delta: BigNumber = expected.sub(actual).abs();

    this.assert(
      delta.lte(max(EPSILON, expected.div(EPSILON_MAGNITUDE))),
      "expected #{exp} to be near #{act}",
      "expected #{exp} to not be near #{act}",
      expected,
      actual,
    );
  });
}
