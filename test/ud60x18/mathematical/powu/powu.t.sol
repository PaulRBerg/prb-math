// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { PRBMath__MulDiv18Overflow } from "src/Core.sol";
import { UD60x18__BaseTest } from "../../UD60x18BaseTest.t.sol";

contract UD60x18__PowuTest is UD60x18__BaseTest {
    function testPowu__BaseAndExponentZero() external {
        UD60x18 x = ZERO;
        uint256 y = 0;
        UD60x18 actual = powu(x, y);
        UD60x18 expected = ud(1e18);
        assertEq(actual, expected);
    }

    function baseZeroExponentNotZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 1, expected: 0 }));
        sets.push(set({ x: 0, y: 2, expected: 0 }));
        sets.push(set({ x: 0, y: 3, expected: 0 }));
        return sets;
    }

    function testPowu__BaseZeroExponentNotZero() external parameterizedTest(baseZeroExponentNotZeroSets()) {
        UD60x18 actual = powu(s.x, UD60x18.unwrap(s.y));
        assertEq(actual, s.expected);
    }

    modifier BaseNotZero() {
        _;
    }

    function exponentZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1e18, expected: 1e18 }));
        sets.push(set({ x: PI, expected: 1e18 }));
        sets.push(set({ x: MAX_UD60x18.sub(ud(1)), expected: 1e18 }));
        return sets;
    }

    function testPowu__ExponentZero() external parameterizedTest(exponentZeroSets()) BaseNotZero {
        UD60x18 actual = powu(s.x, UD60x18.unwrap(s.y));
        assertEq(actual, s.expected);
    }

    modifier ExponentNotZero() {
        _;
    }

    function testCannotPowu__ResultOverflowUD60x18() external BaseNotZero ExponentNotZero {
        UD60x18 x = MAX_WHOLE_UD60x18;
        uint256 y = 2;
        vm.expectRevert(
            abi.encodeWithSelector(PRBMath__MulDiv18Overflow.selector, UD60x18.unwrap(x), UD60x18.unwrap(x))
        );
        powu(x, y);
    }

    modifier ResultDoesNotOverflowUD60x18() {
        _;
    }

    function powuSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.001e18, y: 3, expected: 1e9 }));
        sets.push(set({ x: 0.1e18, y: 2, expected: 1e16 }));
        sets.push(set({ x: 1e18, y: 1, expected: 1e18 }));
        sets.push(set({ x: 2e18, y: 5, expected: 32e18 }));
        sets.push(set({ x: 2e18, y: 100, expected: 1267650600228_229401496703205376e18 }));
        sets.push(set({ x: E, y: 2, expected: 7_389056098930650225 }));
        sets.push(set({ x: PI, y: 3, expected: 31_006276680299820158 }));
        sets.push(set({ x: 5.491e18, y: 19, expected: 113077820843204_476043049664958463 }));
        sets.push(set({ x: 100e18, y: 4, expected: 1e26 }));
        sets.push(
            set({
                x: 478.77e18,
                y: 20,
                expected: 400441047687151121501368529571950234763284476825512183_793320584974037932
            })
        );
        sets.push(set({ x: 6452.166e18, y: 7, expected: 4655204093726194074224341678_62736844121311696 }));
        sets.push(set({ x: 1e24, y: 3, expected: 1e36 }));
        sets.push(
            set({
                x: 38685626227668133590.597631999999999999e18,
                y: 3,
                expected: 57896044618658097711785492504343953922145259302939748254975_940481744194640509
            })
        );
        sets.push(
            set({
                x: SQRT_MAX_UD60x18,
                y: 2,
                expected: 115792089237316195423570985008687907853269984664959999305615_707080986380425072
            })
        );
        sets.push(set({ x: MAX_WHOLE_UD60x18, y: 1, expected: MAX_WHOLE_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18, y: 1, expected: MAX_UD60x18 }));
        return sets;
    }

    function testPowu()
        external
        parameterizedTest(powuSets())
        BaseNotZero
        ExponentNotZero
        ResultDoesNotOverflowUD60x18
    {
        UD60x18 actual = powu(s.x, UD60x18.unwrap(s.y));
        assertEq(actual, s.expected);
    }
}
