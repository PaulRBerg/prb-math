import { BigNumber } from "@ethersproject/bignumber";
import type { BigNumberish } from "@ethersproject/bignumber";
import fp from "evm-fp";

import { HALF_SCALE, SCALE } from "../../helpers/constants";

export function avg(x: BigNumber, y: BigNumber): BigNumber {
  let result: BigNumber = x.div(2).add(y.div(2));
  const xModTwo: BigNumber = solidityMod(x, 2);
  const yModTwo: BigNumber = solidityMod(y, 2);
  if (xModTwo.eq(1) && yModTwo.eq(1)) {
    result = result.add(1);
  } else if (xModTwo.eq(-1) && yModTwo.eq(-1)) {
    result = result.sub(1);
  }
  return result;
}

export function frac(x: BigNumber): BigNumber {
  const scale: BigNumber = BigNumber.from(10).pow(18);
  return solidityMod(x, scale);
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

// See https://github.com/ethers-io/ethers.js/discussions/1408
function solidityMod(x: BigNumber, n: BigNumberish): BigNumber {
  let result = x.mod(n);
  if (!result.isZero() && x.isNegative()) {
    result = result.sub(n);
  }
  return result;
}
