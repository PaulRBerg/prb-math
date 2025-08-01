// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { sqrt } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Collection of tests for the square root function available in `Common.sol`.
contract Common_Sqrt_Test is Base_Test {
    uint256 internal constant MAX_SQRT = type(uint128).max;

    function testFuzz_Sqrt_Of256BitNumber(uint256 x) external pure {
        vm.assertLe(sqrt(x) ** 2, x, "Common sqrt");
        if (x >= MAX_SQRT**2) {
            vm.assertEq(sqrt(x), MAX_SQRT, "Common sqrt");
        } else {
            vm.assertGt((sqrt(x) + 1) ** 2, x, "Common sqrt");
        }
    }

    modifier whenSquareDoesNotOverflow(uint256 x) {
        vm.assume(x <= MAX_SQRT);
        _;
    }

    function testFuzz_Sqrt_OfPerfectSquare(uint256 x) external pure whenSquareDoesNotOverflow(x) {
        vm.assertEq(sqrt(x ** 2), x, "Common sqrt");
    }

    modifier whenNotZero(uint256 x) {
        vm.assume(x != 0);
        _;
    }

    function testFuzz_Sqrt_OfAlmostPerfectSquare(uint256 x) external pure whenNotZero(x) whenSquareDoesNotOverflow(x - 1) {
        vm.assertEq(sqrt((x - 1) ** 2), x - 1, "Common sqrt");
    }

    modifier whenEven(uint256 x) {
        vm.assume(x % 2 == 0);
        _;
    }

    function testFuzz_Sqrt_OfPowerOfTwo(uint8 x) external pure whenEven(x) {
        vm.assertEq(sqrt(2 ** x), 2 ** (x / 2), "Common sqrt");
    }
}
