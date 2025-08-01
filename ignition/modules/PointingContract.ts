// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const PointingContractModule = buildModule("PointingContractModule", (m) => {

    const contractName = "PointingContract";

    const PointingContract = m.contract(contractName, []);

    return { PointingContract };
});

export default PointingContractModule;

// PointingContract Contract address - 0x1A1dea93ADC440Cf5B73199690af6ff3d5Ec023E - first deployment

// PointingContract Contract address - 0xfCc15A48747769b95e6489a05538E1a6aF41Cf7f - Assignment deployment
