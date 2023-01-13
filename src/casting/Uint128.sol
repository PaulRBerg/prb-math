// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import { SD1x18, uMAX_SD1x18 } from "../SD1x18.sol";
import { SD59x18 } from "../SD59x18.sol";
import { UD2x18, uMAX_UD2x18 } from "../UD2x18.sol";
import { UD60x18 } from "../UD60x18.sol";

/// @notice Emitted when trying to cast an uint128 that doesn't fit in SD1x18.
error PRBMath_IntoSD1x18_Overflow(uint128 x);

/// @notice Emitted when trying to cast an uint128 that doesn't fit in UD2x18.
error PRBMath_IntoUD2x18_Overflow(uint128 x);

/// @title PRBMathCastingUint128
/// @notice Casting utilities for uint128.
library PRBMathCastingUint128 {
    /// @notice Casts an uint128 number to SD1x18.
    /// @dev Requirements:
    /// - x must be less than or equal to `MAX_SD1x18`.
    function intoSD1x18(uint128 x) internal pure returns (SD1x18 result) {
        if (x > uint256(int256(uMAX_SD1x18))) {
            revert PRBMath_IntoSD1x18_Overflow(x);
        }
        result = SD1x18.wrap(int64(uint64(x)));
    }

    /// @notice Casts an uint128 number to SD59x18.
    /// @dev There is no overflow check because the domain of uint128 is a subset of SD59x18.
    function intoSD59x18(uint128 x) internal pure returns (SD59x18 result) {
        result = SD59x18.wrap(int256(uint256(x)));
    }

    /// @notice Casts an uint128 number to UD2x18.
    /// @dev Requirements:
    /// - x must be less than or equal to `MAX_SD1x18`.
    function intoUD2x18(uint128 x) internal pure returns (UD2x18 result) {
        if (x > uint64(uMAX_UD2x18)) {
            revert PRBMath_IntoUD2x18_Overflow(x);
        }
        result = UD2x18.wrap(uint64(x));
    }

    /// @notice Casts an uint128 number to UD60x18.
    /// @dev There is no overflow check because the domain of uint128 is a subset of UD60x18.
    function intoUD60x18(uint128 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(uint256(x));
    }
}
