const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy Storage
  const Storage = await ethers.getContractFactory("Storage");
  const storage = await Storage.deploy();
  await storage.waitForDeployment();
  console.log("Storage contract deployed to:", await storage.getAddress());

  // Deploy AccessControl
  const SchoolAccessControl = await ethers.getContractFactory("SchoolAccessControl");
  const accessControl = await SchoolAccessControl.deploy();
  await accessControl.waitForDeployment();
  console.log("SchoolAccessControl contract deployed to:", await accessControl.getAddress());

  // Deploy StudentManager
  const StudentManager = await ethers.getContractFactory("StudentManager");
  const studentManager = await StudentManager.deploy(await storage.getAddress(), await accessControl.getAddress());
  await studentManager.waitForDeployment();
  console.log("StudentManager contract deployed to:", await studentManager.getAddress());

  // Deploy TeacherManager
  const TeacherManager = await ethers.getContractFactory("TeacherManager");
  const teacherManager = await TeacherManager.deploy(await storage.getAddress(), await accessControl.getAddress());
  await teacherManager.waitForDeployment();
  console.log("TeacherManager contract deployed to:", await teacherManager.getAddress());

  // Deploy CourseManager
  const CourseManager = await ethers.getContractFactory("CourseManager");
  const courseManager = await CourseManager.deploy(await storage.getAddress(), await accessControl.getAddress());
  await courseManager.waitForDeployment();
  console.log("CourseManager contract deployed to:", await courseManager.getAddress());

  // Authorize the manager contracts in the Storage contract
  console.log("\nAuthorizing logic contracts in Storage...");
  let tx = await storage.authorizeContract(await studentManager.getAddress());
  await tx.wait();
  console.log("StudentManager authorized.");

  tx = await storage.authorizeContract(await teacherManager.getAddress());
  await tx.wait();
  console.log("TeacherManager authorized.");

  tx = await storage.authorizeContract(await courseManager.getAddress());
  await tx.wait();
  console.log("CourseManager authorized.");

  console.log("\nDeployment and setup complete!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
