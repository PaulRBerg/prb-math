// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { StdUtils } from "forge-std/src/StdUtils.sol";

import { SD1x18 } from "../../src/sd1x18/ValueType.sol";
import { SD21x18 } from "../../src/sd21x18/ValueType.sol";
import { SD59x18 } from "../../src/sd59x18/ValueType.sol";
import { UD2x18 } from "../../src/ud2x18/ValueType.sol";
import { UD21x18 } from "../../src/ud21x18/ValueType.sol";
import { UD60x18 } from "../../src/ud60x18/ValueType.sol";

contract PRBMathUtils is StdUtils {
    /*//////////////////////////////////////////////////////////////////////////
                                      SD1x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an SD1x18 number, which console logs the result.
    function bound(SD1x18 x, SD1x18 min, SD1x18 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD1x18 number, which does NOT console log the result.
    function _bound(SD1x18 x, SD1x18 min, SD1x18 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(_bound(int256(x.unwrap()), int256(min.unwrap()), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD1x18 number, which console logs the result.
    function bound(SD1x18 x, int64 min, SD1x18 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD1x18 number, which does NOT console log the result.
    function _bound(SD1x18 x, int64 min, SD1x18 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(_bound(int256(x.unwrap()), int256(min), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD1x18 number, which console logs the result.
    function bound(SD1x18 x, SD1x18 min, int64 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max))));
    }

    /// @dev Helper function to bound an SD1x18 number, which does NOT console log the result.
    function _bound(SD1x18 x, SD1x18 min, int64 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(_bound(int256(x.unwrap()), int256(min.unwrap()), int256(max))));
    }

    /// @dev Helper function to bound an SD1x18 number, which console logs the result.
    function bound(SD1x18 x, int64 min, int64 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(bound(int256(x.unwrap()), int256(min), int256(max))));
    }

    /// @dev Helper function to bound an SD1x18 number, which does NOT console log the result.
    function _bound(SD1x18 x, int64 min, int64 max) internal pure returns (SD1x18) {
        return SD1x18.wrap(int64(_bound(int256(x.unwrap()), int256(min), int256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      SD21x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an SD21x18 number, which console logs the result.
    function bound(SD21x18 x, SD21x18 min, SD21x18 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD21x18 number, which does NOT console log the result.
    function _bound(SD21x18 x, SD21x18 min, SD21x18 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(_bound(x.unwrap(), int256(min.unwrap()), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD21x18 number, which console logs the result.
    function bound(SD21x18 x, int128 min, SD21x18 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(bound(int256(x.unwrap()), int256(min), int256(max.unwrap()))));
    }

    /// @dev Helper function to bound an SD21x18 number, which does NOT console log the result.
    function _bound(SD21x18 x, int128 min, SD21x18 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(_bound(x.unwrap(), min, max.unwrap())));
    }

    /// @dev Helper function to bound an SD21x18 number, which console logs the result.
    function bound(SD21x18 x, SD21x18 min, int128 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(bound(int256(x.unwrap()), int256(min.unwrap()), int256(max))));
    }

    /// @dev Helper function to bound an SD21x18 number, which does NOT console log the result.
    function _bound(SD21x18 x, SD21x18 min, int128 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(_bound(int256(x.unwrap()), int256(min.unwrap()), int256(max))));
    }

    /// @dev Helper function to bound an SD21x18 number, which console logs the result.
    function bound(SD21x18 x, int128 min, int128 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(bound(int256(x.unwrap()), int256(min), int256(max))));
    }

    /// @dev Helper function to bound an SD21x18 number, which does NOT console log the result.
    function _bound(SD21x18 x, int128 min, int128 max) internal pure returns (SD21x18) {
        return SD21x18.wrap(int128(_bound(int256(x.unwrap()), int256(min), int256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      SD59X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound an SD59x18 number, which console logs the result.
    function bound(SD59x18 x, SD59x18 min, SD59x18 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound an SD59x18 number, which does NOT console log the result.
    function _bound(SD59x18 x, SD59x18 min, SD59x18 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(_bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound an SD59x18 number, which console logs the result.
    function bound(SD59x18 x, int256 min, SD59x18 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound an SD59x18 number, which does NOT console log the result.
    function _bound(SD59x18 x, int256 min, SD59x18 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(_bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound an SD59x18 number, which console logs the result.
    function bound(SD59x18 x, SD59x18 min, int256 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound an SD59x18 number, which does NOT console log the result.
    function _bound(SD59x18 x, SD59x18 min, int256 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(_bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound an SD59x18 number, which console logs the result.
    function bound(SD59x18 x, int256 min, int256 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(bound(x.unwrap(), min, max));
    }

    /// @dev Helper function to bound an SD59x18 number, which does NOT console log the result.
    function _bound(SD59x18 x, int256 min, int256 max) internal pure returns (SD59x18) {
        return SD59x18.wrap(_bound(x.unwrap(), min, max));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD2x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound a UD2x18 number, which console logs the result.
    function bound(UD2x18 x, UD2x18 min, UD2x18 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD2x18 number, which does NOT console log the result.
    function _bound(UD2x18 x, UD2x18 min, UD2x18 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(_bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD2x18 number, which console logs the result.
    function bound(UD2x18 x, uint64 min, UD2x18 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD2x18 number, which does NOT console log the result.
    function _bound(UD2x18 x, uint64 min, UD2x18 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(_bound(uint256(x.unwrap()), uint256(min), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD2x18 number, which console logs the result.
    function bound(UD2x18 x, UD2x18 min, uint64 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max))));
    }

    /// @dev Helper function to bound a UD2x18 number, which does NOT console log the result.
    function _bound(UD2x18 x, UD2x18 min, uint64 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(_bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max))));
    }

    /// @dev Helper function to bound a UD2x18 number, which console logs the result.
    function bound(UD2x18 x, uint64 min, uint64 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(bound(uint256(x.unwrap()), uint256(min), uint256(max))));
    }

    /// @dev Helper function to bound a UD2x18 number, which does NOT console log the result.
    function _bound(UD2x18 x, uint64 min, uint64 max) internal pure returns (UD2x18) {
        return UD2x18.wrap(uint64(_bound(uint256(x.unwrap()), uint256(min), uint256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD21x18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound a UD21x18 number, which console logs the result.
    function bound(UD21x18 x, UD21x18 min, UD21x18 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD21x18 number, which does NOT console log the result.
    function _bound(UD21x18 x, UD21x18 min, UD21x18 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(_bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD21x18 number, which console logs the result.
    function bound(UD21x18 x, uint128 min, UD21x18 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(bound(uint256(x.unwrap()), uint256(min), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD21x18 number, which does NOT console log the result.
    function _bound(UD21x18 x, uint128 min, UD21x18 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(_bound(uint256(x.unwrap()), uint256(min), uint256(max.unwrap()))));
    }

    /// @dev Helper function to bound a UD21x18 number, which console logs the result.
    function bound(UD21x18 x, UD21x18 min, uint128 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max))));
    }

    /// @dev Helper function to bound a UD21x18 number, which does NOT console log the result.
    function _bound(UD21x18 x, UD21x18 min, uint128 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(_bound(uint256(x.unwrap()), uint256(min.unwrap()), uint256(max))));
    }

    /// @dev Helper function to bound a UD21x18 number, which console logs the result.
    function bound(UD21x18 x, uint128 min, uint128 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(bound(uint256(x.unwrap()), uint256(min), uint256(max))));
    }

    /// @dev Helper function to bound a UD21x18 number, which does NOT console log the result.
    function _bound(UD21x18 x, uint128 min, uint128 max) internal pure returns (UD21x18) {
        return UD21x18.wrap(uint128(_bound(uint256(x.unwrap()), uint256(min), uint256(max))));
    }

    /*//////////////////////////////////////////////////////////////////////////
                                      UD60X18
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Helper function to bound a UD60x18 number, which console logs the result.
    function bound(UD60x18 x, UD60x18 min, UD60x18 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound a UD60x18 number, which does NOT console log the result.
    function _bound(UD60x18 x, UD60x18 min, UD60x18 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(_bound(x.unwrap(), min.unwrap(), max.unwrap()));
    }

    /// @dev Helper function to bound a UD60x18 number, which console logs the result.
    function bound(UD60x18 x, uint256 min, UD60x18 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound a UD60x18 number, which does NOT console log the result.
    function _bound(UD60x18 x, uint256 min, UD60x18 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(_bound(x.unwrap(), min, max.unwrap()));
    }

    /// @dev Helper function to bound a UD60x18 number, which console logs the result.
    function bound(UD60x18 x, UD60x18 min, uint256 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound a UD60x18 number, which does NOT console log the result.
    function _bound(UD60x18 x, UD60x18 min, uint256 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(_bound(x.unwrap(), min.unwrap(), max));
    }

    /// @dev Helper function to bound a UD60x18 number, which console logs the result.
    function bound(UD60x18 x, uint256 min, uint256 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(bound(x.unwrap(), min, max));
    }

    /// @dev Helper function to bound a UD60x18 number, which does NOT console log the result.
    function _bound(UD60x18 x, uint256 min, uint256 max) internal pure returns (UD60x18) {
        return UD60x18.wrap(_bound(x.unwrap(), min, max));
    }
}
