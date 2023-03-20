// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { StdUtils } from "forge-std/StdUtils.sol";

import { SD1x18 } from "../sd1x18/ValueType.sol";
import { SD59x18 } from "../sd59x18/ValueType.sol";
import { UD2x18 } from "../ud2x18/ValueType.sol";
import { UD60x18 } from "../ud60x18/ValueType.sol";

contract PRBMathUtils is StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                      SD1x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `SD1x18` number.
    function bound(SD1x18 x, SD1x18 min, SD1x18 max) internal view returns (SD1x18 result) {
        result = SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an `SD1x18` number.
    function bound(SD1x18 x, int64 min, SD1x18 max) internal view returns (SD1x18 result) {
        result = SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an `SD1x18` number.
    function bound(SD1x18 x, SD1x18 min, int64 max) internal view returns (SD1x18 result) {
        result = SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max))));
    }

    /// @dev Helper function to bound an `SD1x18` number.
    function bound(SD1x18 x, int64 min, int64 max) internal view returns (SD1x18 result) {
        result = SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min), int256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      SD59X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, SD59x18 min, SD59x18 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, int256 min, SD59x18 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, SD59x18 min, int256 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound an `SD59x18` number.
    function bound(SD59x18 x, int256 min, int256 max) internal view returns (SD59x18 result) {
        result = SD59x18.wrap(bound(x.unwrap(), min, max));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD2x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `UD2x18` number.
    function bound(UD2x18 x, UD2x18 min, UD2x18 max) internal view returns (UD2x18 result) {
        result = UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound an `UD2x18` number.
    function bound(UD2x18 x, uint64 min, UD2x18 max) internal view returns (UD2x18 result) {
        result = UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound an `UD2x18` number.
    function bound(UD2x18 x, UD2x18 min, uint64 max) internal view returns (UD2x18 result) {
        result = UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max))));
    }

    /// @dev Helper function to bound an `UD2x18` number.
    function bound(UD2x18 x, uint64 min, uint64 max) internal view returns (UD2x18 result) {
        result = UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min), uint256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD60X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, UD60x18 min, UD60x18 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, uint256 min, UD60x18 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, UD60x18 min, uint256 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound an `UD60x18` number.
    function bound(UD60x18 x, uint256 min, uint256 max) internal view returns (UD60x18 result) {
        result = UD60x18.wrap(bound(x.unwrap(), min, max));
    }
}
