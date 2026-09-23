// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { sd } from "src/sd59x18/Casting.sol";
import { PI, ZERO, uUNIT } from "src/sd59x18/Constants.sol";
import { sqrt } from "src/sd59x18/Math.sol";
import { cos } from "src/sd59x18/Trigonometry.sol";
import { SD59x18 } from "src/sd59x18/ValueType.sol";

import { SD59x18_Unit_Test } from "../../SD59x18.t.sol";

contract Cos_Unit_Test is SD59x18_Unit_Test {
    function cos_Sets() internal returns (Set[] memory) {
        delete sets;
        SD59x18 SD1 = sd(1 * uUNIT);
        SD59x18 SD2 = sd(2 * uUNIT);
        SD59x18 SD3 = sd(3 * uUNIT);
        SD59x18 SD4 = sd(4 * uUNIT);
        SD59x18 SD5 = sd(5 * uUNIT);
        SD59x18 SD6 = sd(6 * uUNIT);
        sets.push(set({ x: -PI, expected: -SD1 })); // cos(-pi) = -1
        sets.push(set({ x: -PI * SD5 / SD6, expected: -sqrt(SD3) / SD2 })); // cos(-5*pi/6) = -sqrt(3)/2
        sets.push(set({ x: -PI * SD3 / SD4, expected: -sqrt(SD2) / SD2 })); // cos(-3*pi/4) = -sqrt(2)/2
        sets.push(set({ x: -PI * SD2 / SD3, expected: -SD1 / SD2 })); // cos(-2*pi/3) = -1/2
        sets.push(set({ x: -PI / SD2, expected: ZERO })); // cos(-pi/2) = 0
        sets.push(set({ x: -PI / SD3, expected: SD1 / SD2 })); // cos(-pi/3) = 1/2
        sets.push(set({ x: -PI / SD4, expected: sqrt(SD2) / SD2 })); // cos(-pi/4) = sqrt(2)/2
        sets.push(set({ x: -PI / SD6, expected: sqrt(SD3) / SD2 })); // cos(-pi/6) = sqrt(3)/2
        sets.push(set({ x: ZERO, expected: SD1 })); // cos(0) = 1
        sets.push(set({ x: PI / SD6, expected: sqrt(SD3) / SD2 })); // cos(pi/6) = sqrt(3)/2
        sets.push(set({ x: PI / SD4, expected: sqrt(SD2) / SD2 })); // cos(pi/4) = sqrt(2)/2
        sets.push(set({ x: PI / SD3, expected: SD1 / SD2 })); // cos(pi/3) = 1/2
        sets.push(set({ x: PI / SD2, expected: ZERO })); // cos(pi/2) = 0
        sets.push(set({ x: PI * SD2 / SD3, expected: -SD1 / SD2 })); // cos(2*pi/3) = -1/2
        sets.push(set({ x: PI * SD3 / SD4, expected: -sqrt(SD2) / SD2 })); // cos(3*pi/4) = -sqrt(2)/2
        sets.push(set({ x: PI * SD5 / SD6, expected: -sqrt(SD3) / SD2 })); // cos(5*pi/6) = -sqrt(3)/2
        sets.push(set({ x: PI, expected: -SD1 })); // cos(pi) = -1
        return sets;
    }

    function test_Cos() external parameterizedTest(cos_Sets()) {
        assertApproxEqAbs(
            cos(s.x).intoInt256(),
            s.expected.intoInt256(),
            0.000_000_001 ether, // 8 correct decimals
            "SD59x18 cos"
        );
    }
}
