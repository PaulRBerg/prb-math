export enum PRBMathErrors {
  MUL_DIV_FIXED_POINT_OVERFLOW = "PRBMath__MulDivFixedPointOverflow",
  MUL_DIV_OVERFLOW = "PRBMath__MulDivOverflow",
  MUL_DIV_SIGNED_INPUT_TOO_SMALL = "PRBMath__MulDivSignedInputTooSmall",
  MUL_DIV_SIGNED_OVERFLOW = "PRBMath__MulDivSignedOverflow",
}

export enum PRBMathSD59x18Errors {
  ABS_INPUT_TOO_SMALL = "PRBMathSD59x18__AbsInputTooSmall",
  CEIL_OVERFLOW = "PRBMathSD59x18__CeilOverflow",
  DIV_INPUT_TOO_SMALL = "PRBMathSD59x18__DivInputTooSmall",
  DIV_OVERFLOW = "PRBMathSD59x18__DivOverflow",
  EXP_INPUT_TOO_BIG = "PRBMathSD59x18__ExpInputTooBig",
  EXP2_INPUT_TOO_BIG = "PRBMathSD59x18__Exp2InputTooBig",
  FLOOR_UNDERFLOW = "PRBMathSD59x18__FloorUnderflow",
  FROM_INT_OVERFLOW = "PRBMathSD59x18__FromIntOverflow",
  FROM_INT_UNDERFLOW = "PRBMathSD59x18__FromIntUnderflow",
  GM_NEGATIVE_PRODUCT = "PRBMathSD59x18__GmNegativeProduct",
  GM_OVERFLOW = "PRBMathSD59x18__GmOverflow",
  LOG_INPUT_TOO_SMALL = "PRBMathSD59x18__LogInputTooSmall",
  MUL_INPUT_TOO_SMALL = "PRBMathSD59x18__MulInputTooSmall",
  MUL_OVERFLOW = "PRBMathSD59x18__MulOverflow",
  POWU_OVERFLOW = "PRBMathSD59x18__PowuOverflow",
  SQRT_NEGATIVE_INPUT = "PRBMathSD59x18__SqrtNegativeInput",
  SQRT_OVERFLOW = "PRBMathSD59x18__SqrtOverflow",
}

export enum PRBMathUD60x18Errors {
  ADD_OVERFLOW = "PRBMathUD60x18__AddOverflow",
  CEIL_OVERFLOW = "PRBMathUD60x18__CeilOverflow",
  EXP_INPUT_TOO_BIG = "PRBMathUD60x18__ExpInputTooBig",
  EXP2_INPUT_TOO_BIG = "PRBMathUD60x18__Exp2InputTooBig",
  FROM_UINT_OVERFLOW = "PRBMathUD60x18__FromUintOverflow",
  GM_OVERFLOW = "PRBMathUD60x18__GmOverflow",
  LOG_INPUT_TOO_SMALL = "PRBMathUD60x18__LogInputTooSmall",
  SQRT_OVERFLOW = "PRBMathUD60x18__SqrtOverflow",
  SUB_UNDERFLOW = "PRBMathUD60x18__SubUnderflow",
}
