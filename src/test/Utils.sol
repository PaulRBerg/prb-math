// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { StdUtils } from "forge-std/StdUtils.sol";

import { SD1x18 } from "../SD1x18.sol";
import { SD59x18 } from "../SD59x18.sol";
import { UD2x18 } from "../UD2x18.sol";
import { UD60x18 } from "../UD60x18.sol";

contract PRBMathUtils is StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                      SD59X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, SD59x18 min, SD59x18 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(SD59x18.unwrap(x), SD59x18.unwrap(min), SD59x18.unwrap(max)));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, int256 min, SD59x18 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(SD59x18.unwrap(x), min, SD59x18.unwrap(max)));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, SD59x18 min, int256 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(SD59x18.unwrap(x), SD59x18.unwrap(min), max));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, int256 min, int256 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(SD59x18.unwrap(x), min, max));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD60X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, UD60x18 min, UD60x18 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(UD60x18.unwrap(x), UD60x18.unwrap(min), UD60x18.unwrap(max)));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, uint256 min, UD60x18 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(UD60x18.unwrap(x), min, UD60x18.unwrap(max)));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, UD60x18 min, uint256 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(UD60x18.unwrap(x), UD60x18.unwrap(min), max));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, uint256 min, uint256 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(UD60x18.unwrap(x), min, max));
    }
}
