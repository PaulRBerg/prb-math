// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { console2 } from "forge-std/console2.sol";
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
    xor,
    not
} from "src/ud60x18/Helpers.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Test } from "../UD60x18.t.sol";

/// @dev Collection of tests for the helpers functions available in the UD60x18 type.
contract Helpers_Test is UD60x18_Test {
    uint256 internal constant HALF_MAX_UINT256 = type(uint256).max / 2;

    function testFuzz_Add(uint256 x, uint256 y) external {
        x = bound(x, 0, HALF_MAX_UINT256);
        y = bound(y, 0, HALF_MAX_UINT256);
        UD60x18 expected = ud(x + y);
        assertEq(add(ud(x), ud(y)), expected);
        assertEq(ud(x) + ud(y), expected);
    }

    function testFuzz_And(uint256 x, uint256 y) external {
        UD60x18 expected = ud(x & y);
        assertEq(and(ud(x), y), expected);
        assertEq(ud(x) & ud(y), expected);
    }

    function testFuzz_Eq(uint256 x) external {
        uint256 y = x;
        assertTrue(eq(ud(x), ud(y)));
        assertTrue(ud(x) == ud(y));
    }

    function testFuzz_Gt(uint256 x, uint256 y) external {
        vm.assume(x > y);
        assertTrue(gt(ud(x), ud(y)));
        assertTrue(ud(x) > ud(y));
    }

    function testFuzz_Gte(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        assertTrue(gte(ud(x), ud(y)));
        assertTrue(ud(x) >= ud(y));
    }

    function test_IsZero() external {
        UD60x18 x = ud(0);
        assertTrue(isZero(x));
    }

    function testFuzz_Lshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        UD60x18 expected = ud(x << y);
        assertEq(lshift(ud(x), y), expected);
    }

    function testFuzz_Lt(uint256 x, uint256 y) external {
        vm.assume(x < y);
        assertTrue(lt(ud(x), ud(y)));
        assertTrue(ud(x) < ud(y));
    }

    function testFuzz_Lte(uint256 x, uint256 y) external {
        vm.assume(x <= y);
        assertTrue(lte(ud(x), ud(y)));
        assertTrue(ud(x) <= ud(y));
    }

    function testFuzz_Mod(uint256 x, uint256 y) external {
        vm.assume(y > 0);
        UD60x18 expected = ud(x % y);
        assertEq(mod(ud(x), ud(y)), expected);
        assertEq(ud(x) % ud(y), expected);
    }

    function testFuzz_Neq(uint256 x, uint256 y) external {
        vm.assume(x != y);
        assertTrue(neq(ud(x), ud(y)));
        assertTrue(ud(x) != ud(y));
    }

    function testFuzz_Not(uint256 x) external {
        UD60x18 expected = ud(~x);
        assertEq(not(ud(x)), expected);
        assertEq(~ud(x), expected);
    }

    function testFuzz_Or(uint256 x, uint256 y) external {
        UD60x18 expected = ud(x | y);
        assertEq(or(ud(x), ud(y)), expected);
        assertEq(ud(x) | ud(y), expected);
    }

    function testFuzz_Rshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        UD60x18 expected = ud(x >> y);
        assertEq(rshift(ud(x), y), expected);
    }

    function testFuzz_Sub(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        UD60x18 expected = ud(x - y);
        assertEq(sub(ud(x), ud(y)), expected);
        assertEq(ud(x) - ud(y), expected);
    }

    function testFuzz_UncheckedAdd(uint256 x, uint256 y) external {
        unchecked {
            UD60x18 expected = ud(x + y);
            UD60x18 actual = uncheckedAdd(ud(x), ud(y));
            assertEq(actual, expected);
        }
    }

    function testFuzz_UncheckedSub(uint256 x, uint256 y) external {
        unchecked {
            UD60x18 expected = ud(x - y);
            UD60x18 actual = uncheckedSub(ud(x), ud(y));
            assertEq(actual, expected);
        }
    }

    function testFuzz_Xor(uint256 x, uint256 y) external {
        UD60x18 expected = ud(x ^ y);
        assertEq(xor(ud(x), ud(y)), expected);
        assertEq(ud(x) ^ ud(y), expected);
    }
}
