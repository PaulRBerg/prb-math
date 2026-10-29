// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { uMAX_UD60x18, uUNIT } from "./Constants.sol";
import {
    PRBMath_UD60x18_Convert_DecimalsTooHigh,
    PRBMath_UD60x18_Convert_Overflow,
    PRBMath_UD60x18_ConvertFrom_Overflow
} from "./Errors.sol";
import { UD60x18 } from "./ValueType.sol";

/// @dev Decimal digits represented by {uUNIT}.
uint8 constant UNIT_DECIMALS = 18;

/// @dev Largest exponent `n` for which `10^n` fits in uint256. `10^77 <= type(uint256).max < 10^78`.
uint8 constant MAX_POW10_EXPONENT = 77;

/// @notice Converts a UD60x18 number to a simple integer by dividing it by `UNIT`.
/// @dev The result is rounded toward zero.
/// @param x The UD60x18 number to convert.
/// @return result The same number in basic integer form.
function convert(UD60x18 x) pure returns (uint256 result) {
    result = UD60x18.unwrap(x) / uUNIT;
}

/// @notice Converts a UD60x18 number to an integer denominated in `decimals`.
/// @dev Scales by `10^(decimals - 18)`. The result is rounded toward zero when `decimals` is less than 18.
/// `decimals` of 0 matches {convert(UD60x18)}. `decimals` of 18 is an unwrap.
///
/// Requirements:
/// - `decimals` ≤ 95
/// - `unwrap(x) * 10^(decimals - 18)` does not overflow, when `decimals` > 18
///
/// @param x The UD60x18 number to convert.
/// @param decimals Number of decimal places in the returned integer. 6 is a 6-decimal token such as USDC.
/// @return result The same quantity, denominated in `decimals`.
function convert(UD60x18 x, uint8 decimals) pure returns (uint256 result) {
    uint256 xUint = UD60x18.unwrap(x);

    if (decimals < UNIT_DECIMALS) {
        unchecked {
            result = xUint / (10 ** uint256(UNIT_DECIMALS - decimals));
        }
    } else if (decimals > UNIT_DECIMALS) {
        uint256 exponent = uint256(decimals - UNIT_DECIMALS);
        if (exponent > MAX_POW10_EXPONENT) {
            revert PRBMath_UD60x18_Convert_DecimalsTooHigh(decimals);
        }
        uint256 scale;
        unchecked {
            scale = 10 ** exponent;
        }
        if (xUint > type(uint256).max / scale) {
            revert PRBMath_UD60x18_ConvertFrom_Overflow(x);
        }
        unchecked {
            result = xUint * scale;
        }
    } else {
        result = xUint;
    }
}

/// @notice Converts a simple integer to UD60x18 by multiplying it by `UNIT`.
///
/// @dev Requirements:
/// - x ≤ MAX_UD60x18 / UNIT
///
/// @param x The basic integer to convert.
/// @return result The same number converted to UD60x18.
function convert(uint256 x) pure returns (UD60x18 result) {
    if (x > uMAX_UD60x18 / uUNIT) {
        revert PRBMath_UD60x18_Convert_Overflow(x);
    }
    unchecked {
        result = UD60x18.wrap(x * uUNIT);
    }
}

/// @notice Converts an integer denominated in `decimals` to UD60x18.
/// @dev Scales `x` by `10^(18 - decimals)`. The result is rounded toward zero when `decimals` is greater than 18.
/// `decimals` of 0 matches {convert(uint256)}. `decimals` of 18 is a wrap.
///
/// Requirements:
/// - `decimals` ≤ 95
/// - `x * 10^(18 - decimals)` ≤ MAX_UD60x18, when `decimals` ≤ 18
///
/// @param x The integer to convert, denominated in `decimals`.
/// @param decimals Number of decimal places `x` is denominated in. 6 is a 6-decimal token such as USDC.
/// @return result The same quantity as a UD60x18 number.
function convert(uint256 x, uint8 decimals) pure returns (UD60x18 result) {
    if (decimals < UNIT_DECIMALS) {
        uint256 scale = 10 ** uint256(UNIT_DECIMALS - decimals);
        if (x > uMAX_UD60x18 / scale) {
            revert PRBMath_UD60x18_Convert_Overflow(x);
        }
        unchecked {
            result = UD60x18.wrap(x * scale);
        }
    } else if (decimals > UNIT_DECIMALS) {
        uint256 exponent = uint256(decimals - UNIT_DECIMALS);
        if (exponent > MAX_POW10_EXPONENT) {
            revert PRBMath_UD60x18_Convert_DecimalsTooHigh(decimals);
        }
        unchecked {
            result = UD60x18.wrap(x / (10 ** exponent));
        }
    } else {
        result = UD60x18.wrap(x);
    }
}
