// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const PrizeClaimContractModule = buildModule("PrizeClaimContractModule", (m) => {

    const contractName = "PrizeClaimContract";

    const PointingContractAddress = m.getParameter("PointingContractAddress", "0xfCc15A48747769b95e6489a05538E1a6aF41Cf7f");
    const prize = 10000000000000n; // 0.00001 ETH

    const PrizeClaimContract = m.contract(contractName, [PointingContractAddress], { value: prize });

    return { PrizeClaimContract };
});

export default PrizeClaimContractModule;


// PrizeClaimContract Contract address - 0xf6d1A2feEAF98c11C7c3F7685D6526Dc539D6072 - Assignment deployment
