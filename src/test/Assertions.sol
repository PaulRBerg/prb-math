// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { PRBTest } from "@prb/test/PRBTest.sol";

import { SD59x18 } from "../SD59x18.sol";
import { UD60x18 } from "../UD60x18.sol";

contract Assertions is PRBTest {
    function assertEq(SD59x18 a, SD59x18 b) internal {
        assertEq(SD59x18.unwrap(a), SD59x18.unwrap(b));
    }

    function assertEq(UD60x18 a, UD60x18 b) internal {
        assertEq(UD60x18.unwrap(a), UD60x18.unwrap(b));
    }
}
