/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { BigNumber, parseFixed } from "@ethersproject/bignumber";
import fromExponential from "from-exponential";

export function fp(x: string): BigNumber {
  // Check if x is either a whole number with up to 60 digits or a fixed-point number with up to 60 digits and up to 18 decimals.
  if (!/^[-+]?(\d{1,60}|(?=\d+\.\d+)\d{1,60}\.\d{1,18})$/.test(x)) {
    throw new Error(`Unknown format for fixed-point number: ${x}`);
  }

  const precision: number = 18;
  return parseFixed(x, precision);
}

export function fps(x: string): BigNumber {
  // Check if the input is in scientific notation.
  if (!/^(-?\d+)(\.\d+)?(e|e-)(\d+)$/.test(x)) {
    throw new Error(`Unknown format for fixed-point number in scientific notation: ${x}`);
  }

  const precision: number = 18;
  return parseFixed(fromExponential(x), precision);
}

export function fpPowOfTwo(exp: number | BigNumber): BigNumber {
  const scale: BigNumber = BigNumber.from(10).pow(18);
  return powOfTwo(exp).mul(scale);
}

export function maxInt(exp: number): BigNumber {
  return powOfTwo(exp - 1).sub(1);
}

export function minInt(exp: number): BigNumber {
  return powOfTwo(exp - 1).mul(-1);
}

export function maxUint(exp: number): BigNumber {
  return BigNumber.from(2).pow(exp).sub(1);
}

export function powOfTwo(exp: number | BigNumber): BigNumber {
  return BigNumber.from(2).pow(BigNumber.from(exp));
}

export function solidityMod(x: BigNumber, n: BigNumber): BigNumber {
  let result = x.mod(n);
  if (x.isNegative()) {
    result = result.sub(n);
  }
  return result;
}

// See https://github.com/ethers-io/ethers.js/issues/1402.
export function solidityModByScale(x: BigNumber): BigNumber {
  const scale: BigNumber = BigNumber.from(10).pow(18);
  return solidityMod(x, scale);
}
