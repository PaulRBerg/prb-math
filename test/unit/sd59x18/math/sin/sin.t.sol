// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { PI, ZERO, uUNIT } from "src/sd59x18/Constants.sol";
import { sqrt } from "src/sd59x18/Math.sol";
import { sin } from "src/sd59x18/Trigonometry.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Unit_Test } from "../../SD59x18.t.sol";

contract Sin_Unit_Test is SD59x18_Unit_Test {
    function sin_Sets() internal returns (Set[] memory) {
        delete sets;
        SD59x18 SD1 = sd(1 * uUNIT);
        SD59x18 SD2 = sd(2 * uUNIT);
        SD59x18 SD3 = sd(3 * uUNIT);
        SD59x18 SD4 = sd(4 * uUNIT);
        SD59x18 SD5 = sd(5 * uUNIT);
        SD59x18 SD6 = sd(6 * uUNIT);
        sets.push(set({ x: -PI, expected: ZERO })); // sin(-pi) = 0
        sets.push(set({ x: -PI * SD5 / SD6, expected: -SD1 / SD2 })); // sin(-5*pi/6) = -1/2
        sets.push(set({ x: -PI * SD3 / SD4, expected: -sqrt(SD2) / SD2 })); // sin(-3*pi/4) = -sqrt(2)/2
        sets.push(set({ x: -PI * SD2 / SD3, expected: -sqrt(SD3) / SD2 })); // sin(-2*pi/3) = -sqrt(3)/2
        sets.push(set({ x: -PI / SD2, expected: -SD1 })); // sin(-pi/2) = -1
        sets.push(set({ x: -PI / SD3, expected: -sqrt(SD3) / SD2 })); // sin(-pi/3) = -sqrt(3)/2
        sets.push(set({ x: -PI / SD4, expected: -sqrt(SD2) / SD2 })); // sin(-pi/4) = -sqrt(2)/2
        sets.push(set({ x: -PI / SD6, expected: -SD1 / SD2 })); // sin(-pi/6) = -1/2
        sets.push(set({ x: ZERO, expected: ZERO })); // sin(0) = 0
        sets.push(set({ x: PI / SD6, expected: SD1 / SD2 })); // sin(pi/6) = 1/2
        sets.push(set({ x: PI / SD4, expected: sqrt(SD2) / SD2 })); // sin(pi/4) = sqrt(2)/2
        sets.push(set({ x: PI / SD3, expected: sqrt(SD3) / SD2 })); // sin(pi/3) = sqrt(3)/2
        sets.push(set({ x: PI / SD2, expected: SD1 })); // sin(pi/2) = 1
        sets.push(set({ x: PI * SD2 / SD3, expected: sqrt(SD3) / SD2 })); // sin(2*pi/3) = sqrt(3)/2
        sets.push(set({ x: PI * SD3 / SD4, expected: sqrt(SD2) / SD2 })); // sin(3*pi/4) = sqrt(2)/2
        sets.push(set({ x: PI * SD5 / SD6, expected: SD1 / SD2 })); // sin(5*pi/6) = 1/2
        sets.push(set({ x: PI, expected: ZERO })); // sin(pi) = 0
        return sets;
    }

    function test_Sin() external parameterizedTest(sin_Sets()) {
        assertApproxEqAbs(
            sin(s.x).intoInt256(),
            s.expected.intoInt256(),
            0.000_000_001 ether, // 8 correct decimals
            "SD59x18 sin"
        );
    }
}
