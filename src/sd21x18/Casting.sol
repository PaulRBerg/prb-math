// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "../Common.sol" as Common;
import "./Errors.sol" as CastingErrors;
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";
import { SD21x18 } from "./ValueType.sol";

/// @notice Casts an SD21x18 number into SD59x18.
/// @dev There is no overflow check because SD21x18 ⊆ SD59x18.
function intoSD59x18(SD21x18 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(int256(SD21x18.unwrap(x)));
}

/// @notice Casts an SD21x18 number into UD60x18.
/// @dev Requirements:
/// - x ≥ 0
function intoUD60x18(SD21x18 x) pure returns (UD60x18 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUD60x18_Underflow(x);
    }
    result = UD60x18.wrap(uint128(xInt));
}

/// @notice Casts an SD21x18 number into uint128.
/// @dev Requirements:
/// - x ≥ 0
function intoUint128(SD21x18 x) pure returns (uint128 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint128_Underflow(x);
    }
    result = uint128(xInt);
}

/// @notice Casts an SD21x18 number into uint256.
/// @dev Requirements:
/// - x ≥ 0
function intoUint256(SD21x18 x) pure returns (uint256 result) {
    int128 xInt = SD21x18.unwrap(x);
    if (xInt < 0) {
        revert CastingErrors.PRBMath_SD21x18_ToUint256_Underflow(x);
    }
    result = uint256(uint128(xInt));
}

/// @notice Casts an SD21x18 number into uint40.
/// @dev Requirements:
/// - x ≥ 0
/// - x ≤ MAX_UINT40
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
