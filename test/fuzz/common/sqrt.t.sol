// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { sqrt } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Previous implementation, for verifying regressions.
///
/// From https://github.com/PaulRBerg/prb-math/blob/v4.1.0/src/Common.sol#L587-L675
function originalSqrt(uint256 x) pure returns (uint256 result) {
    if (x == 0) {
        return 0;
    }

    uint256 xAux = uint256(x);
    result = 1;
    if (xAux >= 2 ** 128) {
        xAux >>= 128;
        result <<= 64;
    }
    if (xAux >= 2 ** 64) {
        xAux >>= 64;
        result <<= 32;
    }
    if (xAux >= 2 ** 32) {
        xAux >>= 32;
        result <<= 16;
    }
    if (xAux >= 2 ** 16) {
        xAux >>= 16;
        result <<= 8;
    }
    if (xAux >= 2 ** 8) {
        xAux >>= 8;
        result <<= 4;
    }
    if (xAux >= 2 ** 4) {
        xAux >>= 4;
        result <<= 2;
    }
    if (xAux >= 2 ** 2) {
        result <<= 1;
    }

    unchecked {
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;

        uint256 roundedResult = x / result;
        if (result >= roundedResult) {
            result = roundedResult;
        }
    }
}

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

    function testFuzz_Sqrt_MatchesOriginalImplementation(uint256 x) external pure {
        assertEq(sqrt(x), originalSqrt(x), "Common sqrt");
    }
}
