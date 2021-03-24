// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../PRBMath.sol";

contract PRBMathMock {
    function doLog2(int256 x) public pure returns (int256) {
        return PRBMath.log2(x);
    }
}
