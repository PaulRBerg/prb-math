// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import { SD1x18, uMAX_SD1x18 } from "./SD1x18.sol";
import { SD59x18, uMAX_SD59x18 } from "./SD59x18.sol";
import { UD60x18 } from "./UD60x18.sol";

/// Helper functions to cast between different types:
///
/// - SD1x18
/// - SD59x18
/// - UD60x18
/// - uint40
/// - uint128
/// - uint256

/*//////////////////////////////////////////////////////////////////////////
                                  CUSTOM ERRORS
//////////////////////////////////////////////////////////////////////////*/

/// @notice Emitted when trying to cast a SD1x18 number that doesn't fit in uint256.
error FromSD1x18_ToUint256_Underflow(SD1x18 x);

/// @notice Emitted when trying to cast a SD1x18 number that doesn't fit in uint128.
error FromSD1x18_ToUint128_Underflow(SD1x18 x);

/// @notice Emitted when trying to cast a SD1x18 number that doesn't fit in uint40.
error FromSD1x18_ToUint40_Overflow(SD1x18 x);

/// @notice Emitted when trying to cast a SD1x18 number that doesn't fit in uint40.
error FromSD1x18_ToUint40_Underflow(SD1x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in SD1x18.
error FromSD59x18_ToSD1x18_Overflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint256.
error FromSD59x18_ToUint256_Underflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint128.
error FromSD59x18_ToUint128_Overflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint128.
error FromSD59x18_ToUint128_Underflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint40.
error FromSD59x18_ToUint40_Overflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint40.
error FromSD59x18_ToUint40_Underflow(SD59x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in SD1x18.
error FromUD60x18_ToSD1x18_Overflow(UD60x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in SD59x18.
error FromUD60x18_ToSD59x18_Overflow(UD60x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint128.
error FromUD60x18_ToUint128_Overflow(UD60x18 x);

/// @notice Emitted when trying to cast an UD60x18 number that doesn't fit in uint40.
error FromUD60x18_ToUint40_Overflow(UD60x18 x);

/*//////////////////////////////////////////////////////////////////////////
                                  CONSTANTS
//////////////////////////////////////////////////////////////////////////*/

uint256 constant MAX_UINT128 = type(uint128).max;
uint256 constant MAX_UINT40 = type(uint40).max;

/*//////////////////////////////////////////////////////////////////////////
                                  FROM SD1X18
//////////////////////////////////////////////////////////////////////////*/

/// @notice Casts an SD1x18 number to an SD59x18 number.
/// @dev There is no overflow check because the domain of SD1x18 is a subset of SD59x18.
function fromSD1x18_ToSD59x18(SD1x18 x) pure returns (SD59x18 result) {
    result = SD59x18.wrap(int256(SD1x18.unwrap(x)));
}

/// @notice Casts an SD1x18 number to UD60x18.
/// @dev This function simply calls `fromSD1x18_ToUint256` and wraps the result.
function fromSD1x18_ToUD60x18(SD1x18 x) pure returns (UD60x18 result) {
    result = UD60x18.wrap(fromSD1x18_ToUint256(x));
}

/// @notice Casts an SD1x18 number to uint256.
/// @dev Requirements:
/// - x must be positive.
function fromSD1x18_ToUint256(SD1x18 x) pure returns (uint256 result) {
    int64 xInt = SD1x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD1x18_ToUint256_Underflow(x);
    }
    result = uint256(uint64(xInt));
}

/// @notice Casts an SD1x18 number to uint128.
/// @dev Requirements:
/// - x must be positive.
function fromSD1x18_ToUint128(SD1x18 x) pure returns (uint128 result) {
    int64 xInt = SD1x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD1x18_ToUint128_Underflow(x);
    }
    result = uint128(uint64(xInt));
}

/// @notice Casts an SD59x18 number to uint40.
/// @dev Requirements:
/// - x must be positive.
/// - x must be less than or equal to `MAX_UINT40`.
function fromSD1x18_ToUint40(SD1x18 x) pure returns (uint40 result) {
    int64 xInt = SD1x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD1x18_ToUint40_Underflow(x);
    }
    if (xInt > int64(uint64(MAX_UINT40))) {
        revert FromSD1x18_ToUint40_Overflow(x);
    }
    result = uint40(uint64(xInt));
}

/*//////////////////////////////////////////////////////////////////////////
                                  FROM SD59X18
//////////////////////////////////////////////////////////////////////////*/

/// @notice Casts an SD59x18 number to SD1x18.
/// @dev Requirements:
/// - x must be less than or equal to `uMAX_SD1x18`.
function fromSD59x18_ToSD1x18(SD59x18 x) pure returns (SD1x18 result) {
    int256 xInt = SD59x18.unwrap(x);
    if (xInt > uMAX_SD1x18) {
        revert FromSD59x18_ToSD1x18_Overflow(x);
    }
    result = SD1x18.wrap(int64(xInt));
}

/// @notice Casts an SD59x18 to UD60x18.
/// @dev This function simply calls `fromSD59x18_ToUint256` and wraps the result.
function fromSD59x18_ToUD60x18(SD59x18 x) pure returns (UD60x18 result) {
    result = UD60x18.wrap(fromSD59x18_ToUint256(x));
}

/// @notice Casts an SD59x18 number to uint256.
/// @dev Requirements:
/// - x must be positive.
function fromSD59x18_ToUint256(SD59x18 x) pure returns (uint256 result) {
    int256 xInt = SD59x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD59x18_ToUint256_Underflow(x);
    }
    result = uint256(xInt);
}

