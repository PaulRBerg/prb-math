// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMath.sol";
import "../PRBMathSD59x18Typed.sol";

contract PRBMathSD59x18TypedMock {
    function doAbs(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.abs(xsd));
    }

    function doAdd(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.add(xsd, ysd));
    }

    function doAvg(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.avg(xsd, ysd));
    }

    function doCeil(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.ceil(xsd));
    }

    function doDiv(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.div(xsd, ysd));
    }

    function doExp(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.exp(xsd));
    }

    function doExp2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.exp2(xsd));
    }

    function doFloor(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.floor(xsd));
    }

    function doFrac(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.frac(xsd));
    }

    function doFromInt(int256 x) external pure returns (int256 result) {
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.fromInt(x));
    }

    function doGm(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.gm(xsd, ysd));
    }

    function doInv(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.inv(xsd));
    }

    function doLn(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.ln(xsd));
    }

    function doLog10(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.log10(xsd));
    }

    function doLog2(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.log2(xsd));
    }

    function doMul(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.mul(xsd, ysd));
    }

    function doPow(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.pow(xsd, ysd));
    }

    function doPowu(int256 x, uint256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.powu(xsd, y));
    }

    function doSqrt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.sqrt(xsd));
    }

    function doSub(int256 x, int256 y) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        PRBMath.SD59x18 ysd = PRBMath.SD59x18.wrap(y);
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.sub(xsd, ysd));
    }

    function doToInt(int256 x) external pure returns (int256 result) {
        PRBMath.SD59x18 xsd = PRBMath.SD59x18.wrap(x);
        result = PRBMathSD59x18Typed.toInt(xsd);
    }

    function getE() external pure returns (int256 result) {
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.e());
    }

    function getPi() external pure returns (int256 result) {
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.pi());
    }

    function getScale() external pure returns (int256 result) {
        result = PRBMath.SD59x18.unwrap(PRBMathSD59x18Typed.scale());
    }
}
