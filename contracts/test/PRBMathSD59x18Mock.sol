// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

import { fromSD59x18, SD59x18, toSD59x18 } from "../SD59x18.sol";

contract PRBMathSD59x18Mock {
    function doAbs(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.abs();
    }

    function doAvg(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
        result = x.avg(y);
    }

    function doCeil(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.ceil();
    }

    function doDiv(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
        result = x.div(y);
    }

    function doExp(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.exp();
    }

    function doExp2(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.exp2();
    }

    function doFloor(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.floor();
    }

    function doFrac(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.frac();
    }

    function doFromSD59x18(SD59x18 x) external pure returns (int256 result) {
        result = fromSD59x18(x);
    }

    function doGm(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
        result = x.gm(y);
    }

    function doInv(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.inv();
    }

    function doLn(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.ln();
    }

    function doLog10(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.log10();
    }

    function doLog2(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.log2();
    }

    function doMul(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
        result = x.mul(y);
    }

    function doPow(SD59x18 x, SD59x18 y) external pure returns (SD59x18 result) {
        result = x.pow(y);
    }

    function doPowu(SD59x18 x, uint256 y) external pure returns (SD59x18 result) {
        result = x.powu(y);
    }

    function doSqrt(SD59x18 x) external pure returns (SD59x18 result) {
        result = x.sqrt();
    }

    function doToSD59x18(int256 x) external pure returns (SD59x18 result) {
        result = toSD59x18(x);
    }
}
