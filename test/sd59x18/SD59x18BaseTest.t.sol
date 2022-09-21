// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { console2 } from "forge-std/console2.sol";
import { PRBMath__BaseTest } from "../PRBMathBaseTest.t.sol";
import { MAX_SD59x18, SD59x18 } from "~/SD59x18.sol";

/// @title SD59x18__BaseTest
/// @author Paul Razvan Berg
/// @notice Common contract members needed across SD59x18 tests.
abstract contract SD59x18__BaseTest is PRBMath__BaseTest {
    /*//////////////////////////////////////////////////////////////////////////
                                       STRUCTS
    //////////////////////////////////////////////////////////////////////////*/

    struct Set {
        SD59x18 x;
        SD59x18 y;
        SD59x18 expected;
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

    function logInt(SD59x18 p0) internal view {
        console2.logInt(SD59x18.unwrap(p0));
    }

    function sd(int256 x) internal pure returns (SD59x18 result) {
        result = SD59x18.wrap(x);
    }

    function set(int256 x, int256 expected) internal pure returns (Set memory) {
        return Set({ x: sd(x), y: MAX_SD59x18, expected: sd(expected) });
    }

    function set(int256 x, SD59x18 expected) internal pure returns (Set memory) {
        return Set({ x: sd(x), y: MAX_SD59x18, expected: expected });
    }

    function set(SD59x18 x, int256 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: MAX_SD59x18, expected: sd(expected) });
    }

    function set(SD59x18 x, SD59x18 expected) internal pure returns (Set memory) {
        return Set({ x: x, y: MAX_SD59x18, expected: expected });
    }

    function set(
        int256 x,
        int256 y,
        int256 expected
    ) internal pure returns (Set memory) {
        return Set({ x: sd(x), y: sd(y), expected: sd(expected) });
    }

    function set(
        SD59x18 x,
        SD59x18 y,
        int256 expected
    ) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: sd(expected) });
    }

    function set(
        SD59x18 x,
        SD59x18 y,
        SD59x18 expected
    ) internal pure returns (Set memory) {
        return Set({ x: x, y: y, expected: expected });
    }
}
