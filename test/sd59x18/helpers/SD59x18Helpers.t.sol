// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";
import { stdMath } from "forge-std/StdMath.sol";

/// @dev Collection of tests for the helpers functions available in the SD59x18 type.
contract SD59x18__HelpersTest is SD59x18__BaseTest {
    function testAdd() external {
        int256 x = 1;
        int256 y = 3;
        SD59x18 actual = add(wrap(x), wrap(y));
        SD59x18 expected = wrap(x + y);
        assertEq(actual, expected);

        x = -1;
        y = 3;
        actual = add(wrap(x), wrap(y));
        expected = wrap(x + y);
        assertEq(actual, expected);

        x = 1;
        y = -3;
        actual = add(wrap(x), wrap(y));
        expected = wrap(x + y);
        assertEq(actual, expected);

        x = -1;
        y = -3;
        actual = add(wrap(x), wrap(y));
        expected = wrap(x + y);
        assertEq(actual, expected);
    }

    function testAnd(int256 x, int256 y) external {
        int256 actual = unwrap(and(wrap(x), y));
        int256 expected = x & y;
        assertEq(actual, expected);
    }

    function testEq(int256 x) external {
        int256 y = x;
        bool actual = eq(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testGt(int256 x, int256 y) external {
        vm.assume(x > y);
        bool actual = gt(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testGte(int256 x, int256 y) external {
        vm.assume(x >= y);
        bool actual = gte(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testIsZero() external {
        SD59x18 x = wrap(0);
        bool actual = isZero(x);
        bool expected = true;
        assertEq(actual, expected);
    }

    function testLshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        int256 actual = unwrap(lshift(wrap(x), y));
        int256 expected = x << y;
        assertEq(actual, expected);
    }

    function testLt(int256 x, int256 y) external {
        vm.assume(x < y);
        bool actual = lt(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testLte(int256 x, int256 y) external {
        vm.assume(x <= y);
        bool actual = lte(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testMod(int256 x, int256 y) external {
        vm.assume(y > 0);
        int256 actual = unwrap(mod(wrap(x), wrap(y)));
        int256 expected = x % y;
        assertEq(actual, expected);
    }

    function testNeq(int256 x, int256 y) external {
        vm.assume(x != y);
        bool actual = neq(wrap(x), wrap(y));
        bool expected = true;
        assertEq(actual, expected);
    }

    function testOr(int256 x, int256 y) external {
        int256 actual = unwrap(or(wrap(x), wrap(y)));
        int256 expected = x | y;
        assertEq(actual, expected);
    }

    function testRshift(int256 x, uint256 y) external {
        bound(y, 0, 512);
        int256 actual = unwrap(rshift(wrap(x), y));
        int256 expected = x >> y;
        assertEq(actual, expected);
    }

    function testSub() external {
        int256 x = 1;
        int256 y = 3;
        SD59x18 actual = sub(wrap(x), wrap(y));
        SD59x18 expected = wrap(x - y);
        assertEq(actual, expected);

        x = -1;
        y = 3;
        actual = sub(wrap(x), wrap(y));
        expected = wrap(x - y);
        assertEq(actual, expected);

        x = 1;
        y = -3;
        actual = sub(wrap(x), wrap(y));
        expected = wrap(x - y);
        assertEq(actual, expected);

        x = -1;
        y = -3;
        actual = sub(wrap(x), wrap(y));
        expected = wrap(x - y);
        assertEq(actual, expected);
    }

    function testUncheckedAdd(int256 x, int256 y) external {
        int256 actual = unwrap(uncheckedAdd(wrap(x), wrap(y)));
        int256 expected;
        unchecked {
            expected = x + y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedDiv(int256 x, int256 y) external {
        vm.assume(y > 0);
        int256 actual = unwrap(uncheckedDiv(wrap(x), wrap(y)));
        int256 expected;
        unchecked {
            expected = x / y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedMul(int256 x, int256 y) external {
        int256 actual = unwrap(uncheckedMul(wrap(x), wrap(y)));
        int256 expected;
        unchecked {
            expected = x * y;
        }
        assertEq(actual, expected);
    }

    function testUncheckedSub(int256 x, int256 y) external {
        int256 actual = unwrap(uncheckedSub(wrap(x), wrap(y)));
        int256 expected;
        unchecked {
            expected = x - y;
        }
        assertEq(actual, expected);
    }

    function testXor(int256 x, int256 y) external {
        int256 actual = unwrap(xor(wrap(x), wrap(y)));
        int256 expected = x ^ y;
        assertEq(actual, expected);
    }
}
