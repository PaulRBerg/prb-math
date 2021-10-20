// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMathUD60x18.sol";

contract PRBMathUD60x18Mock {
    function doAvg(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.avg(x, y);
    }

    function doCeil(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.ceil(x);
    }

    function doDiv(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.div(x, y);
    }

    function doExp(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.exp(x);
    }

    function doExp2(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.exp2(x);
    }

    function doFloor(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.floor(x);
    }

    function doFrac(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.frac(x);
    }

    function doFromUint(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.fromUint(x);
    }

    function doGm(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.gm(x, y);
    }

    function doInv(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.inv(x);
    }

    function doLn(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.ln(x);
    }

    function doLog10(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.log10(x);
    }

    function doLog2(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.log2(x);
    }

    function doMul(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.mul(x, y);
    }

    function doPow(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.pow(x, y);
    }

    function doPowu(uint256 x, uint256 y) external pure returns (uint256 result) {
        result = PRBMathUD60x18.powu(x, y);
    }

    function doSqrt(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.sqrt(x);
    }

    function doToUint(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.toUint(x);
    }

    function getE() external pure returns (uint256 result) {
        result = PRBMathUD60x18.e();
    }

    function getPi() external pure returns (uint256 result) {
        result = PRBMathUD60x18.pi();
    }

    function getScale() external pure returns (uint256 result) {
        result = PRBMathUD60x18.scale();
    }
}
