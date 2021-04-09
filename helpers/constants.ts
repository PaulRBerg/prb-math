import { BigNumber } from "@ethersproject/bignumber";

import { bn, fp, maxInt, minInt, solidityModByScale } from "./numbers";

export const SCALE: BigNumber = BigNumber.from(10).pow(18);

export const E: BigNumber = bn("2718281828459045235");

export const LN_E: BigNumber = bn("999999999999999990");

export const LN_MAX_SD59x18: BigNumber = bn("135305999368893231500");

export const LOG10_MAX_SD59x18: BigNumber = bn("587626488943152049156");

export const LOG2_MAX_SD59x18: BigNumber = bn("195205294292027477728");

export const HALF_SCALE: BigNumber = fp(0.5);

// Equivalent to max int256
export const MAX_SD59x18: BigNumber = maxInt(256);

export const MAX_WHOLE_SD59x18: BigNumber = MAX_SD59x18.sub(solidityModByScale(MAX_SD59x18));

// Equivalent to min int256
export const MIN_SD59x18: BigNumber = minInt(256);

// See https://github.com/ethers-io/ethers.js/issues/1402
export const MIN_WHOLE_SD59x18: BigNumber = MIN_SD59x18.sub(solidityModByScale(MIN_SD59x18));

export const PI: BigNumber = bn("3141592653589793238");

export const SQRT_2 = bn("1414213562373095048");

export const SQRT_MAX_SD59x18 = bn("240615969168004511545033772477625056927114980741");

// The biggest number that fits within max int256 when multiplied by itself
export const SQRT_MAX_SD59x18_DIV_BY_SCALE = bn("240615969168004511545033772477625056927");

export const ZERO = BigNumber.from(0);

export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
