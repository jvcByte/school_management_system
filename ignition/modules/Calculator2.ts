// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Calculator2Module = buildModule("Calculator2Module", (m) => {

    const contractName = "Calculator2";
    const calculator1Address = m.getParameter("Calculator1Address", "0x596207C818de30eCEDFd6572744B376608357BB9");

    const Calculator2 = m.contract(contractName, [calculator1Address]);

    return { Calculator2 };
});

export default Calculator2Module;