/// @notice Casts an SD59x18 number to uint128.
/// @dev Requirements:
/// - x must be positive.
/// - x must be less than or equal to `uMAX_UINT128`.
function fromSD59x18_ToUint128(SD59x18 x) pure returns (uint128 result) {
    int256 xInt = SD59x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD59x18_ToUint128_Underflow(x);
    }
    if (xInt > int256(uint256(MAX_UINT128))) {
        revert FromSD59x18_ToUint128_Overflow(x);
    }
    result = uint128(uint256(xInt));
}

/// @notice Casts an SD59x18 number to uint40.
/// @dev Requirements:
/// - x must be positive.
/// - x must be less than or equal to `MAX_UINT40`.
function fromSD59x18_ToUint40(SD59x18 x) pure returns (uint40 result) {
    int256 xInt = SD59x18.unwrap(x);
    if (xInt < 0) {
        revert FromSD59x18_ToUint40_Underflow(x);
    }
    if (xInt > int256(uint256(MAX_UINT40))) {
        revert FromSD59x18_ToUint40_Overflow(x);
    }
    result = uint40(uint256(xInt));
}

/*//////////////////////////////////////////////////////////////////////////
                                    FROM UD60X18
    //////////////////////////////////////////////////////////////////////////*/

/// @notice Casts an UD60x18 number to an SD1x18 number.
/// @dev Requirements:
/// - x must be less than or equal to `uMAX_SD1x18`.
function fromUD60x18_ToSD1x18(UD60x18 x) pure returns (SD1x18 result) {
    uint256 xUint = UD60x18.unwrap(x);
    if (xUint > uint256(int256(uMAX_SD1x18))) {
        revert FromUD60x18_ToSD1x18_Overflow(x);
    }
    result = SD1x18.wrap(int64(int256(xUint)));
}

/// @notice Casts an UD60x18 number to SD59x18.
/// @dev Requirements:
/// - x must be less than or equal to `uMAX_SD59x18`.
function fromUD60x18_ToSD59x18(UD60x18 x) pure returns (SD59x18 result) {
    uint256 xUint = UD60x18.unwrap(x);
    if (xUint > uint256(uMAX_SD59x18)) {
        revert FromUD60x18_ToSD59x18_Overflow(x);
    }
    result = SD59x18.wrap(int256(xUint));
}

/// @notice Casts an UD60x18 number to uint128.
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UINT128`.
function fromUD60x18_ToUint128(UD60x18 x) pure returns (uint128 result) {
    uint256 xUint = UD60x18.unwrap(x);
    if (xUint > MAX_UINT128) {
        revert FromUD60x18_ToUint128_Overflow(x);
    }
    result = uint128(xUint);
}

/// @notice Casts an UD60x18 number to uint40.
/// @dev Requirements:
/// - x must be less than or equal to `MAX_UINT40`.
function fromUD60x18_ToUint40(UD60x18 x) pure returns (uint40 result) {
    uint256 xUint = UD60x18.unwrap(x);
    if (xUint > MAX_UINT40) {
        revert FromUD60x18_ToUint40_Overflow(x);
    }
    result = uint40(xUint);
}
