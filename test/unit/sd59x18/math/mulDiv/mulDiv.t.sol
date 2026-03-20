// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";
import { PRBMath_MulDivSigned_Overflow, PRBMath_MulDivSigned_InputTooSmall } from "src/Common.sol";
import { MAX_SD59x18, MIN_SD59x18 } from "src/sd59x18/Constants.sol";
import { mulDiv } from "src/sd59x18/Math.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";
import { sd } from "src/sd59x18/Casting.sol";

import { SD59x18_Unit_Test } from "../../SD59x18.t.sol";

contract MulDiv_Unit_Test is SD59x18_Unit_Test {
    struct MulDivSet {
        SD59x18 x;
        SD59x18 y;
        SD59x18 denominator;
        SD59x18 expected;
    }

    MulDivSet internal sMulDiv;
    MulDivSet[] internal mulDivSets;

    modifier parameterizedMulDivTest(MulDivSet[] memory testSets) {
        uint256 length = testSets.length;
        for (uint256 i = 0; i < length; ++i) {
            sMulDiv = testSets[i];
            _;
        }
    }

    function test_RevertWhen_DenominatorZero() external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(sd(1e18), sd(1e18), sd(0));
    }

    function test_RevertWhen_InputTooSmall() external {
        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDiv(sd(type(int256).min), sd(1e18), sd(1e18));

        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDiv(sd(1e18), sd(type(int256).min), sd(1e18));

        vm.expectRevert(PRBMath_MulDivSigned_InputTooSmall.selector);
        mulDiv(sd(1e18), sd(1e18), sd(type(int256).min));
    }

    function test_RevertWhen_Overflow() external {
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDivSigned_Overflow.selector, MAX_SD59x18.unwrap(), sd(2e18).unwrap()));
        mulDiv(MAX_SD59x18, sd(2e18), sd(1e18));
    }

    function mulDiv_Sets() internal returns (MulDivSet[] memory) {
        delete mulDivSets;
        mulDivSets.push(MulDivSet({ x: sd(0), y: sd(0), denominator: sd(1e18), expected: sd(0) }));
        mulDivSets.push(MulDivSet({ x: sd(1e18), y: sd(0), denominator: sd(1e18), expected: sd(0) }));
        mulDivSets.push(MulDivSet({ x: sd(0), y: sd(1e18), denominator: sd(1e18), expected: sd(0) }));
        mulDivSets.push(MulDivSet({ x: sd(2e18), y: sd(3e18), denominator: sd(2e18), expected: sd(3e18) }));
        mulDivSets.push(MulDivSet({ x: sd(4e18), y: sd(5e18), denominator: sd(2e18), expected: sd(10e18) }));
        mulDivSets.push(MulDivSet({ x: sd(1e18), y: sd(1e18), denominator: sd(1e18), expected: sd(1e18) }));
        
        mulDivSets.push(MulDivSet({ x: sd(-1e18), y: sd(1e18), denominator: sd(1e18), expected: sd(-1e18) }));
        mulDivSets.push(MulDivSet({ x: sd(1e18), y: sd(-1e18), denominator: sd(1e18), expected: sd(-1e18) }));
        mulDivSets.push(MulDivSet({ x: sd(-1e18), y: sd(-1e18), denominator: sd(1e18), expected: sd(1e18) }));
        mulDivSets.push(MulDivSet({ x: sd(-2e18), y: sd(-3e18), denominator: sd(2e18), expected: sd(3e18) }));
        
        mulDivSets.push(MulDivSet({ x: sd(2e18), y: sd(3e18), denominator: sd(-2e18), expected: sd(-3e18) }));
        mulDivSets.push(MulDivSet({ x: sd(-2e18), y: sd(3e18), denominator: sd(-2e18), expected: sd(3e18) }));
        
        return mulDivSets;
    }

    function test_MulDiv() external parameterizedMulDivTest(mulDiv_Sets()) {
        assertEq(mulDiv(sMulDiv.x, sMulDiv.y, sMulDiv.denominator), sMulDiv.expected, "SD59x18 mulDiv");
    }
}
