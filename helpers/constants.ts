import { BigNumber } from "@ethersproject/bignumber";

import { bn, fp, maxInt, maxUint, minInt, solidityMod } from "./numbers";

export const UNIT: BigNumber = BigNumber.from(10).pow(18);

// The binary logarithm of max 59x18. Wolfram gives 3 instead of 2 at the end, but that's because they better precision.
export const LOG2_MAX_59x18: BigNumber = bn("195205294292027477728");

// The binary logarithm of pi. Wolfram gives 98 instead of 82 at the end, but that's because they better precision.
export const LOG2_PI: BigNumber = bn("1651496129472318782");

export const HALF_UNIT: BigNumber = fp(0.5);

export const MAX_INT256: BigNumber = maxInt(256);

export const MAX_UINT256: BigNumber = maxUint(256);

// Equivalent to max int256
export const MAX_59x18: BigNumber = maxInt(256);

export const MAX_WHOLE_59x18: BigNumber = MAX_59x18.sub(solidityMod(MAX_59x18, UNIT));

// Equivalent to min int256
export const MIN_59x18: BigNumber = minInt(256);

// See https://github.com/ethers-io/ethers.js/issues/1402
export const MIN_WHOLE_59x18: BigNumber = MIN_59x18.sub(solidityMod(MIN_59x18, UNIT));

export const PI: BigNumber = bn("3141592653589793238");

export const TWICE_UNIT: BigNumber = fp(2);

export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
