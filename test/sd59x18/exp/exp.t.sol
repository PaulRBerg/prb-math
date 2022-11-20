// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_SD59x18,
    MAX_SD59x18,
    MIN_SD59x18,
    MIN_WHOLE_SD59x18,
    PI,
    PRBMathSD59x18__ExpInputTooBig,
    SD59x18,
    ZERO,
    exp
} from "src/SD59x18.sol";
import { SD59x18__BaseTest } from "../SD59x18BaseTest.t.sol";

contract SD59x18__ExpTest is SD59x18__BaseTest {
    SD59x18 internal constant MAX_PERMITTED = SD59x18.wrap(133_084258667509499440);
    SD59x18 internal constant MIN_PERMITTED = SD59x18.wrap(-41_446531673892822322);

    function testCannotExp__Zero() external {
        SD59x18 x = ZERO;
        SD59x18 actual = exp(x);
        SD59x18 expected = sd(1e18);
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function lessThanMinPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_SD59x18 }));
        sets.push(set({ x: MIN_WHOLE_SD59x18 }));
        sets.push(set({ x: MIN_PERMITTED.sub(sd(1)) }));
        return sets;
    }

    function testExp__Negative__LessThanMinPermitted() external parameterizedTest(lessThanMinPermittedSets()) NotZero {
        SD59x18 actual = exp(s.x);
        assertEq(actual, s.expected);
    }

    function greaterThanOrEqualToMinPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MIN_PERMITTED, expected: 0.000000000000000001e18 }));
        sets.push(set({ x: -33.333333e18, expected: 0.000000000000003338e18 }));
        sets.push(set({ x: -20.82e18, expected: 0.0000000009077973e18 }));
        sets.push(set({ x: -16e18, expected: 0.000000112535174719e18 }));
        sets.push(set({ x: -11.89215e18, expected: 0.000006843919254514e18 }));
        sets.push(set({ x: -4e18, expected: 0.01831563888873418e18 }));
        sets.push(set({ x: NEGATIVE_PI, expected: 0.043213918263772249e18 }));
        sets.push(set({ x: -3e18, expected: 0.049787068367863943e18 }));
        sets.push(set({ x: NEGATIVE_E, expected: 0.065988035845312537e18 }));
        sets.push(set({ x: -2e18, expected: 0.135335283236612692e18 }));
        sets.push(set({ x: -1e18, expected: 0.367879441171442322e18 }));
        sets.push(set({ x: -1e3, expected: 0.999999999999999001e18 }));
        sets.push(set({ x: -1, expected: 1e18 }));
        return sets;
    }

    function testExp__Negative__GreaterThanOrEqualToMinPermitted()
        external
        parameterizedTest(greaterThanOrEqualToMinPermittedSets())
        NotZero
    {
        SD59x18 actual = exp(s.x);
        assertEq(actual, s.expected);
    }

    function greaterThanMaxPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_PERMITTED.add(sd(1)) }));
        sets.push(set({ x: MAX_WHOLE_SD59x18 }));
        sets.push(set({ x: MAX_SD59x18 }));
        return sets;
    }

    function testCannotExp__Positive__GreaterThanMaxPermitted()
        external
        parameterizedTest(greaterThanMaxPermittedSets())
        NotZero
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathSD59x18__ExpInputTooBig.selector, s.x));
        exp(s.x);
    }

    function lessThanOrEqualToMaxPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e18 }));
        sets.push(set({ x: 0.000000000000001e18, expected: 1000000000000001e3 }));
        sets.push(set({ x: 1e18, expected: 2_718281828459045234 }));
        sets.push(set({ x: 2e18, expected: 7_389056098930650223 }));
        sets.push(set({ x: E, expected: 15_154262241479264171 }));
        sets.push(set({ x: 3e18, expected: 20_085536923187667724 }));
        sets.push(set({ x: PI, expected: 23_140692632779268977 }));
        sets.push(set({ x: 4e18, expected: 54_598150033144239019 }));
        sets.push(set({ x: 11.89215e18, expected: 146115_107851442195849083 }));
        sets.push(set({ x: 16e18, expected: 8886110_520507872601090007 }));
        sets.push(set({ x: 20.82e18, expected: 1101567497_354306723238329100 }));
        sets.push(set({ x: 33.333333e18, expected: 299559147061116_199277615819889397 }));
        sets.push(set({ x: 64e18, expected: 6235149080811616783682415370_612321304359995711 }));
        sets.push(set({ x: 71.002e18, expected: 6851360256686184003424071446459_846369495614777170 }));
        sets.push(
            set({ x: 88.722839111672999627e18, expected: 340282366920938463222979506443879150094_819893272894857679 })
        );
        sets.push(set({ x: MAX_PERMITTED, expected: 6277101735386680754977611748738314679353_920434623901771623e18 }));
        return sets;
    }

    function testExp__Positive__LessThanOrEqualToMaxPermitted()
        external
        parameterizedTest(lessThanOrEqualToMaxPermittedSets())
        NotZero
    {
        SD59x18 actual = exp(s.x);
        assertEq(actual, s.expected);
    }
}
