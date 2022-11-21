// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13;

import "src/UD60x18.sol";
import { UD60x18__BaseTest } from "../UD60x18BaseTest.t.sol";

contract UD60x18__ToTest is UD60x18__BaseTest {
    function testCannotTo__GreaterThanMaxPermitted() external {
        uint256 x = UD60x18.unwrap(MAX_SCALED_UD60x18) + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMathUD60x18__ToUD60x18Overflow.selector, x));
        toUD60x18(x);
    }

    modifier LessThanOrEqualToMaxPermitted() {
        _;
    }

    function toSets() internal returns (Set[] memory) {
        delete sets;
        sets.push(set({ x: 0.000000000000000001e18, expected: 1e18 }));
        sets.push(set({ x: 0.000000000000000002e18, expected: 2e18 }));
        sets.push(set({ x: 0.000000000000001729e18, expected: 1729e18 }));
        sets.push(set({ x: 1e18, expected: 1e36 }));
        sets.push(set({ x: 5e18, expected: 5e36 }));
        sets.push(set({ x: 2.7182e38, expected: 2.7182e56 }));
        sets.push(set({ x: 3.1415e42, expected: 3.1415e60 }));
        sets.push(set({ x: MAX_SCALED_UD60x18, expected: MAX_WHOLE_UD60x18 }));
        return sets;
    }

    function testTo() external parameterizedTest(toSets()) LessThanOrEqualToMaxPermitted {
        UD60x18 x = toUD60x18(UD60x18.unwrap(s.x));
        assertEq(x, s.expected);
    }
}
