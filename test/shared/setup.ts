import chai from "chai";
import { solidity } from "ethereum-waffle";

import { near } from "./assertions";

chai.use(near);
chai.use(solidity);
