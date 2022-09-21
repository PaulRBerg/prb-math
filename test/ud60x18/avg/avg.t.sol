// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import { stdError } from "forge-std/StdError.sol";

import { MAX_UD60x18, MAX_WHOLE_UD60x18, UD60x18, ZERO, avg } from "~/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__AvgTest is UD60x18__BaseTest {
    function testAvg__BothOperandsZero() external {
        UD60x18 x = ZERO;
        UD60x18 y = ZERO;
        UD60x18 actual = avg(x, y);
        UD60x18 expected = ZERO;
        assertEq(actual, expected);
    }

    function onlyOneOperandZeroSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0, y: 3e18, expected: 1.5e18 }));
        sets.push(set({ x: 3e18, y: 0, expected: 1.5e18 }));
        return sets;
    }

    function testAvg__OnlyOneOperandZero() external parameterizedTest(onlyOneOperandZeroSets()) {
        UD60x18 actual = avg(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function bothEvenSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 2, y: 4, expected: 3 }));
        sets.push(set({ x: 2e18, y: 2e18, expected: 2e18 }));
        sets.push(set({ x: 4e18, y: 8e18, expected: 6e18 }));
        sets.push(set({ x: 100e18, y: 200e18, expected: 150e18 }));
        sets.push(set({ x: 1e36, y: 1e37, expected: 5.5e36 }));
        return sets;
    }

    function testAvg__NeitherOperandZero__BothEven() external parameterizedTest(bothEvenSets()) {
        UD60x18 actual = avg(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function bothOddSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1, y: 3, expected: 2 }));
        sets.push(set({ x: 1e18 + 1, y: 1e18 + 1, expected: 1e18 + 1 }));
        sets.push(set({ x: 3e18 + 1, y: 7e18 + 1, expected: 5e18 + 1 }));
        sets.push(set({ x: 99e18 + 1, y: 199e18 + 1, expected: 149e18 + 1 }));
        sets.push(set({ x: 1e36 + 1, y: 1e37 + 1, expected: 5.5e36 + 1 }));
        sets.push(set({ x: MAX_UD60x18, y: MAX_UD60x18, expected: MAX_UD60x18 }));
        return sets;
    }

    function testAvg__NeitherOperandZero__BothOdd() external parameterizedTest(bothOddSets()) {
        UD60x18 actual = avg(s.x, s.y);
        assertEq(actual, s.expected);
    }

    function oneOperandEvenTheOtherOddSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 1, y: 2, expected: 1 }));
        sets.push(set({ x: 1e18 + 1, y: 2e18, expected: 1.5e18 }));
        sets.push(set({ x: 3e18 + 1, y: 8e18, expected: 5.5e18 }));
        sets.push(set({ x: 99e18, y: 200e18, expected: 149.5e18 }));
        sets.push(set({ x: 1e36 + 1, y: 1e37 + 1e18, expected: 5.5e36 + 5e17 }));
        sets.push(
            set({
                x: MAX_UD60x18,
                y: MAX_WHOLE_UD60x18,
                expected: 115792089237316195423570985008687907853269984665640564039457_292003956564819967
            })
        );
        return sets;
    }

    function testAvg__NeitherOperandZero__OneOperandEvenTheOtherOdd()
        external
        parameterizedTest(oneOperandEvenTheOtherOddSets())
    {
        UD60x18 actual = avg(s.x, s.y);
        assertEq(actual, s.expected);
    }
}
