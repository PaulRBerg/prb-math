// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { uMAX_SD1x18 } from "src/sd1x18/Constants.sol";
import { SD1x18 } from "src/sd1x18/ValueType.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";
import { ud21x18, wrap } from "src/ud21x18/Casting.sol";
import { uMAX_UD21x18 } from "src/ud21x18/Constants.sol";
import {
    PRBMath_UD21x18_IntoSD1x18_Overflow,
    PRBMath_UD21x18_IntoUint40_Overflow,
    PRBMath_UD21x18_IntoUint64_Overflow
} from "src/ud21x18/Errors.sol";
import { UD21x18 } from "src/ud21x18/ValueType.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { Base_Test } from "../../../Base.t.sol";

/// @dev Collection of tests for the casting functions available in UD21x18.
contract UD21x18_Casting_Fuzz_Test is Base_Test {
    function testFuzz_RevertWhen_OverflowSD1x18(UD21x18 x) external {
        x = _bound(x, uint128(uint64(uMAX_SD1x18)) + 1, uMAX_UD21x18);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD21x18_IntoSD1x18_Overflow.selector, x));
        x.intoSD1x18();
    }

    function testFuzz_IntoSD1x18(UD21x18 x) external {
        x = _bound(x, 0, uint128(uint64(uMAX_SD1x18)));
        SD1x18 actual = x.intoSD1x18();
        SD1x18 expected = SD1x18.wrap(int64(uint64(uint128(x.unwrap()))));
        assertEq(actual, expected, "UD21x18 intoSD1x18");
    }

    function testFuzz_IntoSD59x18(UD21x18 x) external {
        SD59x18 actual = x.intoSD59x18();
        SD59x18 expected = SD59x18.wrap(int256(uint256(x.unwrap())));
        assertEq(actual, expected, "UD21x18 intoSD59x18");
    }

    function testFuzz_IntoUD60x18(UD21x18 x) external {
        UD60x18 actual = x.intoUD60x18();
        UD60x18 expected = UD60x18.wrap(uint256(x.unwrap()));
        assertEq(actual, expected, "UD21x18 intoUD60x18");
    }

    function testFuzz_IntoUint256(UD21x18 x) external {
        uint256 actual = x.intoUint256();
        uint256 expected = uint256(x.unwrap());
        assertEq(actual, expected, "UD21x18 intoUint256");
    }

    function testFuzz_RevertWhen_OverflowUint40(UD21x18 x) external {
        x = _bound(x, uint128(MAX_UINT40) + 1, uMAX_UD21x18);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD21x18_IntoUint40_Overflow.selector, x));
        x.intoUint40();
    }

    function testFuzz_RevertWhen_OverflowUint64(UD21x18 x) external {
        x = _bound(x, uint128(MAX_UINT64) + 1, uMAX_UD21x18);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD21x18_IntoUint64_Overflow.selector, x));
        x.intoUint64();
    }

    function testFuzz_IntoUint40(UD21x18 x) external {
        x = _bound(x, 0, uint128(MAX_UINT40));
        uint40 actual = x.intoUint40();
        uint40 expected = uint40(x.unwrap());
        assertEq(actual, expected, "UD21x18 intoUint40");
    }

    function testFuzz_IntoUint64(UD21x18 x) external {
        x = _bound(x, 0, uint128(MAX_UINT64));
        uint64 actual = x.intoUint64();
        uint64 expected = uint64(x.unwrap());
        assertEq(actual, expected, "UD21x18 intoUint64");
    }

    function testFuzz_ud21x18(uint128 x) external {
        UD21x18 actual = ud21x18(x);
        UD21x18 expected = UD21x18.wrap(x);
        assertEq(actual, expected, "ud21x18");
    }

    function testFuzz_Unwrap(UD21x18 x) external {
        uint128 actual = x.unwrap();
        uint128 expected = UD21x18.unwrap(x);
        assertEq(actual, expected, "UD21x18 unwrap");
    }

    function testFuzz_Wrap(uint128 x) external {
        UD21x18 actual = wrap(x);
        UD21x18 expected = UD21x18.wrap(x);
        assertEq(actual, expected, "UD21x18 wrap");
    }
}
