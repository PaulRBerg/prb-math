// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { stdMath } from "forge-std/StdMath.sol";

import { sd } from "src/sd59x18/Casting.sol";
import {
    add,
    and,
    eq,
    gt,
    gte,
    isZero,
    lshift,
    lt,
    lte,
    mod,
    neq,
    or,
    rshift,
    sub,
    uncheckedAdd,
    uncheckedSub,
    uncheckedUnary,
    xor
} from "src/sd59x18/Helpers.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Test } from "../SD59x18.t.sol";

/// @dev Collection of tests for the helpers functions available in the SD59x18 type.
contract Helpers_Test is SD59x18_Test {
    int256 internal constant HALF_MAX_INT256 = type(int256).max / 2;
    int256 internal constant HALF_MIN_INT256 = type(int256).min / 2;

    function testFuzz_Add(int256 x, int256 y) external {
        x = bound(x, HALF_MIN_INT256, HALF_MAX_INT256);
        y = bound(y, HALF_MIN_INT256, HALF_MAX_INT256);
        SD59x18 actual = add(sd(x), sd(y));
        SD59x18 expected = sd(x + y);
        assertEq(actual, expected);
    }

    function testFuzz_And(int256 x, int256 y) external {
        int256 actual = and(sd(x), y).unwrap();
        int256 expected = x & y;
        assertEq(actual, expected);
    }

    function testFuzz_Eq(int256 x) external {
        int256 y = x;
        bool result = eq(sd(x), sd(y));
        assertTrue(result);
    }

    function testFuzz_Gt(int256 x, int256 y) external {
        vm.assume(x > y);
        bool result = gt(sd(x), sd(y));
        assertTrue(result);
    }

    function testFuzz_Gte(int256 x, int256 y) external {
        vm.assume(x >= y);
        bool result = gte(sd(x), sd(y));
        assertTrue(result);
    }

    function test_IsZero() external {
        SD59x18 x = sd(0);
        bool result = isZero(x);
        assertTrue(result);
    }

    function testFuzz_Lshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        int256 actual = lshift(sd(x), y).unwrap();
        int256 expected = x << y;
        assertEq(actual, expected);
    }

    function testFuzz_Lt(int256 x, int256 y) external {
        vm.assume(x < y);
        bool result = lt(sd(x), sd(y));
        assertTrue(result);
    }

    function testFuzz_Lte(int256 x, int256 y) external {
        vm.assume(x <= y);
        bool result = lte(sd(x), sd(y));
        assertTrue(result);
    }

    function testFuzz_Mod(int256 x, int256 y) external {
        vm.assume(y != 0);
        int256 actual = mod(sd(x), sd(y)).unwrap();
        int256 expected = x % y;
        assertEq(actual, expected);
    }

    function testFuzz_Neq(int256 x, int256 y) external {
        vm.assume(x != y);
        bool result = neq(sd(x), sd(y));
        assertTrue(result);
    }

    function testFuzz_Or(int256 x, int256 y) external {
        int256 actual = or(sd(x), sd(y)).unwrap();
        int256 expected = x | y;
        assertEq(actual, expected);
    }

    function testFuzz_Rshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        int256 actual = rshift(sd(x), y).unwrap();
        int256 expected = x >> y;
        assertEq(actual, expected);
    }

    function testFuzz_Sub(int256 x, int256 y) external {
        x = bound(x, HALF_MIN_INT256, HALF_MAX_INT256);
        y = bound(y, HALF_MIN_INT256, HALF_MAX_INT256);
        SD59x18 actual = sub(sd(x), sd(y));
        SD59x18 expected = sd(x - y);
        assertEq(actual, expected);
    }

    function testFuzz_UncheckedAdd(int256 x, int256 y) external {
        int256 actual = uncheckedAdd(sd(x), sd(y)).unwrap();
        int256 expected;
        unchecked {
            expected = x + y;
        }
        assertEq(actual, expected);
    }

    function testFuzz_UncheckedSub(int256 x, int256 y) external {
        int256 actual = uncheckedSub(sd(x), sd(y)).unwrap();
        int256 expected;
        unchecked {
            expected = x - y;
        }
        assertEq(actual, expected);
    }

    function testFuzz_Xor(int256 x, int256 y) external {
        int256 actual = xor(sd(x), sd(y)).unwrap();
        int256 expected = x ^ y;
        assertEq(actual, expected);
    }
}
