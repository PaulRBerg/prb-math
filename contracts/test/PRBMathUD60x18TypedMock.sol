// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.4;

import "../PRBMath.sol";
import "../PRBMathUD60x18Typed.sol";

contract PRBMathUD60x18TypedMock {
    function doAdd(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.add(xud, yud).value;
    }

    function doAvg(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.avg(xud, yud).value;
    }

    function doCeil(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.ceil(xud).value;
    }

    function doDiv(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.div(xud, yud).value;
    }

    function doExp(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.exp(xud).value;
    }

    function doExp2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.exp2(xud).value;
    }

    function doFloor(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.floor(xud).value;
    }

    function doFrac(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.frac(xud).value;
    }

    function doFromUint(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18Typed.fromUint(x).value;
    }

    function doGm(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.gm(xud, yud).value;
    }

    function doInv(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.inv(xud).value;
    }

    function doLn(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.ln(xud).value;
    }

    function doLog10(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.log10(xud).value;
    }

    function doLog2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.log2(xud).value;
    }

    function doMul(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.mul(xud, yud).value;
    }

    function doPow(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.pow(xud, yud).value;
    }

    function doPowu(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.powu(xud, y).value;
    }

    function doSqrt(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.sqrt(xud).value;
    }

    function doSub(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18Typed.sub(xud, yud).value;
    }

    function doToUint(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18Typed.toUint(xud);
    }

    function getE() external pure returns (uint256 result) {
        result = PRBMathUD60x18Typed.e().value;
    }

    function getPi() external pure returns (uint256 result) {
        result = PRBMathUD60x18Typed.pi().value;
    }

    function getScale() external pure returns (uint256 result) {
        result = PRBMathUD60x18Typed.scale().value;
    }
}
