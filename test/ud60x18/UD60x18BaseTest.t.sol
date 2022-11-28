// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { console2 } from "forge-std/console2.sol";
import { BaseTest } from "../BaseTest.t.sol";
import { MAX_UD60x18, UD60x18, ZERO } from "src/UD60x18.sol";

/// @title UD60x18__BaseTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across UD60x18 tests.
abstract contract UD60x18__BaseTest is BaseTest {
    /*//////////////////////////////////////////////////////////////////////////
                                      CONSTANTS
    //////////////////////////////////////////////////////////////////////////*/

    UD60x18 internal constant MAX_SCALED_UD60x18 =
        UD60x18.wrap(115792089237316195423570985008687907853269_984665640564039457);
    UD60x18 internal constant SQRT_MAX_UD60x18 = UD60x18.wrap(340282366920938463463374607431_768211455999999999);

    /// @dev This is needed to be passed as the "expected" argument. The "set" function cannot be overridden
    /// to have two implementations that each has two "int256" arguments.
    UD60x18 internal constant NIL = ZERO;

    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Set {
        UD60x18 x;
        UD60x18 y;
        UD60x18 expected;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                  TESTING VARIABLES
    //////////////////////////////////////////////////////////////////////////*/

    Set internal s;
    Set[] internal sets;

    /*//////////////////////////////////////////////////////////////////////////
                                      MODIFIERS
    //////////////////////////////////////////////////////////////////////////*/

    modifier parameterizedTest(Set[] memory testSets) {
        uint256 length = testSets.length;
        for (uint256 i = 0; i < length; ) {
            s = testSets[i];
            _;
            unchecked {
                i += 1;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                              CONSTANT HELPER FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    function log(string memory p0, UD60x18 p1) internal view {
        console2.log(p0, UD60x18.unwrap(p1));
    }

    function logUd(UD60x18 p0) internal view {
        console2.logUint(UD60x18.unwrap(p0));
    }

    function set(uint256 x) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: ZERO, expected: ZERO });
    }

    function set(UD60x18 x) internal pure returns (Set memory) {
        return Set({ x: x, y: ZERO, expected: ZERO });
    }

    function set(uint256 x, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: ZERO, expected: ud(expected) });
    }

    function set(uint256 x, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: ZERO, expected: expected });
    }

    function set(UD60x18 x, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: ZERO, expected: ud(expected) });
    }

    function set(UD60x18 x, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: ZERO, expected: expected });
    }

    function set(uint256 x, uint256 y, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: ud(y), expected: ud(expected) });
    }

    function set(uint256 x, uint256 y, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: ud(y), expected: expected });
    }

    function set(uint256 x, UD60x18 y, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: y, expected: ud(expected) });
    }

    function set(uint256 x, UD60x18 y, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: ud(x), y: y, expected: expected });
    }

    function set(UD60x18 x, uint256 y, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: ud(y), expected: ud(expected) });
    }

    function set(UD60x18 x, UD60x18 y, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: ud(expected) });
    }

    function set(UD60x18 x, uint256 y, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: ud(y), expected: expected });
    }

    function set(UD60x18 x, UD60x18 y, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: expected });
    }

    function ud(uint256 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(x);
    }
}
