// SPDX-License-Identifier: LGPL-3.0-or-later
pragma solidity >=0.8.0;

import "../PRBMath.sol";

contract PRBMathMock {
    function doAbs(int256 x) external pure returns (int256 result) {
        result = PRBMath.abs(x);
    }

    function doAvg(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMath.avg(x, y);
    }

    function doCeil(int256 x) external pure returns (int256 result) {
        result = PRBMath.ceil(x);
    }

    function doFloor(int256 x) external pure returns (int256 result) {
        result = PRBMath.floor(x);
    }

    function doFrac(int256 x) external pure returns (int256 result) {
        result = PRBMath.frac(x);
    }

    function doLn(int256 x) external pure returns (int256 result) {
        result = PRBMath.ln(x);
    }

    function doLog10(int256 x) external pure returns (int256 result) {
        result = PRBMath.log10(x);
    }

    function doLog2(int256 x) external pure returns (int256 result) {
        result = PRBMath.log2(x);
    }

    function getE() external pure returns (int256 result) {
        result = PRBMath.e();
    }

    function getPi() external pure returns (int256 result) {
        result = PRBMath.pi();
    }

    function getUnit() external pure returns (int256 result) {
        result = PRBMath.unit();
    }
}
