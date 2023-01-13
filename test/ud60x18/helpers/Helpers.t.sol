// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import { ud, unwrap } from "src/ud60x18/Casting.sol";
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
    xor
} from "src/ud60x18/Helpers.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Test } from "../UD60x18.t.sol";

/// @dev Collection of tests for the helpers functions available in the UD60x18 type.
contract Helpers_Test is UD60x18_Test {
    uint256 internal constant HALF_MAX_UINT256 = type(uint256).max / 2;

    function testFuzz_Add(uint256 x, uint256 y) external {
        x = bound(x, 0, HALF_MAX_UINT256);
        y = bound(y, 0, HALF_MAX_UINT256);
        uint256 actual = add(ud(x), ud(y)).unwrap();
        uint256 expected = x + y;
        assertEq(actual, expected);
    }

    function testFuzz_And(uint256 x, uint256 y) external {
        uint256 actual = and(ud(x), y).unwrap();
        uint256 expected = x & y;
        assertEq(actual, expected);
    }

    function testFuzz_Eq(uint256 x) external {
        uint256 y = x;
        bool result = eq(ud(x), ud(y));
        assertTrue(result);
    }

    function testFuzz_Gt(uint256 x, uint256 y) external {
        vm.assume(x > y);
        bool result = gt(ud(x), ud(y));
        assertTrue(result);
    }

    function testFuzz_Gte(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        bool result = gte(ud(x), ud(y));
        assertTrue(result);
    }

    function test_IsZero() external {
        UD60x18 x = ud(0);
        bool result = isZero(x);
        assertTrue(result);
    }

    function testFuzz_Lshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        uint256 actual = lshift(ud(x), y).unwrap();
        uint256 expected = x << y;
        assertEq(actual, expected);
    }

    function testFuzz_Lt(uint256 x, uint256 y) external {
        vm.assume(x < y);
        bool result = lt(ud(x), ud(y));
        assertTrue(result);
    }

    function testFuzz_Lte(uint256 x, uint256 y) external {
        vm.assume(x <= y);
        bool result = lte(ud(x), ud(y));
        assertTrue(result);
    }

    function testFuzz_Mod(uint256 x, uint256 y) external {
        vm.assume(y > 0);
        uint256 actual = mod(ud(x), ud(y)).unwrap();
        uint256 expected = x % y;
        assertEq(actual, expected);
    }

    function testFuzz_Neq(uint256 x, uint256 y) external {
        vm.assume(x != y);
        bool result = neq(ud(x), ud(y));
        assertTrue(result);
    }

    function testFuzz_Or(uint256 x, uint256 y) external {
        uint256 actual = or(ud(x), ud(y)).unwrap();
        uint256 expected = x | y;
        assertEq(actual, expected);
    }

    function testFuzz_Rshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        uint256 actual = rshift(ud(x), y).unwrap();
        uint256 expected = x >> y;
        assertEq(actual, expected);
    }

    function testFuzz_Sub(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        uint256 actual = sub(ud(x), ud(y)).unwrap();
        uint256 expected = x - y;
        assertEq(actual, expected);
    }

    function testFuzz_UncheckedAdd(uint256 x, uint256 y) external {
        uint256 actual = uncheckedAdd(ud(x), ud(y)).unwrap();
        uint256 expected;
        unchecked {
            expected = x + y;
        }
        assertEq(actual, expected);
    }

    function testFuzz_UncheckedSub(uint256 x, uint256 y) external {
        uint256 actual = uncheckedSub(ud(x), ud(y)).unwrap();
        uint256 expected;
        unchecked {
            expected = x - y;
        }
        assertEq(actual, expected);
    }

    function testFuzz_Xor(uint256 x, uint256 y) external {
        uint256 actual = xor(ud(x), ud(y)).unwrap();
        uint256 expected = x ^ y;
        assertEq(actual, expected);
    }
}
