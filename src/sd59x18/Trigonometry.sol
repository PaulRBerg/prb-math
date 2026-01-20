// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { SD59x18 } from "./ValueType.sol";
import { uUNIT } from "./Constants.sol";

// Pi / 2;
int256 constant uPI2 = 1_570796326794896619;

// Cordic renormalisation factor
int256 constant K = 607252935008881256;

// ATANXX is atan(2**-x) ie the angle (in rad) which tan is 2**-x
int256 constant ATAN00 = 785398163397448320;
int256 constant ATAN01 = 463647609000806080;
int256 constant ATAN02 = 244978663126864128;
int256 constant ATAN03 = 124354994546761440;
int256 constant ATAN04 = 62418809995957352;
int256 constant ATAN05 = 31239833430268276;
int256 constant ATAN06 = 15623728620476832;
int256 constant ATAN07 = 7812341060101111;
int256 constant ATAN08 = 3906230131966972;
int256 constant ATAN09 = 1953122516478819;
int256 constant ATAN10 = 976562189559320;
int256 constant ATAN11 = 488281211194898;
int256 constant ATAN12 = 244140620149362;
int256 constant ATAN13 = 122070311893670;
int256 constant ATAN14 = 61035156174209;
int256 constant ATAN15 = 30517578115526;
int256 constant ATAN16 = 15258789061316;
int256 constant ATAN17 = 7629394531102;
int256 constant ATAN18 = 3814697265606;
int256 constant ATAN19 = 1907348632810;
int256 constant ATAN20 = 953674316406;
int256 constant ATAN21 = 476837158203;
int256 constant ATAN22 = 238418579102;
int256 constant ATAN23 = 119209289551;
int256 constant ATAN24 = 59604644775;
int256 constant ATAN25 = 29802322388;
int256 constant ATAN26 = 14901161194;
int256 constant ATAN27 = 7450580597;
int256 constant ATAN28 = 3725290298;
int256 constant ATAN29 = 1862645149;
int256 constant ATAN30 = 931322575;
int256 constant ATAN31 = 465661287;
// int256 constant ATAN32 = 232830644;
// int256 constant ATAN33 = 116415322;
// int256 constant ATAN34 = 58207661;
// int256 constant ATAN35 = 29103830;
// int256 constant ATAN36 = 14551915;
// int256 constant ATAN37 = 7275958;
// int256 constant ATAN38 = 3637979;
// int256 constant ATAN39 = 1818989;
// int256 constant ATAN40 = 909495;
// int256 constant ATAN41 = 454747;
// int256 constant ATAN42 = 227374;
// int256 constant ATAN43 = 113687;
// int256 constant ATAN44 = 56843;
// int256 constant ATAN45 = 28422;
// int256 constant ATAN46 = 14211;
// int256 constant ATAN47 = 7105;
// int256 constant ATAN48 = 3553;
// int256 constant ATAN49 = 1776;
// int256 constant ATAN50 = 888;
// int256 constant ATAN51 = 444;
// int256 constant ATAN52 = 222;
// int256 constant ATAN53 = 111;
// int256 constant ATAN54 = 56;
// int256 constant ATAN55 = 28;
// int256 constant ATAN56 = 14;
// int256 constant ATAN57 = 7;
// int256 constant ATAN58 = 3;
// int256 constant ATAN59 = 2;
// int256 constant ATAN60 = 1;

function cordic_step(int256 x, int256 y, int256 z, int256 f, int256 t) pure returns (int256 x2, int256 y2, int256 z2, int256 f2) {
    assembly {
        let delta := sub(mul(sgt(z, 0), 2), 1) // z > 0 ? 1 : -1
        x2 := sub(x, sdiv(mul(mul(delta, y), f), uUNIT)) // x - delta * y * f / uUNIT
        y2 := add(y, sdiv(mul(mul(delta, x), f), uUNIT)) // y + delta * x * f / uUNIT
        z2 := sub(z, mul(delta, t)) // z + delta * t
        f2 := shr(1, f) // f / 2
    }
}

function cordic(int256 t) pure returns (int256, int256) {
    unchecked {
        int256 q = ((t / uPI2) % 4 + 4) % 4;
        int256 x = uUNIT;
        int256 y = 0;
        int256 z = t % uPI2;
        int256 f = uUNIT;
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN00);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN01);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN02);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN03);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN04);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN05);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN06);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN07);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN08);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN09);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN10);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN11);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN12);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN13);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN14);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN15);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN16);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN17);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN18);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN19);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN20);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN21);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN22);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN23);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN24);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN25);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN26);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN27);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN28);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN29);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN30);
        (x, y, z, f) = cordic_step(x, y, z, f, ATAN31);
        x = x * K / uUNIT;
        y = y * K / uUNIT;
        return (q == 0) ? (x, y) : (q == 1) ? (-y, x) : (q == 2) ? (-x, -y) : (y, -x);
    }
}

function cos(SD59x18 t) pure returns (SD59x18) {
    (int256 x,) = cordic(SD59x18.unwrap(t));
    return SD59x18.wrap(x);
}

function sin(SD59x18 t) pure returns (SD59x18) {
    (, int256 y) = cordic(SD59x18.unwrap(t));
    return SD59x18.wrap(y);
}
