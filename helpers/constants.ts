import { BigNumber } from "@ethersproject/bignumber";

import { fp, maxInt, maxUint, minInt, solidityModByScale } from "./numbers";

export const E: BigNumber = fp("2.718281828459045235");
export const LN_E: BigNumber = fp("0.999999999999999990");
export const LN_MAX_SD59x18: BigNumber = fp("135.305999368893231615");
export const LN_MAX_UD60x18: BigNumber = fp("135.999146549453176925");
export const LOG10_MAX_SD59x18: BigNumber = fp("587.626488943152049156");
export const LOG10_MAX_UD60x18: BigNumber = fp("590.636788899791861115");
export const LOG2_MAX_SD59x18: BigNumber = fp("195.205294292027477728");
export const LOG2_MAX_UD60x18: BigNumber = fp("196.205294292027477728");
export const HALF_SCALE: BigNumber = fp("0.5");
export const MAX_SD59x18: BigNumber = maxInt(256); // Equivalent to max int256
export const MAX_UD60x18: BigNumber = maxUint(256); // Equivalent to max uint256
export const MAX_WHOLE_SD59x18: BigNumber = MAX_SD59x18.sub(solidityModByScale(MAX_SD59x18));
export const MAX_WHOLE_UD60x18: BigNumber = MAX_UD60x18.sub(solidityModByScale(MAX_UD60x18));
export const MIN_SD59x18: BigNumber = minInt(256); // Equivalent to min int256
export const MIN_WHOLE_SD59x18: BigNumber = MIN_SD59x18.sub(solidityModByScale(MIN_SD59x18));
export const PI: BigNumber = fp("3.141592653589793238");
export const SCALE: BigNumber = BigNumber.from(10).pow(18);
export const SQRT_2 = fp("1.414213562373095048");
export const SQRT_MAX_SD59x18 = fp("240615969168004511545033772477.625056927114980741");
export const SQRT_MAX_UD60x18 = fp("340282366920938463463374607431.768211455999999999");
export const SQRT_MAX_SD59x18_DIV_BY_SCALE = fp("240615969168004511545.033772477625056927"); // biggest number whose square fits within int256
export const SQRT_MAX_UD60x18_DIV_BY_SCALE = fp("340282366920938463463.374607431768211455"); // biggest number whose square fits within uint256
export const ZERO = BigNumber.from(0);
export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
