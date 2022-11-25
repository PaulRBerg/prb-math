// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import "src/UD60x18.sol";
import { PRBMath__MulDivOverflow } from "src/Core.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__DivTest is UD60x18__BaseTest {
    function testCannotDiv__DenominatorZero() external {
        UD60x18 x = ud(1e18);
        UD60x18 y = ZERO;
        vm.expectRevert(stdError.divisionError);
        div(x, y);
    }

    modifier DenominatorNotZero() {
        _;
    }

    function numeratorZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 0.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0, y: 1e18, expected: 0 }));
        sets.push(set({ x: 0, y: PI, expected: 0 }));
        sets.push(set({ x: 0, y: 1e24, expected: 0 }));
        return sets;
    }

    function testDiv__NumeratorZero() external parameterizedTest(numeratorZeroSets()) DenominatorNotZero {
        UD60x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function testCannotDiv__ResultOverflowUD60x18() external DenominatorNotZero {
        UD60x18 x = MAX_SCALED_UD60x18.add(ud(1));
        UD60x18 y = ud(0.000000000000000001e18);
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath__MulDivOverflow.selector, UD60x18.unwrap(x), UNIT_UINT, UD60x18.unwrap(y))
        );
        div(x, y);
    }

    modifier ResultNotOverflowUD60x18() {
        _;
    }

    function divSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, y: MAX_UD60x18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: 1.000000000000000001e18, expected: 0 }));
        sets.push(set({ x: 0.000000000000000001e18, y: 1e18, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: 1e13, y: 1e13, expected: 1e18 }));
        sets.push(set({ x: 1e13, y: 0.00002e18, expected: 5e17 }));
        sets.push(set({ x: 0.05e18, y: 0.02e18, expected: 25e17 }));
        sets.push(set({ x: 0.1e18, y: 0.01e18, expected: 10e18 }));
        sets.push(set({ x: 2e18, y: 2e18, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 5e18, expected: 4e17 }));
        sets.push(set({ x: 4e18, y: 2e18, expected: 2e18 }));
        sets.push(set({ x: 22e18, y: 7e18, expected: 3_142857142857142857 }));
        sets.push(set({ x: 100.135e18, y: 100.134e18, expected: 1_000009986617931971 }));
        sets.push(set({ x: 772.05e18, y: 199.98e18, expected: 3_860636063606360636 }));
        sets.push(set({ x: 2503e18, y: 918882.11e18, expected: 0.002723962054283546e18 }));
        sets.push(set({ x: 1e24, y: 1e18, expected: 1e24 }));
        sets.push(set({ x: MAX_SCALED_UD60x18, y: 0.000000000000000001e18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function testDiv() external parameterizedTest(divSets()) DenominatorNotZero ResultNotOverflowUD60x18 {
        UD60x18 actual = div(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
