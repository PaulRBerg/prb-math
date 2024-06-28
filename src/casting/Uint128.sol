// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { uMAX_SD1x18 } from "../sd1x18/Constants.sol";
import { SD1x18 } from "../sd1x18/ValueType.sol";
import { uMAX_SD21x18 } from "../sd21x18/Constants.sol";
import { SD21x18 } from "../sd21x18/ValueType.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { uMAX_UD2x18 } from "../ud2x18/Constants.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD21x18 } from "../ud21x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";

/// @notice Thrown when trying to cast a uint128 that doesn't fit in SD1x18.
error PRBMath_IntoSD1x18_Overflow(uint128 x);

/// @notice Thrown when trying to cast a uint128 that doesn't fit in SD21x18.
error PRBMath_IntoSD21x18_Overflow(uint128 x);

/// @notice Thrown when trying to cast a uint128 that doesn't fit in UD2x18.
error PRBMath_IntoUD2x18_Overflow(uint128 x);

/// @title PRBMathCastingUint128
/// @notice Casting utilities for uint128.
library PRBMathCastingUint128 {
    /// @notice Casts a uint128 number to SD1x18.
    /// @dev Requirements:
    /// - x ≤ uMAX_SD1x18
    function intoSD1x18(uint128 x) internal pure returns (SD1x18 result) {
        if (x > uint256(int256(uMAX_SD1x18))) {
            revert PRBMath_IntoSD1x18_Overflow(x);
        }
        result = SD1x18.wrap(int64(uint64(x)));
    }

    /// @notice Casts a uint128 number to SD21x18.
    /// @dev Requirements:
    /// - x ≤ uMAX_SD21x18
    function intoSD21x18(uint128 x) internal pure returns (SD21x18 result) {
        if (x > uint256(int256(uMAX_SD21x18))) {
            revert PRBMath_IntoSD21x18_Overflow(x);
        }
        result = SD21x18.wrap(int128(x));
    }

    /// @notice Casts a uint128 number to SD59x18.
    /// @dev There is no overflow check because uint128 ⊆ SD59x18.
    function intoSD59x18(uint128 x) internal pure returns (SD59x18 result) {
        result = SD59x18.wrap(int256(uint256(x)));
    }

    /// @notice Casts a uint128 number to UD2x18.
    /// @dev Requirements:
    /// - x ≤ uMAX_UD2x18
    function intoUD2x18(uint128 x) internal pure returns (UD2x18 result) {
        if (x > uint64(uMAX_UD2x18)) {
            revert PRBMath_IntoUD2x18_Overflow(x);
        }
        result = UD2x18.wrap(uint64(x));
    }

    /// @notice Casts a uint128 number to UD21x18.
    function intoUD21x18(uint128 x) internal pure returns (UD21x18 result) {
        result = UD21x18.wrap(x);
    }

    /// @notice Casts a uint128 number to UD60x18.
    /// @dev There is no overflow check because uint128 ⊆ UD60x18.
    function intoUD60x18(uint128 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(x);
    }
}
