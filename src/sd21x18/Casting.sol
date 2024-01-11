// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../Common.sol" as Common;
import "./Errors.sol" as CastingErrors;
import { SD1x18 } from "../sd1x18/ValueType.sol";
import { uMAX_SD1x18, uMIN_SD1x18 } from "../sd1x18/Constants.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD21x18 } from "../ud21x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";
import { SD21x18 } from "./ValueType.sol";

/// @notice Casts an SD21x18 number into SD1x18.
/// @dev Requirements:
/// - x must be greater than or equal to `uMIN_SD1x18`.
/// - x must be less than or equal to `uMAX_SD1x18`.
function intoSD1x18(SD21x18 x) pure returns (SD1x18 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < uMIN_SD1x18) {
        revert CastingErrors.PRBMath_SD21x18_IntoSD1x18_Underflow(x);
    }
    if (xInt > uMAX_SD1x18) {
        revert CastingErrors.PRBMath_SD21x18_IntoSD1x18_Overflow(x);
    }
    result = SD1x18.wrap(int64(xInt));
}

/// @notice Casts an SD21x18 number into SD59x18.
/// @dev There is no overflow check because the domain of SD21x18 is a subset of SD59x18.
function intoSD59x18(SD21x18 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(int256(SD21x18.unwrap(x)));
}

/// @notice Casts an SD21x18 number into UD2x18.
/// - x must be positive.
function intoUD2x18(SD21x18 x) pure returns (UD2x18 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUD2x18_Underflow(x);
    }
    result = UD2x18.wrap(uint64(uint128(xInt)));
}

/// @notice Casts an SD21x18 number into UD21x18.
/// - x must be positive.
function intoUD21x18(SD21x18 x) pure returns (UD21x18 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUD21x18_Underflow(x);
    }
    result = UD21x18.wrap(uint128(uint128(xInt)));
}

/// @notice Casts an SD21x18 number into UD60x18.
/// @dev Requirements:
/// - x must be positive.
function intoUD60x18(SD21x18 x) pure returns (UD60x18 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUD60x18_Underflow(x);
    }
    result = UD60x18.wrap(uint128(xInt));
}

/// @notice Casts an SD21x18 number into uint256.
/// @dev Requirements:
/// - x must be positive.
function intoUint256(SD21x18 x) pure returns (uint256 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint256_Underflow(x);
    }
    result = uint256(uint128(xInt));
}

/// @notice Casts an SD21x18 number into uint128.
/// @dev Requirements:
/// - x must be positive.
function intoUint128(SD21x18 x) pure returns (uint128 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint128_Underflow(x);
    }
    result = uint128(xInt);
}

/// @notice Casts an SD21x18 number into uint64.
/// @dev Requirements:
/// - x must be positive.
/// - x must be less than or equal to `MAX_UINT64`.
function intoUint64(SD21x18 x) pure returns (uint64 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint64_Underflow(x);
    }
    if (xInt > int128(uint128(Common.MAX_UINT64))) {
        revert CastingErrors.PRBMath_SD21x18_ToUint64_Overflow(x);
    }
    result = uint64(uint128(xInt));
}

/// @notice Casts an SD21x18 number into uint40.
/// @dev Requirements:
/// - x must be positive.
/// - x must be less than or equal to `MAX_UINT40`.
function intoUint40(SD21x18 x) pure returns (uint40 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint40_Underflow(x);
    }
    if (xInt > int128(uint128(Common.MAX_UINT40))) {
        revert CastingErrors.PRBMath_SD21x18_ToUint40_Overflow(x);
    }
    result = uint40(uint128(xInt));
}

/// @notice Alias for {wrap}.
function sd21x18(int128 x) pure returns (SD21x18 result) {
    result = SD21x18.wrap(x);
}

/// @notice Unwraps an SD21x18 number into int128.
function unwrap(SD21x18 x) pure returns (int128 result) {
    result = SD21x18.unwrap(x);
}

/// @notice Wraps an int128 number into SD21x18.
function wrap(int128 x) pure returns (SD21x18 result) {
    result = SD21x18.wrap(x);
}
