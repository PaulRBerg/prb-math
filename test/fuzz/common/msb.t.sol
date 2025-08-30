// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { msb } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Collection of tests for the most significant bit function `msb` available in `Common.sol`.
contract Common_Msb_Test is Base_Test {
    function testFuzz_Msb_FitsUint8(uint256 x) external pure {
        assertLe(msb(x), type(uint8).max, "msb not within uint8 range");
    }

    modifier whenNotZero(uint256 x) {
        vm.assume(x != 0);
        _;
    }

    function testFuzz_Msb_ShiftsXToOneBit(uint256 x) external pure whenNotZero(x) {
        uint256 result = x >> msb(x);
        assertEq(result, 1, "x / 2^{msb(x)} != 1");
    }

    function testFuzz_Msb_Shifts1ToLessThanOrEqualToX(uint256 x) external pure whenNotZero(x) {
        assertLe(1 << msb(x), x, "2 ^ {msb(x)} not less than or equal to x");
    }

    modifier whenShiftLeftDoesNotOverflow(uint256 x) {
        vm.assume(x <= type(uint256).max / 2);
        _;
    }

    function testFuzz_Msb_Shifts2ToMoreThanX(uint256 x) external pure whenShiftLeftDoesNotOverflow(x) {
        assertGt(2 << msb(x), x, "2 ^ {msb(x)+1} not more than x");
    }
}
