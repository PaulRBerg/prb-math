// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD1x18.sol";
import { BaseTest } from "../../BaseTest.t.sol";

/// @dev Collection of tests for the conversion functions available in the SD1x18 type.
contract SD1x18__ConversionTest is BaseTest {
    function testSd1x18(int64 x) external {
        SD1x18 actual = sd1x18(x);
        SD1x18 expected = SD1x18.wrap(x);
        assertEq(actual, expected);
    }
}
