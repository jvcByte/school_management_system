// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Calculator1Module = buildModule("Calculator1Module", (m) => {

    const contractName = "Calculator1";

    const Calculator1 = m.contract(contractName, []);

    return { Calculator1 };
});

export default Calculator1Module;
