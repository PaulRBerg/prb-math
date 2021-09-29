// We load the plugin here.
import "../../../src";

import { HardhatUserConfig } from "hardhat/types";

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: "0.8.7",
};

export default config;
