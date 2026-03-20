// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";
import { PRBMath_MulDiv_Overflow } from "src/Common.sol";
import { MAX_UD60x18 } from "src/ud60x18/Constants.sol";
import { mulDiv } from "src/ud60x18/Math.sol";
import { UD60x18 } from "src/ud60x18/ValueType.sol";

import { UD60x18_Unit_Test } from "../../UD60x18.t.sol";

contract MulDiv_Unit_Test is UD60x18_Unit_Test {
    struct MulDivSet {
        UD60x18 x;
        UD60x18 y;
        UD60x18 denominator;
        UD60x18 expected;
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
        mulDiv(ud(1e18), ud(1e18), ud(0));
    }

    function test_RevertWhen_Overflow() external {
        vm.expectRevert(abi.encodeWithSelector(PRBMath_MulDiv_Overflow.selector, MAX_UD60x18.unwrap(), ud(2e18).unwrap(), ud(1e18).unwrap()));
        mulDiv(MAX_UD60x18, ud(2e18), ud(1e18));
    }

    function mulDiv_Sets() internal returns (MulDivSet[] memory) {
        delete mulDivSets;
        mulDivSets.push(MulDivSet({ x: ud(0), y: ud(0), denominator: ud(1e18), expected: ud(0) }));
        mulDivSets.push(MulDivSet({ x: ud(1e18), y: ud(0), denominator: ud(1e18), expected: ud(0) }));
        mulDivSets.push(MulDivSet({ x: ud(0), y: ud(1e18), denominator: ud(1e18), expected: ud(0) }));
        mulDivSets.push(MulDivSet({ x: ud(2e18), y: ud(3e18), denominator: ud(2e18), expected: ud(3e18) }));
        mulDivSets.push(MulDivSet({ x: ud(4e18), y: ud(5e18), denominator: ud(2e18), expected: ud(10e18) }));
        mulDivSets.push(MulDivSet({ x: ud(1e18), y: ud(1e18), denominator: ud(1e18), expected: ud(1e18) }));
        return mulDivSets;
    }

    function test_MulDiv() external parameterizedMulDivTest(mulDiv_Sets()) {
        assertEq(mulDiv(sMulDiv.x, sMulDiv.y, sMulDiv.denominator), sMulDiv.expected, "UD60x18 mulDiv");
    }
}
