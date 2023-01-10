// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import { MAX_UINT40 } from "./Common.sol";
import { SD1x18, uMAX_SD1x18 } from "./SD1x18.sol";
import { SD59x18 } from "./SD59x18.sol";
import { UD60x18 } from "./UD60x18.sol";

/// @notice The unsigned 2.18-decimal fixed-point number representation, which can have up to 2 digits and up to 18 decimals.
/// The values of this are bound by the minimum and the maximum values permitted by the underlying Solidity type uint64.
/// This is useful when end users want to use uint64 to save gas, e.g. with tight variable packing in contract storage.
type UD2x18 is uint64;

/*//////////////////////////////////////////////////////////////////////////
                                    CONSTANTS
//////////////////////////////////////////////////////////////////////////*/

/// @dev Euler's number as an UD2x18 number.
UD2x18 constant E = UD2x18.wrap(2_718281828459045235);

/// @dev The maximum value an UD2x18 number can have.
uint64 constant uMAX_UD2x18 = 18_446744073709551615;
UD2x18 constant MAX_UD2x18 = UD2x18.wrap(uMAX_UD2x18);

/// @dev PI as an UD2x18 number.
UD2x18 constant PI = UD2x18.wrap(3_141592653589793238);

/// @dev The unit amount that implies how many trailing decimals can be represented.
uint256 constant uUNIT = 1e18;
UD2x18 constant UNIT = UD2x18.wrap(1e18);

/*//////////////////////////////////////////////////////////////////////////
                                  CUSTOM ERRORS
//////////////////////////////////////////////////////////////////////////*/

/// @notice Emitted when trying to cast a UD2x18 number that doesn't fit in UD2x18.
error PRBMath_UD2x18_IntoUD2x18_Underflow(UD2x18 x);

/// @notice Emitted when trying to cast a UD2x18 number that doesn't fit in uint40.
error PRBMath_UD2x18_IntoUint40_Overflow(UD2x18 x);

/*//////////////////////////////////////////////////////////////////////////
                                    CASTING
//////////////////////////////////////////////////////////////////////////*/

/// @notice Casts an UD2x18 number to SD59x18.
/// @dev There is no overflow check because the domain of UD2x18 is a subset of SD59x18.
function intoSD59x18(UD2x18 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(int256(uint256(UD2x18.unwrap(x))));
}

/// @notice Casts an UD2x18 number to SD1x18.
/// - x must be less than or equal to `uMAX_UD2x18`.
function intoUD2x18(UD2x18 x) pure returns (SD1x18 result) {
    uint64 xUint = UD2x18.unwrap(x);
    if (xUint < uint64(uMAX_SD1x18)) {
        revert PRBMath_UD2x18_IntoUD2x18_Underflow(x);
    }
    result = SD1x18.wrap(int64(xUint));
}

/// @notice Casts an UD2x18 number to UD60x18.
/// @dev This function simply calls `intoUint256` and wraps the result.
function intoUD60x18(UD2x18 x) pure returns (UD60x18 result) {
    result = UD60x18.wrap(intoUint256(x));
}

/// @notice Casts an UD2x18 number to uint256.
/// @dev There is no overflow check because the domain of UD2x18 is a subset of uint256.
function intoUint256(UD2x18 x) pure returns (uint256 result) {
    result = uint256(UD2x18.unwrap(x));
}

/// @notice Casts an UD2x18 number to uint128.
/// @dev There is no overflow check because the domain of UD2x18 is a subset of uint128.
function intoUint128(UD2x18 x) pure returns (uint128 result) {
    result = uint128(UD2x18.unwrap(x));
}

/// @notice Casts an UD2x18 number to uint40.
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UINT40`.
function intoUint40(UD2x18 x) pure returns (uint40 result) {
    uint64 xUint = UD2x18.unwrap(x);
    if (xUint > uint64(MAX_UINT40)) {
        revert PRBMath_UD2x18_IntoUint40_Overflow(x);
    }
    result = uint40(xUint);
}

/// @notice Wraps a signed integer into the UD2x18 type.
function ud2x18(uint64 x) pure returns (UD2x18 result) {
    result = UD2x18.wrap(x);
}
