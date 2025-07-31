// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { msb } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Collection of tests for the most significant bit function available in `Common.sol`.
contract Common_Sqrt_Test is Base_Test {
    function testFuzz_Msb_FitsUint8(uint256 x) external pure {
        assertLe(msb(x), type(uint8).max, "Common msb");
    }

    modifier whenNotZero(uint256 x) {
        vm.assume(x != 0);
        _;
    }

    function testFuzz_Msb_ShiftsXToOneBit(uint256 x) external pure whenNotZero(x) {
        assertEq(x >> msb(x), 1, "Common msb");
    }

    function testFuzz_Msb_Shifts1ToLessThanOrEqualToX(uint256 x) external pure whenNotZero(x) {
        assertLe(1 << msb(x), x, "Common msb");
    }

    modifier whenShiftLeftDoesNotOverflow(uint256 x) {
        vm.assume(x <= type(uint256).max >> 1);
        _;
    }

    function testFuzz_Msb_Shifts2ToMoreThanX(uint256 x) external pure whenShiftLeftDoesNotOverflow(x) {
        assertGt(2 << msb(x), x, "Common msb");
    }
}
