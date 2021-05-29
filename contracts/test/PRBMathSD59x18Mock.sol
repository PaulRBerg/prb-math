// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "../PRBMath.sol";
import "../PRBMathSD59x18.sol";

contract PRBMathSD59x18Mock {
    function doAbs(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.abs(xsd).value;
    }

    function doAdd(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.add(xsd, ysd).value;
    }

    function doAvg(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.avg(xsd, ysd).value;
    }

    function doCeil(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.ceil(xsd).value;
    }

    function doDiv(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.div(xsd, ysd).value;
    }

    function doExp(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.exp(xsd).value;
    }

    function doExp2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.exp2(xsd).value;
    }

    function doFloor(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.floor(xsd).value;
    }

    function doFrac(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.frac(xsd).value;
    }

    function doFromInt(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18.fromInt(x).value;
    }

    function doGm(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.gm(xsd, ysd).value;
    }

    function doInv(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.inv(xsd).value;
    }

    function doLn(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.ln(xsd).value;
    }

    function doLog10(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.log10(xsd).value;
    }

    function doLog2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.log2(xsd).value;
    }

    function doMul(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.mul(xsd, ysd).value;
    }

    function doPow(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.pow(xsd, ysd).value;
    }

    function doPowu(int256 x, uint256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.powu(xsd, y).value;
    }

    function doSqrt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.sqrt(xsd).value;
    }

    function doSub(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18.sub(xsd, ysd).value;
    }

    function doToInt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18.toInt(xsd);
    }

    function getE() external pure returns (int256 result) {
        result = PRBMathSD59x18.e().value;
    }

    function getPi() external pure returns (int256 result) {
        result = PRBMathSD59x18.pi().value;
    }

    function getScale() external pure returns (int256 result) {
        result = PRBMathSD59x18.scale().value;
    }
}
