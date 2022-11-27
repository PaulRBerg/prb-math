// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { PRBTest } from "@prb/test/PRBTest.sol";

import { SD59x18 } from "../SD59x18.sol";
import { UD60x18 } from "../UD60x18.sol";

contract Assertions is PRBTest {
    function assertEq(SD59x18 a, SD59x18 b) internal {
        assertEq(SD59x18.unwrap(a), SD59x18.unwrap(b));
    }

    function assertEq(SD59x18 a, SD59x18 b, string memory err) internal {
        assertEq(SD59x18.unwrap(a), SD59x18.unwrap(b), err);
    }

    function assertEq(SD59x18 a, int256 b) internal {
        assertEq(SD59x18.unwrap(a), b);
    }

    function assertEq(SD59x18 a, int256 b, string memory err) internal {
        assertEq(SD59x18.unwrap(a), b, err);
    }

    function assertEq(int256 a, SD59x18 b) internal {
        assertEq(a, SD59x18.unwrap(b));
    }

    function assertEq(int256 a, SD59x18 b, string memory err) internal {
        assertEq(a, SD59x18.unwrap(b), err);
    }

    function assertEq(UD60x18 a, UD60x18 b) internal {
        assertEq(UD60x18.unwrap(a), UD60x18.unwrap(b));
    }

    function assertEq(UD60x18 a, UD60x18 b, string memory err) internal {
        assertEq(UD60x18.unwrap(a), UD60x18.unwrap(b), err);
    }

    function assertEq(UD60x18 a, uint256 b) internal {
        assertEq(UD60x18.unwrap(a), b);
    }

    function assertEq(UD60x18 a, uint256 b, string memory err) internal {
        assertEq(UD60x18.unwrap(a), b, err);
    }

    function assertEq(uint256 a, UD60x18 b) internal {
        assertEq(a, UD60x18.unwrap(b));
    }

    function assertEq(uint256 a, UD60x18 b, string memory err) internal {
        assertEq(a, UD60x18.unwrap(b), err);
    }
}
