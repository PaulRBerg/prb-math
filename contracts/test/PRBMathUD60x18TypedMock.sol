// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMath.sol";
import "../PRBMathUD60x18Typed.sol";

contract PRBMathUD60x18TypedMock {
    function doAdd(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.add(xud, yud));
    }

    function doAvg(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.avg(xud, yud));
    }

    function doCeil(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.ceil(xud));
    }

    function doDiv(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.div(xud, yud));
    }

    function doExp(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.exp(xud));
    }

    function doExp2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.exp2(xud));
    }

    function doFloor(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.floor(xud));
    }

    function doFrac(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.frac(xud));
    }

    function doFromUint(uint256 x) external pure returns (uint256 result) {
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.fromUint(x));
    }

    function doGm(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.gm(xud, yud));
    }

    function doInv(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.inv(xud));
    }

    function doLn(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.ln(xud));
    }

    function doLog10(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.log10(xud));
    }

    function doLog2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.log2(xud));
    }

    function doMul(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.mul(xud, yud));
    }

    function doPow(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.pow(xud, yud));
    }

    function doPowu(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.powu(xud, y));
    }

    function doSqrt(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.sqrt(xud));
    }

    function doSub(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        PRBMath.UD60x18 yud = PRBMath.UD60x18.wrap(y);
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.sub(xud, yud));
    }

    function doToUint(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 xud = PRBMath.UD60x18.wrap(x);
        result = PRBMathUD60x18Typed.toUint(xud);
    }

    function getE() external pure returns (uint256 result) {
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.e());
    }

    function getPi() external pure returns (uint256 result) {
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.pi());
    }

    function getScale() external pure returns (uint256 result) {
        result = PRBMath.UD60x18.unwrap(PRBMathUD60x18Typed.scale());
    }
}
