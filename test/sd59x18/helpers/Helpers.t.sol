// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

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
    unary,
    uncheckedAdd,
    uncheckedSub,
    uncheckedUnary,
    xor,
    not
} from "src/sd59x18/Helpers.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Test } from "../SD59x18.t.sol";

/// @dev Collection of tests for the helpers functions available in the SD59x18 type.
contract Helpers_Test is SD59x18_Test {
    int256 internal constant HALF_MAX_INT256 = MAX_INT256 / 2;
    int256 internal constant HALF_MIN_INT256 = MIN_INT256 / 2;

    function testFuzz_Add(int256 x, int256 y) external {
        x = bound(x, HALF_MIN_INT256, HALF_MAX_INT256);
        y = bound(y, HALF_MIN_INT256, HALF_MAX_INT256);
        SD59x18 expected = sd(x + y);
        assertEq(add(sd(x), sd(y)), expected);
        assertEq(sd(x) + sd(y), expected);
    }

    function testFuzz_And(int256 x, int256 y) external {
        SD59x18 expected = sd(x & y);
        assertEq(and(sd(x), y), expected);
        assertEq(sd(x) & sd(y), expected);
    }

    function testFuzz_Eq(int256 x) external {
        int256 y = x;
        assertTrue(eq(sd(x), sd(y)));
        assertTrue(sd(x) == sd(y));
    }

    function testFuzz_Gt(int256 x, int256 y) external {
        vm.assume(x > y);
        assertTrue(gt(sd(x), sd(y)));
        assertTrue(sd(x) > sd(y));
    }

    function testFuzz_Gte(int256 x, int256 y) external {
        vm.assume(x >= y);
        assertTrue(gte(sd(x), sd(y)));
        assertTrue(sd(x) >= sd(y));
    }

    function test_IsZero() external {
        SD59x18 x = sd(0);
        assertTrue(isZero(x));
    }

    function testFuzz_Lshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        SD59x18 expected = sd(x << y);
        assertEq(lshift(sd(x), y), expected);
    }

    function testFuzz_Lt(int256 x, int256 y) external {
        vm.assume(x < y);
        assertTrue(lt(sd(x), sd(y)));
        assertTrue(sd(x) < sd(y));
    }

    function testFuzz_Lte(int256 x, int256 y) external {
        vm.assume(x <= y);
        assertTrue(lte(sd(x), sd(y)));
        assertTrue(sd(x) <= sd(y));
    }

    function testFuzz_Mod(int256 x, int256 y) external {
        vm.assume(y != 0);
        SD59x18 expected = sd(x % y);
        assertEq(mod(sd(x), sd(y)), expected);
        assertEq(sd(x) % sd(y), expected);
    }

    function testFuzz_Neq(int256 x, int256 y) external {
        vm.assume(x != y);
        assertTrue(neq(sd(x), sd(y)));
        assertTrue(sd(x) != sd(y));
    }

    function testFuzz_Not(int256 x) external {
        SD59x18 expected = sd(~x);
        assertEq(not(sd(x)), expected);
        assertEq(~sd(x), expected);
    }

    function testFuzz_Or(int256 x, int256 y) external {
        SD59x18 expected = sd(x | y);
        assertEq(or(sd(x), sd(y)), expected);
        assertEq(sd(x) | sd(y), expected);
    }

    function testFuzz_Rshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        SD59x18 expected = sd(x >> y);
        assertEq(rshift(sd(x), y), expected);
    }

    function testFuzz_Sub(int256 x, int256 y) external {
        x = bound(x, HALF_MIN_INT256, HALF_MAX_INT256);
        y = bound(y, HALF_MIN_INT256, HALF_MAX_INT256);
        SD59x18 expected = sd(x - y);
        assertEq(sub(sd(x), sd(y)), expected);
        assertEq(sd(x) - sd(y), expected);
    }

    function testFuzz_Unary(int256 x) external {
        // Cannot take unary of MIN_INT256, because its absolute value would be 1 unit larger than MAX_INT256.
        x = bound(x, MIN_INT256 + 1, MAX_INT256);
        SD59x18 expected = sd(-x);
        assertEq(unary(sd(x)), expected);
        assertEq(-sd(x), expected);
    }

    function testFuzz_UncheckedAdd(int256 x, int256 y) external {
        unchecked {
            SD59x18 expected = sd(x + y);
            SD59x18 actual = uncheckedAdd(sd(x), sd(y));
            assertEq(actual, expected);
        }
    }

    function testFuzz_UncheckedSub(int256 x, int256 y) external {
        unchecked {
            SD59x18 expected = sd(x - y);
            SD59x18 actual = uncheckedSub(sd(x), sd(y));
            assertEq(actual, expected);
        }
    }

    function testFuzz_Xor(int256 x, int256 y) external {
        SD59x18 expected = sd(x ^ y);
        assertEq(xor(sd(x), sd(y)), expected);
        assertEq(sd(x) ^ sd(y), expected);
    }
}
