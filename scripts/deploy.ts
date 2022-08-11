/* eslint-disable node/no-unpublished-import */
import { ContractFactory } from "ethers";
import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account: " + deployer.address);
  console.log(ethers.utils.formatUnits(await deployer.getGasPrice(), "gwei"));

  // deploy BEE
  const BEE = await ethers.getContractFactory("BeeToken");
  const bee = await upgrades.deployProxy(BEE as ContractFactory, undefined, {
    initializer: "initialize",
  });
  await bee.deployed();
  console.log("BEE deployed to:", bee.address);
  console.log(
    "BEE Implementation Contract: ",
    await upgrades.erc1967.getImplementationAddress(bee.address)
  );

  // deploy HIVE
  const HIVE = await ethers.getContractFactory("HiveToken");
  const hive = await upgrades.deployProxy(HIVE as ContractFactory, undefined, {
    initializer: "initialize",
  });
  await hive.deployed();
  console.log("HIVE deployed to:", hive.address);
  console.log(
    "HIVE Implementation Contract: ",
    await upgrades.erc1967.getImplementationAddress(hive.address)
  );

  // deploy MANAGER
  const MANAGER = await ethers.getContractFactory("HiveManager");
  const manager = await upgrades.deployProxy(
    MANAGER as ContractFactory,
    [bee.address, hive.address],
    {
      initializer: "initialize",
    }
  );
  await manager.deployed();
  console.log("MANAGER deployed to:", manager.address);
  console.log(
    "MANAGER Implementation Contract: ",
    await upgrades.erc1967.getImplementationAddress(manager.address)
  );

  const beeTx = await bee.setManager(manager.address);
  await beeTx.wait();
  console.log("BEE manager set!");

  const hiveTx = await hive.setManager(manager.address);
  await hiveTx.wait();
  console.log("HIVE manager set!");

  // proxy admin should be the same for all 3 contracts
  console.log(
    "ProxyAdmin Contract: ",
    await upgrades.erc1967.getAdminAddress(bee.address)
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
