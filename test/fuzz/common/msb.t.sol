// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { msb } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Previous implementation, for verifying regressions.
///
/// From https://github.com/PaulRBerg/prb-math/blob/v4.1.0/src/Common.sol#L297-L372
function originalMsb(uint256 x) pure returns (uint256 result) {
    assembly ("memory-safe") {
        let factor := shl(7, gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(6, gt(x, 0xFFFFFFFFFFFFFFFF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(5, gt(x, 0xFFFFFFFF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(4, gt(x, 0xFFFF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(3, gt(x, 0xFF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(2, gt(x, 0xF))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := shl(1, gt(x, 0x3))
        x := shr(factor, x)
        result := or(result, factor)
    }
    assembly ("memory-safe") {
        let factor := gt(x, 0x1)
        result := or(result, factor)
    }
}

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

    function testFuzz_Msb_Shifts1ToLessThanX(uint256 x) external pure whenNotZero(x) {
        assertLe(1 << msb(x), x, "Common msb");
    }

    modifier whenShiftLeftDoesNotOverflow(uint256 x) {
        vm.assume(x <= type(uint256).max >> 1);
        _;
    }

    function testFuzz_Msb_Shifts2ToMoreThan(uint256 x) external pure whenShiftLeftDoesNotOverflow(x) {
        assertGt(2 << msb(x), x, "Common msb");
    }

    function testFuzz_Msb_MatchesOriginalImplementation(uint256 x) external pure {
        assertEq(msb(x), originalMsb(x), "Common msb");
    }
}
