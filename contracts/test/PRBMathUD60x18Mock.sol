// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

import { fromUD60x18, toUD60x18, UD60x18 } from "../UD60x18.sol";

contract PRBMathUD60x18Mock {
    function doAvg(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
        result = x.avg(y);
    }

    function doCeil(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.ceil();
    }

    function doDiv(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
        result = x.div(y);
    }

    function doExp(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.exp();
    }

    function doExp2(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.exp2();
    }

    function doFloor(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.floor();
    }

    function doFrac(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.frac();
    }

    function doFromUD60x18(UD60x18 x) external pure returns (uint256 result) {
        result = fromUD60x18(x);
    }

    function doGm(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
        result = x.gm(y);
    }

    function doInv(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.inv();
    }

    function doLn(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.ln();
    }

    function doLog10(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.log10();
    }

    function doLog2(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.log2();
    }

    function doMul(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
        result = x.mul(y);
    }

    function doPow(UD60x18 x, UD60x18 y) external pure returns (UD60x18 result) {
        result = x.pow(y);
    }

    function doPowu(UD60x18 x, uint256 y) external pure returns (UD60x18 result) {
        result = x.powu(y);
    }

    function doSqrt(UD60x18 x) external pure returns (UD60x18 result) {
        result = x.sqrt();
    }

    function doToUD60x18(uint256 x) external pure returns (UD60x18 result) {
        result = toUD60x18(x);
    }
}
