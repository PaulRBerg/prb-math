export enum PanicCodes {
  ArithmeticOverflowOrUnderflow = "0x11",
  DivisionByZero = "0x12",
}

export enum PRBMathErrors {
  MulDivFixedPointOverflow = "PRBMath__MulDivFixedPointOverflow",
  MulDivOverflow = "PRBMath__MulDivOverflow",
  MulDivSignedInputTooSmall = "PRBMath__MulDivSignedInputTooSmall",
  MulDivSignedOverflow = "PRBMath__MulDivSignedOverflow",
}

export enum PRBMathSD59x18Errors {
  AbsInputTooSmall = "PRBMathSD59x18__AbsInputTooSmall",
  CeilOverflow = "PRBMathSD59x18__CeilOverflow",
  DivInputTooSmall = "PRBMathSD59x18__DivInputTooSmall",
  DivOverflow = "PRBMathSD59x18__DivOverflow",
  ExpInputTooBig = "PRBMathSD59x18__ExpInputTooBig",
  Exp2InputTooBig = "PRBMathSD59x18__Exp2InputTooBig",
  FloorUnderflow = "PRBMathSD59x18__FloorUnderflow",
  FromIntOverflow = "PRBMathSD59x18__FromIntOverflow",
  FromIntUnderflow = "PRBMathSD59x18__FromIntUnderflow",
  GmNegativeProduct = "PRBMathSD59x18__GmNegativeProduct",
  GmOverflow = "PRBMathSD59x18__GmOverflow",
  LogInputTooSmall = "PRBMathSD59x18__LogInputTooSmall",
  MulInputTooSmall = "PRBMathSD59x18__MulInputTooSmall",
  MulOverflow = "PRBMathSD59x18__MulOverflow",
  PowuOverflow = "PRBMathSD59x18__PowuOverflow",
  SqrtNegativeInput = "PRBMathSD59x18__SqrtNegativeInput",
  SqrtOverflow = "PRBMathSD59x18__SqrtOverflow",
}

export enum PRBMathUD60x18Errors {
  AddOverflow = "PRBMathUD60x18__AddOverflow",
  CeilOverflow = "PRBMathUD60x18__CeilOverflow",
  ExpInputTooBig = "PRBMathUD60x18__ExpInputTooBig",
  Exp2InputTooBig = "PRBMathUD60x18__Exp2InputTooBig",
  FromUintOverflow = "PRBMathUD60x18__FromUintOverflow",
  GmOverflow = "PRBMathUD60x18__GmOverflow",
  LogInputTooSmall = "PRBMathUD60x18__LogInputTooSmall",
  SqrtOverflow = "PRBMathUD60x18__SqrtOverflow",
  SubUnderflow = "PRBMathUD60x18__SubUnderflow",
}
