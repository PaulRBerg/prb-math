// SPDX-License-Identifier: WTFPL
pragma solidity >=0.8.0;

import "hardhat/console.sol";

import "../PRBMath.sol";
import "../PRBMathUD60x18Typed.sol";

contract PRBMathUD60x18TypedMock {
    function doAdd(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.add(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doAvg(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.avg(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doCeil(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.ceil(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doDiv(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.div(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doExp(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.exp(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doExp2(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.exp2(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFloor(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.floor(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFrac(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.frac(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doFromUint(uint256 x) external view returns (uint256 result) {
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.fromUint(x);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doGm(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.gm(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doInv(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.inv(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLn(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.ln(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLog10(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.log10(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doLog2(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.log2(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doMul(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.mul(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doPow(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.pow(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doPowu(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.powu(xud, y);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doSqrt(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.sqrt(xud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doSub(uint256 x, uint256 y) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        PRBMath.UD60x18 memory yud = PRBMath.UD60x18({ value: y });
        (PRBMath.UD60x18 memory foo, uint256 gasUsed) = PRBMathUD60x18Typed.sub(xud, yud);
        console.log("gasUsed", gasUsed);
        result = foo.value;
    }

    function doToUint(uint256 x) external view returns (uint256 result) {
        PRBMath.UD60x18 memory xud = PRBMath.UD60x18({ value: x });
        uint256 gasUsed;
        (result, gasUsed) = PRBMathUD60x18Typed.toUint(xud);
        console.log("gasUsed", gasUsed);
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
