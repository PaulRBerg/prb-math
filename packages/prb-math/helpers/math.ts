/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { BigNumber as MathjsBigNumber, all, create } from "mathjs";

const config = {
  number: "BigNumber",
  precision: 79,
};

const math = create(all, config)!;
const mbn = math.bignumber!;

export function ceil(x: string): string {
  return (<MathjsBigNumber>mbn(x).ceil()).toString();
}

export function exp(x: string): string {
  return (<MathjsBigNumber>mbn(x).exp()).toString();
}

export function exp2(x: string): string {
  return (<MathjsBigNumber>math.pow!(mbn("2"), mbn(x))).toString();
}

export function floor(x: string): string {
  return (<MathjsBigNumber>mbn(x).floor()).toString();
}

export function gm(x: string, y: string): string {
  return (<MathjsBigNumber>math.sqrt!(mbn(x).mul(mbn(y)))).toString();
}

export function ln(x: string): string {
  return (<MathjsBigNumber>math.log!(mbn(x))).toString();
}

export function log10(x: string): string {
  return (<MathjsBigNumber>math.log10!(mbn(x))).toString();
}

export function log2(x: string): string {
  return (<MathjsBigNumber>math.log2!(mbn(x))).toString();
}

export function pow(x: string, y: string): string {
  return (<MathjsBigNumber>math.pow!(mbn(x), mbn(y))).toString();
}

export function sqrt(x: string): string {
  return (<MathjsBigNumber>math.sqrt!(mbn(x))).toString();
}

export { mbn };
