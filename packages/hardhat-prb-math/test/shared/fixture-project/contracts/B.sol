// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "./lib/C.sol";

contract B is C {
    function b() external pure returns (uint256) {
        return 1;
    }
}
