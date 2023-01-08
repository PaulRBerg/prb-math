// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD2x18.sol";
import { BaseTest } from "../../BaseTest.t.sol";

/// @dev Collection of tests for the conversion functions available in the UD2x18 type.
contract UD2x18_ConversionsTest is BaseTest {
    function testFuzz_Ud2x18(uint64 x) external {
        UD2x18 actual = ud2x18(x);
        UD2x18 expected = UD2x18.wrap(x);
        assertEq(actual, expected);
    }
}
