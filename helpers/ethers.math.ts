import { BigNumber } from "@ethersproject/bignumber";

import { HALF_SCALE, SCALE } from "./constants";
import { fp } from "./numbers";

export function avg(x: BigNumber, y: BigNumber): BigNumber {
  let result: BigNumber = x.div(2).add(y.div(2));
  if (x.mod(2).eq(1) && y.mod(2).eq(1)) {
    result = result.add(1);
  }
  return result;
}

export function frac(x: BigNumber): BigNumber {
  return solidityModByScale(x);
}

export function inv(x: BigNumber): BigNumber {
  return fp(SCALE).mul(fp(SCALE)).div(x);
}

export function max(x: BigNumber, y: BigNumber): BigNumber {
  if (x.gte(y)) {
    return x;
  } else {
    return y;
  }
}

export function mul(x: BigNumber, y: BigNumber): BigNumber {
  const doubleScaledProduct = x.mul(y);
  let doubleScaledProductWithHalfScale: BigNumber;
  if (doubleScaledProduct.isNegative()) {
    doubleScaledProductWithHalfScale = doubleScaledProduct.sub(fp(HALF_SCALE));
  } else {
    doubleScaledProductWithHalfScale = doubleScaledProduct.add(fp(HALF_SCALE));
  }
  const result: BigNumber = doubleScaledProductWithHalfScale.div(fp(SCALE));
  return result;
}

export function solidityMod(x: BigNumber, n: BigNumber): BigNumber {
  let result = x.mod(n);
  if (!result.isZero() && x.isNegative()) {
    result = result.sub(n);
  }
  return result;
}

// See https://github.com/ethers-io/ethers.js/discussions/1408.
export function solidityModByScale(x: BigNumber): BigNumber {
  const scale: BigNumber = BigNumber.from(10).pow(18);
  return solidityMod(x, scale);
}
