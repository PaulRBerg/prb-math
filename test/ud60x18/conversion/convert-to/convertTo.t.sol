// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.13 <0.9.0;

import "src/UD60x18.sol";
import { UD60x18_Test } from "../../UD60x18.t.sol";

contract ConvertTo_Test is UD60x18_Test {
    function test_RevertWhen_GreaterThanMaxPermitted() external {
        uint256 x = UD60x18.unwrap(MAX_SCALED_UD60x18) + 1;
        vm.expectRevert(abi.encodeWithSelector(PRBMath_UD60x18_ConvertOverflow.selector, x));
        convert(x);
    }

    modifier lessThanOrEqualToMaxPermitted() {
        _;
    }

    function convertTo_Sets() internal returns (Set[] memory) {
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

    function test_ConvertTo() external parameterizedTest(convertTo_Sets()) lessThanOrEqualToMaxPermitted {
        UD60x18 x = convert(UD60x18.unwrap(s.x));
        assertEq(x, s.expected);
    }
}
