// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { stdError } from "forge-std/src/StdError.sol";

import { mulDiv } from "src/Common.sol";

import { Base_Test } from "../../Base.t.sol";

contract Common_MulDiv_Fuzz_Test is Base_Test {
    function testFuzz_RevertWhen_MulDiv_DenominatorZero(uint256 x, uint256 y) external {
        vm.expectRevert(stdError.divisionError);
        mulDiv(x, y, 0);
    }
}
