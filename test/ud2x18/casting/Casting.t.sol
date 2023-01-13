// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { ud2x18, wrap } from "src/ud2x18/Casting.sol";
import { UD2x18 } from "src/ud2x18/ValueType.sol";

import { BaseTest } from "../../BaseTest.t.sol";

/// @dev Collection of tests for the casting functions available in the UD2x18 type.
contract Casting_Test is BaseTest {
    function testFuzz_Ud2x18(uint64 x) external {
        UD2x18 actual = ud2x18(x);
        UD2x18 expected = UD2x18.wrap(x);
        assertEq(actual, expected);
    }

    function testFuzz_Unwrap(UD2x18 x) external {
        uint64 actual = x.unwrap();
        uint64 expected = UD2x18.unwrap(x);
        assertEq(actual, expected);
    }

    function testFuzz_Wrap(uint64 x) external {
        UD2x18 actual = wrap(x);
        UD2x18 expected = UD2x18.wrap(x);
        assertEq(actual, expected);
    }
}
