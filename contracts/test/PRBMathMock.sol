// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../PRBMath.sol";

contract PRBMathMock {
    function doAbs(int256 x) external pure returns (int256) {
        return PRBMath.abs(x);
    }

    function doCeil(int256 x) external pure returns (int256) {
        return PRBMath.ceil(x);
    }

    function doFloor(int256 x) external pure returns (int256) {
        return PRBMath.floor(x);
    }

    function doFrac(int256 x) external pure returns (int256) {
        return PRBMath.frac(x);
    }

    function doLn(int256 x) external pure returns (int256) {
        return PRBMath.ln(x);
    }

    function doLog2(int256 x) external pure returns (int256) {
        return PRBMath.log2(x);
    }

    function getUnit() external pure returns (int256) {
        return PRBMath.unit();
    }
}
