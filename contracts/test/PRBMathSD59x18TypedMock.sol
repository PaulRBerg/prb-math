// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMath.sol";
import "../PRBMathSD59x18Typed.sol";

contract PRBMathSD59x18TypedMock {
    function doAbs(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.abs(xsd).value;
    }

    function doAdd(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.add(xsd, ysd).value;
    }

    function doAvg(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.avg(xsd, ysd).value;
    }

    function doCeil(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.ceil(xsd).value;
    }

    function doDiv(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.div(xsd, ysd).value;
    }

    function doExp(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.exp(xsd).value;
    }

    function doExp2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.exp2(xsd).value;
    }

    function doFloor(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.floor(xsd).value;
    }

    function doFrac(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.frac(xsd).value;
    }

    function doFromInt(int256 x) external pure returns (int256 result) {
        result = PRBMathSD59x18Typed.fromInt(x).value;
    }

    function doGm(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.gm(xsd, ysd).value;
    }

    function doInv(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.inv(xsd).value;
    }

    function doLn(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.ln(xsd).value;
    }

    function doLog10(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.log10(xsd).value;
    }

    function doLog2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.log2(xsd).value;
    }

    function doMul(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.mul(xsd, ysd).value;
    }

    function doPow(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.pow(xsd, ysd).value;
    }

    function doPowu(int256 x, uint256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.powu(xsd, y).value;
    }

    function doSqrt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.sqrt(xsd).value;
    }

    function doSub(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        result = PRBMathSD59x18Typed.sub(xsd, ysd).value;
    }

    function doToInt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        result = PRBMathSD59x18Typed.toInt(xsd);
    }

    function getE() external pure returns (int256 result) {
        result = PRBMathSD59x18Typed.e().value;
    }

    function getPi() external pure returns (int256 result) {
        result = PRBMathSD59x18Typed.pi().value;
    }

    function getScale() external pure returns (int256 result) {
        result = PRBMathSD59x18Typed.scale().value;
    }
}
