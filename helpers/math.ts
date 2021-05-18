/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { all, create } from "mathjs";
import { BigNumber as MathjsBigNumber } from "mathjs";

const config = {
  number: "BigNumber",
  precision: 79,
};

const math = create(all, config)!;
const mbn = math.bignumber!;

export function ceil(x: string): MathjsBigNumber {
  return <MathjsBigNumber>mbn(x).ceil();
}

export function exp(x: string): MathjsBigNumber {
  return <MathjsBigNumber>mbn(x).exp();
}

export function exp2(x: string): MathjsBigNumber {
  return <MathjsBigNumber>math.pow!(mbn("2"), mbn(x));
}

export function floor(x: string): MathjsBigNumber {
  return <MathjsBigNumber>mbn(x).floor();
}

export function gm(x: string, y: string): MathjsBigNumber {
  return <MathjsBigNumber>math.sqrt!(mbn(x).mul(mbn(y)));
}

export function ln(x: string): MathjsBigNumber {
  return <MathjsBigNumber>math.log!(mbn(x));
}

export function log10(x: string): MathjsBigNumber {
  return <MathjsBigNumber>math.log10!(mbn(x));
}

export function log2(x: string): MathjsBigNumber {
  return <MathjsBigNumber>math.log2!(mbn(x));
}

export function pow(x: string, y: string): MathjsBigNumber {
  return <MathjsBigNumber>math.pow!(mbn(x), mbn(y));
}

export function sqrt(x: string): MathjsBigNumber {
  return <MathjsBigNumber>math.sqrt!(mbn(x));
}

export { mbn };
