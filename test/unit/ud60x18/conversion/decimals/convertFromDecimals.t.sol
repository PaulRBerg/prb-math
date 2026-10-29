// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { uUNIT } from "src/ud60x18/Constants.sol";
import { MAX_POW10_EXPONENT, UNIT_DECIMALS, convert } from "src/ud60x18/Conversions.sol";
import { PRBMath_UD60x18_Convert_DecimalsTooHigh, PRBMath_UD60x18_ConvertFrom_Overflow } from "src/ud60x18/Errors.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract ConvertFromDecimals_Unit_Test is UD60x18_Unit_Test {
    function test_RevertWhen_DecimalsTooHigh() external {
        uint8 decimals = MAX_POW10_EXPONENT + UNIT_DECIMALS + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_Convert_DecimalsTooHigh.selector, decimals));
        convert(UD60x18.wrap(0), decimals);
    }

    function test_RevertWhen_ProductOverflows() external {
        uint256 scale = 10;
        UD60x18 x = UD60x18.wrap(type(uint256).max / scale + 1);
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_ConvertFrom_Overflow.selector, x));
        convert(x, 19);
    }

    function test_DecimalsZero_MatchesConvert() external pure {
        assertEq(convert(UD60x18.wrap(0), 0), convert(UD60x18.wrap(0)), "zero");
        assertEq(convert(UD60x18.wrap(uUNIT), 0), convert(UD60x18.wrap(uUNIT)), "one");
        assertEq(convert(UD60x18.wrap(10e18), 0), convert(UD60x18.wrap(10e18)), "ten");
        assertEq(convert(UD60x18.wrap(uUNIT - 1), 0), 0, "fraction truncates");
    }

    function test_Decimals18_Unwraps() external pure {
        assertEq(convert(UD60x18.wrap(0), 18), 0, "zero");
        assertEq(convert(UD60x18.wrap(1), 18), 1, "one wei");
        assertEq(convert(UD60x18.wrap(10e18), 18), 10e18, "ten");
        assertEq(convert(UD60x18.wrap(type(uint256).max), 18), type(uint256).max, "max");
    }

    function test_SixDecimals_Usdc() external pure {
        assertEq(convert(UD60x18.wrap(10e18), 6), 10_000_000, "ten USDC");
        assertEq(convert(UD60x18.wrap(1e12), 6), 1, "one raw unit");
        assertEq(convert(UD60x18.wrap(1e12 - 1), 6), 0, "truncated");
    }

    function test_TwoDecimals() external pure {
        assertEq(convert(UD60x18.wrap(1.5e18), 2), 150, "1.50");
    }

    function test_Above18() external pure {
        assertEq(convert(UD60x18.wrap(1.5e18), 20), 150_000_000_000_000_000_000, "1.5 at 20 decimals");
        assertEq(convert(UD60x18.wrap(1), 20), 100, "one unit at 20 decimals");
    }

    function test_MaxScale_JustFits() external pure {
        uint256 scale = 10 ** uint256(MAX_POW10_EXPONENT);
        uint8 decimals = MAX_POW10_EXPONENT + UNIT_DECIMALS;
        assertEq(convert(UD60x18.wrap(1), decimals), scale, "one");
        assertEq(convert(UD60x18.wrap(0), decimals), 0, "zero");
        assertEq(convert(UD60x18.wrap(type(uint256).max / scale), decimals), (type(uint256).max / scale) * scale, "max product");
    }
}
