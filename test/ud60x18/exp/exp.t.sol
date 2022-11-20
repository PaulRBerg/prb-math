// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import {
    E,
    MAX_WHOLE_UD60x18,
    MAX_UD60x18,
    PI,
    PRBMathUD60x18__ExpInputTooBig,
    UD60x18,
    ZERO,
    exp
} from "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__ExpTest is UD60x18__BaseTest {
    UD60x18 internal constant MAX_PERMITTED = UD60x18.wrap(133_084258667509499440);

    function testExp__Zero() external {
        UD60x18 x = ZERO;
        UD60x18 actual = exp(x);
        UD60x18 expected = ud(1e18);
        assertEq(actual, expected);
    }

    modifier NotZero() {
        _;
    }

    function greaterThanMaxPermittedSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: MAX_PERMITTED.add(ud(1)) }));
        sets.push(set({ x: MAX_WHOLE_UD60x18 }));
        sets.push(set({ x: MAX_UD60x18 }));
        return sets;
    }

    function testCannotExp__GreaterThanMaxPermitted()
        external
        parameterizedTest(greaterThanMaxPermittedSets())
        NotZero
    {
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__ExpInputTooBig.selector, s.x));
        exp(s.x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function expSets() internal returns (Set[] memory) {
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
        sets.push(set({ x: MAX_PERMITTED, expected: 6277101735386680754977611748738314679353920434623901771623e18 }));
        return sets;
    }

    function testExp() external parameterizedTest(expSets()) NotZero LessThanOrEqualToMaxPermitted {
        UD60x18 actual = exp(s.x);
        assertEq(actual, s.expected);
    }
}
