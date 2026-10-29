// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { uMAX_UD60x18, uUNIT } from "src/ud60x18/Constants.sol";
import { MAX_POW10_EXPONENT, UNIT_DECIMALS, convert } from "src/ud60x18/Conversions.sol";
import { PRBMath_UD60x18_Convert_DecimalsTooHigh, PRBMath_UD60x18_Convert_Overflow } from "src/ud60x18/Errors.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract ConvertToDecimals_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_DecimalsTooHigh() external {
        uint8 decimals = MAX_POW10_EXPONENT + UNIT_DECIMALS + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Convert_DecimalsTooHigh.selector, decimals));
        convert(1, decimals);
    }

    function test_RevertWhen_ProductOverflows() external {
        uint256 x = uMAX_UD60x18 / uUNIT + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Convert_Overflow.selector, x));
        convert(x, 0);
    }

    function test_RevertWhen_ProductOverflowsAtSeventeenDecimals() external {
        uint256 scale = 10;
        uint256 x = uMAX_UD60x18 / scale + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Convert_Overflow.selector, x));
        convert(x, 17);
    }

    function test_DecimalsZero_MatchesConvert() external pure {
        assertEq(convert(0, 0), convert(0), "zero");
        assertEq(convert(1, 0), convert(1), "one");
        assertEq(convert(1729, 0), convert(1729), "1729");
        assertEq(convert(uMAX_UD60x18 / uUNIT, 0), convert(uMAX_UD60x18 / uUNIT), "max whole");
    }

    function test_Decimals18_Wraps() external pure {
        assertEq(convert(0, 18), UD60x18.wrap(0), "zero");
        assertEq(convert(1, 18), UD60x18.wrap(1), "one wei");
        assertEq(convert(10e18, 18), UD60x18.wrap(10e18), "ten");
        assertEq(convert(type(uint256).max, 18), UD60x18.wrap(type(uint256).max), "max");
    }

    function test_SixDecimals_Usdc() external pure {
        // 10 USDC, raw amount 10_000_000, is the UD60x18 number 10.
        assertEq(convert(10_000_000, 6), UD60x18.wrap(10e18), "ten USDC");
        // 1 raw unit is 1e-6, which is 1e12 in UD60x18.
        assertEq(convert(1, 6), UD60x18.wrap(1e12), "one raw unit");
    }

    function test_TwoDecimals() external pure {
        // 1.50 tokens with 2 decimals.
        assertEq(convert(150, 2), UD60x18.wrap(1.5e18), "1.50");
    }

    function test_Above18_RoundsTowardZero() external pure {
        // 1.5 tokens with 20 decimals: 1.5e20 / 1e2 = 1.5e18.
        assertEq(convert(150_000_000_000_000_000_000, 20), UD60x18.wrap(1.5e18), "1.5 at 20 decimals");
        // 150 raw units at 20 decimals is 1.5e-18, and the last two digits are truncated: 150 / 100 = 1.
        assertEq(convert(150, 20), UD60x18.wrap(1), "truncated");
        assertEq(convert(99, 20), UD60x18.wrap(0), "truncated to zero");
    }

    function test_MaxPowerOfTen() external pure {
        uint256 scale = 10 ** uint256(MAX_POW10_EXPONENT);
        uint8 decimals = MAX_POW10_EXPONENT + UNIT_DECIMALS;
        assertEq(convert(scale, decimals), UD60x18.wrap(1), "10^77 at 95 decimals");
        assertEq(convert(scale - 1, decimals), UD60x18.wrap(0), "just below 10^77");
        assertEq(convert(type(uint256).max, decimals).unwrap(), type(uint256).max / scale, "max uint");
    }
}
