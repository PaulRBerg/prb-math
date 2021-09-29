/* eslint-disable @typescript-eslint/no-non-null-assertion */
import type { BigNumber as EthersBigNumber } from "@ethersproject/bignumber";
import { Decimal } from "decimal.js";
import { fromBn, toBn } from "evm-bn";
import { HardhatPluginError } from "hardhat/plugins";
import type { BigNumber as MathjsBigNumber } from "mathjs";
import {
  addDependencies,
  bignumberDependencies,
  ceilDependencies,
  create,
  expDependencies,
  floorDependencies,
  log10Dependencies,
  log2Dependencies,
  logDependencies,
  meanDependencies,
  modDependencies,
  powDependencies,
  sqrtDependencies,
} from "mathjs";

import { DECIMALS, PLUGIN_NAME, SCALE } from "./constants";

const math = create(
  {
    addDependencies,
    bignumberDependencies,
    ceilDependencies,
    expDependencies,
    floorDependencies,
    logDependencies,
    log10Dependencies,
    log2Dependencies,
    meanDependencies,
    modDependencies,
    powDependencies,
    sqrtDependencies,
  },
  {
    number: "BigNumber",
    precision: 78,
  },
);

function toEbn(x: MathjsBigNumber): EthersBigNumber {
  const fixed = x.toFixed(Number(DECIMALS), Decimal.ROUND_DOWN);
  return toBn(fixed);
}

function toMbn(x: EthersBigNumber): MathjsBigNumber {
  return math.bignumber!(fromBn(x));
}
export class HardhatPRBMath {
  public avg(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
    const result = math.mean!(toMbn(x), toMbn(y)) as MathjsBigNumber;
    return toEbn(result);
  }

  public ceil(x: EthersBigNumber): EthersBigNumber {
    const result: MathjsBigNumber = toMbn(x).ceil();
    return toEbn(result);
  }

  public div(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
    if (y.isZero()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot divide by zero");
    }
    const result: MathjsBigNumber = toMbn(x).div(toMbn(y));
    return toEbn(result);
  }

  public exp(x: EthersBigNumber): EthersBigNumber {
    const result: MathjsBigNumber = toMbn(x).exp();
    return toEbn(result);
  }

  public exp2(x: EthersBigNumber): EthersBigNumber {
    const two: MathjsBigNumber = math.bignumber!("2");
    const result = <MathjsBigNumber>math.pow!(two, toMbn(x));
    return toEbn(result);
  }

  public floor(x: EthersBigNumber): EthersBigNumber {
    const result: MathjsBigNumber = toMbn(x).floor();
    return toEbn(result);
  }

  public frac(x: EthersBigNumber): EthersBigNumber {
    return this.solidityMod(x, SCALE);
  }

  public gm(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
    const xy: MathjsBigNumber = toMbn(x).mul(toMbn(y));
    if (xy.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "PRBMath cannot calculate the geometric mean of a negative number");
    }
    const result = math.sqrt!(xy) as MathjsBigNumber;
    return toEbn(result);
  }

  public inv(x: EthersBigNumber): EthersBigNumber {
    if (x.isZero()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the inverse of zero");
    }
    const one: MathjsBigNumber = math.bignumber!("1");
    const result: MathjsBigNumber = one.div(toMbn(x));
    return toEbn(result);
  }

  public ln(x: EthersBigNumber): EthersBigNumber {
    if (x.isZero()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the natural logarithm of zero");
    } else if (x.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the natural logarithm of a negative number");
    }
    const result = math.log!(toMbn(x)) as MathjsBigNumber;
    return toEbn(result);
  }

  public log10(x: EthersBigNumber): EthersBigNumber {
    if (x.isZero()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the common logarithm of zero");
    } else if (x.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the common logarithm of a negative number");
    }
    const result = math.log10!(toMbn(x)) as MathjsBigNumber;
    return toEbn(result);
  }

  public log2(x: EthersBigNumber): EthersBigNumber {
    if (x.isZero()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the binary logarithm of zero");
    } else if (x.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the binary logarithm of a negative number");
    }
    const result = math.log2!(toMbn(x)) as MathjsBigNumber;
    return toEbn(result);
  }

  public mul(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
    const result: MathjsBigNumber = toMbn(x).mul(toMbn(y));
    return toEbn(result);
  }

  public pow(x: EthersBigNumber, y: EthersBigNumber): EthersBigNumber {
    if (x.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "PRBMath cannot raise a negative base to a power");
    }
    const result = math.pow!(toMbn(x), toMbn(y)) as MathjsBigNumber;
    return toEbn(result);
  }

  public sqrt(x: EthersBigNumber): EthersBigNumber {
    if (x.isNegative()) {
      throw new HardhatPluginError(PLUGIN_NAME, "Cannot calculate the square root of a negative number");
    }
    const result = math.sqrt!(toMbn(x)) as MathjsBigNumber;
    return toEbn(result);
  }

  protected solidityMod(x: EthersBigNumber, m: EthersBigNumber): EthersBigNumber {
    const m_mbn: MathjsBigNumber = toMbn(m);
    let remainder: MathjsBigNumber = toMbn(x).mod(m_mbn);
    if (x.isNegative() && !remainder.isZero()) {
      remainder = remainder.sub(m_mbn);
    }
    return toEbn(remainder);
  }
}
