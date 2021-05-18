import { BigNumber, parseFixed } from "@ethersproject/bignumber";
import fromExponential from "from-exponential";
import { BigNumber as MathjsBigNumber } from "mathjs";

export function bn(x: string): BigNumber {
  let xs: string = x;
  if (x.includes("e")) {
    xs = fromExponential(x);
  }
  return BigNumber.from(xs);
}

/// 1. Get the stringified value of x, but limit the number of decimals to 18.
/// 2. Check if x is a whole number with up to 60 digits or a fixed-point number with up to 60 digits and up to 18
///    decimals. If yes, convert the number to fixed-point representation and return it.
/// 3. Otherwise, throw an error.
export function fp(x: string | MathjsBigNumber): BigNumber {
  let xs: string;
  if (typeof x === "string") {
    xs = x;
    if (xs.includes("e")) {
      xs = fromExponential(xs);
    }
  } else {
    xs = String(x);
    if (xs.includes("e")) {
      xs = fromExponential(xs);
    }
    if (xs.includes(".")) {
      const parts: string[] = xs.split(".");
      parts[1] = parts[1].slice(0, 18);
      xs = parts[0] + "." + parts[1];
    }
  }

  const precision: number = 18;
  if (/^[-+]?(\d{1,60}|(?=\d+\.\d+)\d{1,60}\.\d{1,18})$/.test(xs)) {
    return parseFixed(xs, precision);
  } else {
    throw new Error(`Unknown format for fixed-point number: ${xs}`);
  }
}
