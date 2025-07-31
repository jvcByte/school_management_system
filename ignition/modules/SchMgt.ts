// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const SchMgtModule = buildModule("SchMgtModule", (m) => {

  const contractName = "SchMgt";
  const principalAddress = m.getParameter("Principal", "0x2CE7756B09e0BE1306aC18d0968D36F259c76447");
  
  const SchoolManagement = m.contract(contractName, [principalAddress]);

  return { SchoolManagement };
});

export default SchMgtModule;
