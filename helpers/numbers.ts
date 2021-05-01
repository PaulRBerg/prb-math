import { BigNumber, BigNumberish } from "@ethersproject/bignumber";
import fromExponential from "from-exponential";

export function bn(x: BigNumberish): BigNumber {
  if (BigNumber.isBigNumber(x)) {
    return x;
  }
  const stringified = fromExponential(x.toString());
  const integer = stringified.split(".")[0];
  return BigNumber.from(integer);
}

export function bn_debug(x: BigNumberish): BigNumber {
  if (BigNumber.isBigNumber(x)) {
    return x;
  }
  const stringified = fromExponential(x.toString());
  const integer = stringified.split(".")[0];
  console.log({ stringified, integer });

  return BigNumber.from(integer);
}

export function fp(x: string): BigNumber {
  // This finds either a whole number with up to 60 digits or a fixed-point number with up to 60 digits and up to 18 decimals.
  if (!/^[-+]?(\d{1,60}|(?=\d+\.\d+)\d{1,60}\.\d{1,18})$/.test(x)) {
    throw new Error(`Unknown format for fixed-point number ${x}`);
  }

  let integer: string;
  let decimals: string;
  // eslint-disable-next-line prefer-const
  [integer, decimals] = x.indexOf(".") == -1 ? [x, "0"] : x.split(".");

  // If the length of the decimals string is less than 18, the trailing zeroes are implied.
  let trailingZeroes: number;
  if (decimals !== "0") {
    trailingZeroes = 18 - decimals.length;
    decimals = decimals.replace(/^0+/, "");
  } else {
    trailingZeroes = 0;
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
