import { BigNumber } from "@ethersproject/bignumber";

import { maxInt, maxUint } from "./numbers";

export const LOG2_MAX_INT256: BigNumber = BigNumber.from("195205294292027477728");
export const MAX_INT256: BigNumber = maxInt(256);
export const MAX_UINT256: BigNumber = maxUint(256);
export const UNIT: BigNumber = BigNumber.from(10).pow(18);
export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
