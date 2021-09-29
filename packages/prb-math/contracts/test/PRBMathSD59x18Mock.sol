// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMathSD59x18.sol";

contract PRBMathSD59x18Mock {
    function doAbs(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.abs(x);
    }

    function doAvg(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.avg(x, y);
    }

    function doCeil(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.ceil(x);
    }

    function doDiv(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.div(x, y);
    }

    function doExp(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.exp(x);
    }

    function doExp2(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.exp2(x);
    }

    function doFloor(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.floor(x);
    }

    function doFrac(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.frac(x);
    }

    function doFromInt(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.fromInt(x);
    }

    function doGm(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.gm(x, y);
    }

    function doInv(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.inv(x);
    }

    function doLn(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.ln(x);
    }

    function doLog10(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.log10(x);
    }

    function doLog2(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.log2(x);
    }

    function doMul(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.mul(x, y);
    }

    function doPow(int256 x, int256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.pow(x, y);
    }

    function doPowu(int256 x, uint256 y) external pure returns (int256 result) {
        result = PRBMathSD59x18.powu(x, y);
    }

    function doSqrt(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.sqrt(x);
    }

    function doToInt(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.toInt(x);
    }

    function getE() external pure returns (int256 result) {
        result = PRBMathSD59x18.e();
    }

    function getPi() external pure returns (int256 result) {
        result = PRBMathSD59x18.pi();
    }

    function getScale() external pure returns (int256 result) {
        result = PRBMathSD59x18.scale();
    }
}
