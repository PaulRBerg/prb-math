export enum PRBMathErrors {
  MUL_DIV_18_OVERFLOW = "PRBMath__MulDiv18Overflow",
  MUL_DIV_OVERFLOW = "PRBMath__MulDivOverflow",
  MUL_DIV_SIGNED_INPUT_TOO_SMALL = "PRBMath__MulDivSignedInputTooSmall",
  MUL_DIV_SIGNED_OVERFLOW = "PRBMath__MulDivSignedOverflow",
}

export enum PRBMathSD59x18Errors {
  ABS_MIN_SD59x18 = "PRBMathSD59x18__AbsMinSD59x18",
  CEIL_OVERFLOW = "PRBMathSD59x18__CeilOverflow",
  DIV_INPUT_TOO_SMALL = "PRBMathSD59x18__DivInputTooSmall",
  DIV_OVERFLOW = "PRBMathSD59x18__DivOverflow",
  EXP_INPUT_TOO_BIG = "PRBMathSD59x18__ExpInputTooBig",
  EXP2_INPUT_TOO_BIG = "PRBMathSD59x18__Exp2InputTooBig",
  FLOOR_UNDERFLOW = "PRBMathSD59x18__FloorUnderflow",
  GM_NEGATIVE_PRODUCT = "PRBMathSD59x18__GmNegativeProduct",
  GM_OVERFLOW = "PRBMathSD59x18__GmOverflow",
  LOG_INPUT_TOO_SMALL = "PRBMathSD59x18__LogInputTooSmall",
  MUL_INPUT_TOO_SMALL = "PRBMathSD59x18__MulInputTooSmall",
  MUL_OVERFLOW = "PRBMathSD59x18__MulOverflow",
  POWU_OVERFLOW = "PRBMathSD59x18__PowuOverflow",
  SQRT_NEGATIVE_INPUT = "PRBMathSD59x18__SqrtNegativeInput",
  SQRT_OVERFLOW = "PRBMathSD59x18__SqrtOverflow",
  TO_SD59x18_OVERFLOW = "PRBMathSD59x18__ToSD59x18Overflow",
  TO_SD59x18_UNDERFLOW = "PRBMathSD59x18__ToSD59x18Underflow",
}

export enum PRBMathUD60x18Errors {
  ADD_OVERFLOW = "PRBMathUD60x18__AddOverflow",
  CEIL_OVERFLOW = "PRBMathUD60x18__CeilOverflow",
  EXP_INPUT_TOO_BIG = "PRBMathUD60x18__ExpInputTooBig",
  EXP2_INPUT_TOO_BIG = "PRBMathUD60x18__Exp2InputTooBig",
  GM_OVERFLOW = "PRBMathUD60x18__GmOverflow",
  LOG_INPUT_TOO_SMALL = "PRBMathUD60x18__LogInputTooSmall",
  SQRT_OVERFLOW = "PRBMathUD60x18__SqrtOverflow",
  SUB_UNDERFLOW = "PRBMathUD60x18__SubUnderflow",
  TO_UD60x18_OVERFLOW = "PRBMathUD60x18__ToUD60x18Overflow",
}
