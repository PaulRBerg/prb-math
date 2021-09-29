// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "./B.sol";

contract A is B {
    function a() external pure returns (uint256) {
        return 1;
    }
}
