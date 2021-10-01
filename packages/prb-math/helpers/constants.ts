import { BigNumber } from "@ethersproject/bignumber";
import { toBn } from "evm-bn";

export const EPSILON: BigNumber = toBn("1e-6");
export const EPSILON_MAGNITUDE: BigNumber = BigNumber.from("1000000");
export const HALF_SCALE: string = "0.5";
export const SCALE: string = "1";
export const SQRT_MAX_SD59x18: string = "240615969168004511545033772477.625056927114980741";
export const SQRT_MAX_UD60x18: string = "340282366920938463463374607431.768211455999999999";
export const SQRT_MAX_SD59x18_DIV_BY_SCALE: string = "240615969168004511545.033772477625056927"; // biggest number whose square fits within int256
export const SQRT_MAX_UD60x18_DIV_BY_SCALE: string = "340282366920938463463.374607431768211455"; // biggest number whose square fits within uint256
