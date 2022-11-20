// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { console2 } from "forge-std/console2.sol";
import { PRBMath__BaseTest } from "../PRBMathBaseTest.t.sol";
import { MAX_UD60x18, UD60x18, ZERO } from "~/UD60x18.sol";

/// @title UD60x18__BaseTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across UD60x18 tests.
abstract contract UD60x18__BaseTest is PRBMath__BaseTest {
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
        for (uint256 i = 0; i < testSets.length; ) {
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

    function set(UD60x18 x, UD60x18 y, uint256 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: ud(expected) });
    }

    function set(UD60x18 x, UD60x18 y, UD60x18 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: expected });
    }

    function ud(uint256 x) internal pure returns (UD60x18 result) {
        result = UD60x18.wrap(x);
    }
}
