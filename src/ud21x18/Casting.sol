// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../Common.sol" as Common;
import "./Errors.sol" as Errors;
import { uMAX_SD1x18 } from "../sd1x18/Constants.sol";
import { SD1x18 } from "../sd1x18/ValueType.sol";
import { SD21x18 } from "../sd21x18/ValueType.sol";
import { uMAX_SD21x18 } from "../sd21x18/Constants.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD21x18 } from "./ValueType.sol";

/// @notice Casts a UD21x18 number into SD1x18.
/// - x must be less than or equal to `uMAX_SD1x18`.
function intoSD1x18(UD21x18 x) pure returns (SD1x18 result) {
    uint128 xUint = UD21x18.unwrap(x);
    if (xUint > uint128(uint64(uMAX_SD1x18))) {
        revert Errors.PRBMath_UD21x18_IntoSD1x18_Overflow(x);
    }
    result = SD1x18.wrap(int64(uint64(xUint)));
}

/// @notice Casts a UD21x18 number into SD21x18.
/// - x must be less than or equal to `uMAX_SD21x18`.
function intoSD21x18(UD21x18 x) pure returns (SD21x18 result) {
    uint128 xUint = UD21x18.unwrap(x);
    if (xUint > uint128(uMAX_SD21x18)) {
        revert Errors.PRBMath_UD21x18_IntoSD21x18_Overflow(x);
    }
    result = SD21x18.wrap(int128(xUint));
}

/// @notice Casts a UD21x18 number into SD59x18.
/// @dev There is no overflow check because the domain of UD21x18 is a subset of SD59x18.
function intoSD59x18(UD21x18 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(int256(uint256(UD21x18.unwrap(x))));
}

/// @notice Casts a UD21x18 number into UD2x18.
/// @dev There is no overflow check because the domain of UD21x18 is a subset of UD2x18.
function intoUD2x18(UD21x18 x) pure returns (UD2x18 result) {
    uint128 xUint = UD21x18.unwrap(x);
    if (xUint > uint128(Common.MAX_UINT64)) {
        revert Errors.PRBMath_UD21x18_IntoUD2x18_Overflow(x);
    }
    result = UD2x18.wrap(uint64(UD21x18.unwrap(x)));
}

/// @notice Casts a UD21x18 number into UD60x18.
/// @dev There is no overflow check because the domain of UD21x18 is a subset of UD60x18.
function intoUD60x18(UD21x18 x) pure returns (UD60x18 result) {
    result = UD60x18.wrap(UD21x18.unwrap(x));
}

/// @notice Casts a UD21x18 number into uint256.
/// @dev There is no overflow check because the domain of UD21x18 is a subset of uint256.
function intoUint256(UD21x18 x) pure returns (uint256 result) {
    result = uint256(UD21x18.unwrap(x));
}

/// @notice Casts a UD21x18 number into uint40.
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UINT40`.
function intoUint40(UD21x18 x) pure returns (uint40 result) {
    uint128 xUint = UD21x18.unwrap(x);
    if (xUint > uint128(Common.MAX_UINT40)) {
        revert Errors.PRBMath_UD21x18_IntoUint40_Overflow(x);
    }
    result = uint40(xUint);
}

/// @notice Casts a UD21x18 number into uint64.
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UINT64`.
function intoUint64(UD21x18 x) pure returns (uint64 result) {
    uint128 xUint = UD21x18.unwrap(x);
    if (xUint > uint128(Common.MAX_UINT64)) {
        revert Errors.PRBMath_UD21x18_IntoUint64_Overflow(x);
    }
    result = uint64(xUint);
}

/// @notice Alias for {wrap}.
function ud21x18(uint128 x) pure returns (UD21x18 result) {
    result = UD21x18.wrap(x);
}

/// @notice Unwrap a UD21x18 number into uint128.
function unwrap(UD21x18 x) pure returns (uint128 result) {
    result = UD21x18.unwrap(x);
}

/// @notice Wraps a uint128 number into UD21x18.
function wrap(uint128 x) pure returns (UD21x18 result) {
    result = UD21x18.wrap(x);
}
