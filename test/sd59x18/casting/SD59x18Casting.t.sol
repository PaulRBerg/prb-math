// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { sd, sd59x18, wrap, unwrap } from "src/sd59x18/Casting.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Test } from "../SD59x18.t.sol";

/// @dev Collection of tests for the casting functions available in the SD59x18 type.
contract SD59x18_CastingTest is SD59x18_Test {
    function test_Sd(int256 x) external {
        SD59x18 actual = sd(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Sd59x18(int256 x) external {
        SD59x18 actual = sd59x18(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Wrap(int256 x) external {
        SD59x18 actual = wrap(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Unwrap(SD59x18 x) external {
        int256 actual = unwrap(x);
        int256 expected = SD59x18.unwrap(x);
        assertEq(actual, expected);
    }
}
