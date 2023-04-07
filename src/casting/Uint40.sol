// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SD1x18 } from "../sd1x18/ValueType.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";

/// @title PRBMathCastingUint40
/// @notice Casting utilities for uint40.
library PRBMathCastingUint40 {
    /// @notice Casts a uint40 number into SD1x18.
    /// @dev There is no overflow check because the domain of uint40 is a subset of SD1x18.
    function intoSD1x18(uint40 x) internal pure returns (SD1x18 result) {
        result = SD1x18.wrap(int64(uint64(x)));
    }

    /// @notice Casts a uint40 number into SD59x18.
    /// @dev There is no overflow check because the domain of uint40 is a subset of SD59x18.
    function intoSD59x18(uint40 x) internal pure returns (SD59x18 result) {
        result = SD59x18.wrap(int256(uint256(x)));
    }

    /// @notice Casts a uint40 number into UD2x18.
    /// @dev There is no overflow check because the domain of uint40 is a subset of UD2x18.
    function intoUD2x18(uint40 x) internal pure returns (UD2x18 result) {
        result = UD2x18.wrap(uint64(x));
    }

    /// @notice Casts a uint40 number into UD60x18.
    /// @dev There is no overflow check because the domain of uint40 is a subset of UD60x18.
    function intoUD60x18(uint40 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(uint256(x));
    }
}
