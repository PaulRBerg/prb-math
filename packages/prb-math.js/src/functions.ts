import type { BigNumber as EthersBigNumber } from "@ethersproject/bignumber";
import { Decimal } from "decimal.js";
import type { BigNumber as MathjsBigNumber } from "mathjs";

import math from "./math";
import { SCALE } from "./constants";
import { toMbn, toEbn, solidityMod } from "./helpers";

export function avg(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  const result = math.mean!(toMbn(x), toMbn(y)) as MathjsBigNumber;
  return toEbn(result);
}

export function ceil(x: EthersBigNumber): EthersBigNumber {
  const result: MathjsBigNumber = toMbn(x).ceil();
  return toEbn(result);
}

export function div(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  if (y.isZero()) {
    throw new Error("Cannot divide by zero");
  }
  const result: MathjsBigNumber = toMbn(x).div(toMbn(y));
  return toEbn(result);
}

export function exp(x: EthersBigNumber): EthersBigNumber {
  const result: MathjsBigNumber = toMbn(x).exp();
  return toEbn(result);
}

export function exp2(x: EthersBigNumber): EthersBigNumber {
  const two: MathjsBigNumber = math.bignumber!("2");
  const result = <MathjsBigNumber>math.pow!(two, toMbn(x));
  return toEbn(result);
}

export function floor(x: EthersBigNumber): EthersBigNumber {
  const result: MathjsBigNumber = toMbn(x).floor();
  return toEbn(result);
}

export function frac(x: EthersBigNumber): EthersBigNumber {
  return solidityMod(x, SCALE);
}

export function gm(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  const xy: MathjsBigNumber = toMbn(x).mul(toMbn(y));
  if (xy.isNegative()) {
    throw new Error("PRBMath cannot calculate the geometric mean of a negative number");
  }
  const result = math.sqrt!(xy) as MathjsBigNumber;
  return toEbn(result);
}

export function inv(x: EthersBigNumber): EthersBigNumber {
  if (x.isZero()) {
    throw new Error("Cannot calculate the inverse of zero");
  }
  const one: MathjsBigNumber = math.bignumber!("1");
  const result: MathjsBigNumber = one.div(toMbn(x));
  return toEbn(result);
}

export function ln(x: EthersBigNumber): EthersBigNumber {
  if (x.isZero()) {
    throw new Error("Cannot calculate the natural logarithm of zero");
  } else if (x.isNegative()) {
    throw new Error("Cannot calculate the natural logarithm of a negative number");
  }
  const result = math.log!(toMbn(x)) as MathjsBigNumber;
  return toEbn(result);
}

export function log10(x: EthersBigNumber): EthersBigNumber {
  if (x.isZero()) {
    throw new Error("Cannot calculate the common logarithm of zero");
  } else if (x.isNegative()) {
    throw new Error("Cannot calculate the common logarithm of a negative number");
  }
  const result = math.log10!(toMbn(x)) as MathjsBigNumber;
  return toEbn(result);
}

export function log2(x: EthersBigNumber): EthersBigNumber {
  if (x.isZero()) {
    throw new Error("Cannot calculate the binary logarithm of zero");
  } else if (x.isNegative()) {
    throw new Error("Cannot calculate the binary logarithm of a negative number");
  }
  const result = math.log2!(toMbn(x)) as MathjsBigNumber;
  return toEbn(result);
}

export function mul(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  const result: MathjsBigNumber = toMbn(x).mul(toMbn(y));
  return toEbn(result, Decimal.ROUND_HALF_UP);
}

export function pow(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  if (x.isNegative()) {
    throw new Error("PRBMath cannot raise a negative base to a power");
  }
  const result = math.pow!(toMbn(x), toMbn(y)) as MathjsBigNumber;
  return toEbn(result);
}

export function powu(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
  const exponent: MathjsBigNumber = math.bignumber!(String(y));
  const result = math.pow!(toMbn(x), exponent) as MathjsBigNumber;
  return toEbn(result);
}

export function sqrt(x: EthersBigNumber): EthersBigNumber {
  if (x.isNegative()) {
    throw new Error("Cannot calculate the square root of a negative number");
  }
  const result = math.sqrt!(toMbn(x)) as MathjsBigNumber;
  return toEbn(result);
}
