// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { sd1x18, wrap } from "src/sd1x18/Casting.sol";
import { SD1x18 } from "src/sd1x18/ValueType.sol";

import { BaseTest } from "../../BaseTest.t.sol";

/// @dev Collection of tests for the casting functions available in the SD1x18 type.
contract Casting_Test is BaseTest {
    function testFuzz_Sd1x18(int64 x) external {
        SD1x18 actual = sd1x18(x);
        SD1x18 expected = SD1x18.wrap(x);
        assertEq(actual, expected);
    }

    function testFuzz_Unwrap(SD1x18 x) external {
        int64 actual = x.unwrap();
        int64 expected = SD1x18.unwrap(x);
        assertEq(actual, expected);
    }

    function testFuzz_Wrap(int64 x) external {
        SD1x18 actual = wrap(x);
        SD1x18 expected = SD1x18.wrap(x);
        assertEq(actual, expected);
    }
}
