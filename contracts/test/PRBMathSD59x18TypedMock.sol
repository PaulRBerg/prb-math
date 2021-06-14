// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "hardhat/console.sol";

import "../PRBMath.sol";
import "../PRBMathSD59x18Typed.sol";

contract PRBMathSD59x18TypedMock {
    function doAbs(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.abs(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doAdd(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.add(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doAvg(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.avg(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doCeil(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.ceil(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doDiv(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.div(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doExp(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.exp(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doExp2(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.exp2(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFloor(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.floor(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFrac(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.frac(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFromInt(int256 x) external view returns (int256 result) {
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.fromInt(x);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doGm(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.gm(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doInv(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.inv(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLn(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.ln(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLog10(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.log10(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLog2(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.log2(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doMul(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.mul(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doPow(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.pow(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doPowu(int256 x, uint256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.powu(xsd, y);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doSqrt(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.sqrt(xsd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doSub(int256 x, int256 y) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        PRBMath.SD59x18 memory ysd = PRBMath.SD59x18({ value: y });
        (PRBMath.SD59x18 memory foo, uint256 gasUsed) = PRBMathSD59x18Typed.sub(xsd, ysd);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doToInt(int256 x) external view returns (int256 result) {
        PRBMath.SD59x18 memory xsd = PRBMath.SD59x18({ value: x });
        uint256 gasUsed;
        (result, gasUsed) = PRBMathSD59x18Typed.toInt(xsd);
        console.log("gasUsed", gasUsed);
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
