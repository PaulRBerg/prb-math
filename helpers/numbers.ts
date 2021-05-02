/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { BigNumber } from "@ethersproject/bignumber";
import fromExponential from "from-exponential";

export function fp(x: string): BigNumber {
  // Check if x is either a whole number with up to 60 digits or a fixed-point number with up to 60 digits and up to 18 decimals.
  if (!/^[-+]?(\d{1,60}|(?=\d+\.\d+)\d{1,60}\.\d{1,18})$/.test(x)) {
    throw new Error(`Unknown format for fixed-point number: ${x}`);
  }

  let integer: string;
  let decimals: string;
  let trailingZeroes: number;

  // If there is no dot, the number is whole.
  if (x.indexOf(".") == -1) {
    integer = x;
    decimals = "0";
    trailingZeroes = 0;
  } else {
    const parts = x.split(".");
    integer = parts[0];
    decimals = parts[1];

    // If the length of the decimals string is less than 18, the trailing zeroes are implied.
    trailingZeroes = 18 - decimals.length;
    decimals = decimals.replace(/^0+/, "");
  }

  // Convert the string into a BigNumber.
  const ten: BigNumber = BigNumber.from(10);
  const scale: BigNumber = ten.pow(18);
  const integerBn = BigNumber.from(integer);
  let decimalsBn = BigNumber.from(decimals).mul(ten.pow(trailingZeroes));

  // Account for the possible negative sign.
  if (x.startsWith("-")) {
    decimalsBn = decimalsBn.mul(-1);
  }

  return integerBn.mul(scale).add(decimalsBn);
}

export function fps(x: string): BigNumber {
  // Check if the input is in scientific notation.
  const captured = x.match(/^(-?\d+)(\.\d+)?(e|e-)(\d+)$/);
  if (captured == null) {
    throw new Error(`Unknown format for fixed-point number in scientific notation: ${x}`);
  }
  return fp(fromExponential(x));
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
