// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { uMAX_SD1x18 } from "../sd1x18/Constants.sol";
import { SD1x18 } from "../sd1x18/ValueType.sol";
import { uMAX_SD59x18 } from "../sd59x18/Constants.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { uMAX_UD2x18 } from "../ud2x18/Constants.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";

/// @notice Thrown when trying to cast a uint256 that doesn't fit in SD1x18.
error PRBMath_IntoSD1x18_Overflow(uint256 x);

/// @notice Thrown when trying to cast a uint256 that doesn't fit in SD59x18.
error PRBMath_IntoSD59x18_Overflow(uint256 x);

/// @notice Thrown when trying to cast a uint256 that doesn't fit in UD2x18.
error PRBMath_IntoUD2x18_Overflow(uint256 x);

/// @title PRBMathCastingUint256
/// @notice Casting utilities for uint256.
library PRBMathCastingUint256 {
    /// @notice Casts a uint256 number to SD1x18.
    /// @dev Requirements:
    /// - x must be less than or equal to `MAX_SD1x18`.
    function intoSD1x18(uint256 x) internal pure returns (SD1x18 result) {
        if (x > uint256(int256(uMAX_SD1x18))) {
            revert PRBMath_IntoSD1x18_Overflow(x);
        }
        result = SD1x18.wrap(int64(int256(x)));
    }

    /// @notice Casts a uint256 number to SD59x18.
    /// @dev Requirements:
    /// - x must be less than or equal to `MAX_SD59x18`.
    function intoSD59x18(uint256 x) internal pure returns (SD59x18 result) {
        if (x > uint256(uMAX_SD59x18)) {
            revert PRBMath_IntoSD59x18_Overflow(x);
        }
        result = SD59x18.wrap(int256(x));
    }

    /// @notice Casts a uint256 number to UD2x18.
    function intoUD2x18(uint256 x) internal pure returns (UD2x18 result) {
        if (x > uint256(uMAX_UD2x18)) {
            revert PRBMath_IntoUD2x18_Overflow(x);
        }
        result = UD2x18.wrap(uint64(x));
    }

    /// @notice Casts a uint256 number to UD60x18.
    function intoUD60x18(uint256 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(x);
    }
}
