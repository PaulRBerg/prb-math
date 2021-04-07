import { BigNumber } from "@ethersproject/bignumber";

import { bn, fp, maxInt, minInt, solidityModByUnit } from "./numbers";

export const UNIT: BigNumber = BigNumber.from(10).pow(18);

export const E: BigNumber = bn("2718281828459045235");

export const LN_E: BigNumber = bn("999999999999999990");

export const LN_MAX_59x18: BigNumber = bn("135305999368893231500");

export const LOG10_MAX_59x18: BigNumber = bn("587626488943152049156");

export const LOG2_MAX_59x18: BigNumber = bn("195205294292027477728");

export const HALF_UNIT: BigNumber = fp(0.5);

// Equivalent to max int256
export const MAX_59x18: BigNumber = maxInt(256);

export const MAX_WHOLE_59x18: BigNumber = MAX_59x18.sub(solidityModByUnit(MAX_59x18));

// Equivalent to min int256
export const MIN_59x18: BigNumber = minInt(256);

// See https://github.com/ethers-io/ethers.js/issues/1402
export const MIN_WHOLE_59x18: BigNumber = MIN_59x18.sub(solidityModByUnit(MIN_59x18));

export const PI: BigNumber = bn("3141592653589793238");

export const SQRT_2 = bn("1414213562373095048");

export const TWICE_UNIT: BigNumber = fp(2);

export const ZERO = BigNumber.from(0);

export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
