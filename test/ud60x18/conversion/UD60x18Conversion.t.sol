// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18_Test } from "../UD60x18.t.sol";

/// @dev Collection of tests for the conversion functions available in the UD60x18 type.
contract UD60x18__HelpersTest is UD60x18_Test {
    function test_Ud(uint256 x) external {
        UD60x18 actual = ud(x);
        UD60x18 expected = UD60x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Ud60x18(uint256 x) external {
        UD60x18 actual = ud60x18(x);
        UD60x18 expected = UD60x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Wrap(uint256 x) external {
        UD60x18 actual = wrap(x);
        UD60x18 expected = UD60x18.wrap(x);
        assertEq(actual, expected);
    }

    function test_Unwrap(UD60x18 x) external {
        uint256 actual = unwrap(x);
        uint256 expected = UD60x18.unwrap(x);
        assertEq(actual, expected);
    }
}
