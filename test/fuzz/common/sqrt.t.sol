// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19 <0.9.0;

import { sqrt, MAX_UINT128 } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

/// @dev Previous implementation of `sqrt`, for verifying regressions.
///
/// From https://github.com/PaulRBerg/prb-math/blob/v4.1.0/src/Common.sol#L587-L675
function sqrtReferenceImplemenation(uint256 x) pure returns (uint256 result) {
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

/// @dev Collection of tests for the square root function `sqrt` available in `Common.sol`.
contract Common_Sqrt_Test is Base_Test {
    uint256 internal constant MAX_SQRT = MAX_UINT128;

    function testFuzz_Sqrt_OfPowerOfTwo(uint8 x) external pure {
        vm.assume(x % 2 == 0);
        vm.assertEq(sqrt(2 ** x), 2 ** (x / 2), "incorrect sqrt of power of two");
    }

    function testFuzz_Sqrt_OfPerfectSquare(uint256 x) external pure {
        x = bound(x, 0, MAX_SQRT);
        vm.assertEq(sqrt(x ** 2), x, "incorrect sqrt of perfect square");
    }

    function testFuzz_Sqrt_OfAlmostPerfectSquare(uint256 x) external pure {
        x = bound(x, 1, MAX_SQRT);
        vm.assertEq(sqrt(x ** 2 - 1), x - 1, "incorrect sqrt of almost perfect square");
    }

    /// @dev Due to rounding down, `sqrt(x)` will be `MAX_SQRT` for all `x > MAX_SQRT ** 2`.
    /// Recall that `MAX_SQRT` is 2^128 - 1.
    function testFuzz_Sqrt_OfVeryLargeNumber(uint256 x) external pure {
        x = bound(x, MAX_SQRT ** 2, type(uint256).max);
        vm.assertEq(sqrt(x), MAX_SQRT, "incorrect sqrt of very large number");
    }

    /// @dev sqrt(x)^2 ≤ x < (sqrt(x) + 1)^2
    function testFuzz_Sqrt(uint256 x) external pure {
        x = bound(x, 0, MAX_SQRT ** 2 - 1);
        vm.assertLe(sqrt(x) ** 2, x, "incorrect sqrt of very large number");
        vm.assertLt(x, (sqrt(x) + 1) ** 2, "incorrect sqrt of very large number");
    }

    function testFuzz_Sqrt_MatchesReferenceImplementation(uint256 x) external pure {
        assertEq(sqrt(x), sqrtReferenceImplemenation(x), "does not match reference implementation of sqrt");
    }
}
