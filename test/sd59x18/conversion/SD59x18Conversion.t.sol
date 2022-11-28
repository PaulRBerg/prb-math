// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

/// @dev Collection of tests for the conversion functions available in the SD59x18 type.
contract SD59x18__ConversionTest is SD59x18__BaseTest {
    function testSd(int256 x) external {
        SD59x18 actual = sd(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function testSd59x18(int256 x) external {
        SD59x18 actual = sd59x18(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function testWrap(int256 x) external {
        SD59x18 actual = wrap(x);
        SD59x18 expected = SD59x18.wrap(x);
        assertEq(actual, expected);
    }

    function testUnwrap(SD59x18 x) external {
        int256 actual = unwrap(x);
        int256 expected = SD59x18.unwrap(x);
        assertEq(actual, expected);
    }
}
