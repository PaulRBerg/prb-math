// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

/// @dev Collection of tests for the non-fixed-point functions in the UD60x18 type.
contract UD60x18__NonFixedPointTest is UD60x18__BaseTest {
    uint256 internal constant HALF_MAX_UINT256 = type(uint256).max / 2;

    function testAdd(uint256 x, uint256 y) external {
        x = bound(x, 0, HALF_MAX_UINT256);
        y = bound(y, 0, HALF_MAX_UINT256);
        uint256 actual = unwrap(add(wrap(x), wrap(y)));
        uint256 expected = x + y;
        assertEq(actual, expected);
    }

    function testAnd(uint256 x, uint256 y) external {
        uint256 actual = unwrap(and(wrap(x), y));
        uint256 expected = x & y;
        assertEq(actual, expected);
    }

    function testEq(uint256 x) external {
        uint256 y = x;
        bool actual = eq(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testGt(uint256 x, uint256 y) external {
        vm.assume(x > y);
        bool actual = gt(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testGte(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        bool actual = gte(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testIsZero() external {
        UD60x18 x = wrap(0);
        bool actual = isZero(x);
        bool expected = true;
        assertEq(actual, expected);
    }

    function testLshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        uint256 actual = unwrap(lshift(wrap(x), y));
        uint256 expected = x << y;
        assertEq(actual, expected);
    }

    function testLt(uint256 x, uint256 y) external {
        vm.assume(x < y);
        bool actual = lt(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testLte(uint256 x, uint256 y) external {
        vm.assume(x <= y);
        bool actual = lte(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testMod(uint256 x, uint256 y) external {
        vm.assume(y > 0);
        uint256 actual = unwrap(mod(wrap(x), wrap(y)));
        uint256 expected = x % y;
        assertEq(actual, expected);
    }

    function testNeq(uint256 x, uint256 y) external {
        vm.assume(x != y);
        bool actual = neq(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testOr(uint256 x, uint256 y) external {
        uint256 actual = unwrap(or(wrap(x), wrap(y)));
        uint256 expected = x | y;
        assertEq(actual, expected);
    }

    function testRshift(uint256 x, uint256 y) external {
        vm.assume(y <= 512);
        uint256 actual = unwrap(rshift(wrap(x), y));
        uint256 expected = x >> y;
        assertEq(actual, expected);
    }

    function testSub(uint256 x, uint256 y) external {
        vm.assume(x >= y);
        uint256 actual = unwrap(sub(wrap(x), wrap(y)));
        uint256 expected = x - y;
        assertEq(actual, expected);
    }

    function testUncheckedAdd(uint256 x, uint256 y) external {
        uint256 actual = unwrap(uncheckedAdd(wrap(x), wrap(y)));
        uint256 expected;
        unchecked {
            expected = x + y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedDiv(uint256 x, uint256 y) external {
        vm.assume(y > 0);
        uint256 actual = unwrap(uncheckedDiv(wrap(x), wrap(y)));
        uint256 expected;
        unchecked {
            expected = x / y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedMul(uint256 x, uint256 y) external {
        uint256 actual = unwrap(uncheckedMul(wrap(x), wrap(y)));
        uint256 expected;
        unchecked {
            expected = x * y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedSub(uint256 x, uint256 y) external {
        uint256 actual = unwrap(uncheckedSub(wrap(x), wrap(y)));
        uint256 expected;
        unchecked {
            expected = x - y;
        }
        assertEq(actual, expected);
    }

    function testXor(uint256 x, uint256 y) external {
        uint256 actual = unwrap(xor(wrap(x), wrap(y)));
        uint256 expected = x ^ y;
        assertEq(actual, expected);
    }
}
