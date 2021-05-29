// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "../PRBMath.sol";
import "../PRBMathUD60x18.sol";

contract PRBMathUD60x18Mock {
    function doAvg(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18.avg(xud, yud).value;
    }

    function doCeil(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.ceil(xud).value;
    }

    function doDiv(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18.div(xud, yud).value;
    }

    function doExp(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.exp(xud).value;
    }

    function doExp2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.exp2(xud).value;
    }

    function doFloor(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.floor(xud).value;
    }

    function doFrac(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.frac(xud).value;
    }

    function doFromUint(uint256 x) external pure returns (uint256 result) {
        result = PRBMathUD60x18.fromUint(x).value;
    }

    function doGm(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18.gm(xud, yud).value;
    }

    function doInv(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.inv(xud).value;
    }

    function doLn(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.ln(xud).value;
    }

    function doLog10(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.log10(xud).value;
    }

    function doLog2(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.log2(xud).value;
    }

    function doMul(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18.mul(xud, yud).value;
    }

    function doPow(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        result = PRBMathUD60x18.pow(xud, yud).value;
    }

    function doPowu(uint256 x, uint256 y) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.powu(xud, y).value;
    }

    function doSqrt(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.sqrt(xud).value;
    }

    function doToUint(uint256 x) external pure returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        result = PRBMathUD60x18.toUint(xud);
    }

    function getE() external pure returns (uint256 result) {
        result = PRBMathUD60x18.e().value;
    }

    function getPi() external pure returns (uint256 result) {
        result = PRBMathUD60x18.pi().value;
    }

    function getScale() external pure returns (uint256 result) {
        result = PRBMathUD60x18.scale().value;
    }
}
