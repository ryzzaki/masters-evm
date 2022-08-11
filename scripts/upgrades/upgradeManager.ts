import { ethers, upgrades } from "hardhat";
import type { ContractFactory } from "ethers";
import zeppelin from "../../.openzeppelin/polygon-mumbai.json";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Upgrading MANAGER with the account: " + deployer.address);
  console.log(ethers.utils.formatUnits(await deployer.getGasPrice(), "gwei"));

  const MANAGER = await ethers.getContractFactory("HiveManager");
  const manager = await upgrades.upgradeProxy(
    // get the proxy address of MANAGER at index 2
    zeppelin.proxies[2],
    MANAGER as ContractFactory
  );
  await manager.deployed();
  console.log(
    "MANAGER Implementation: ",
    await upgrades.erc1967.getImplementationAddress(manager.address)
  );
  console.log(
    "MANAGER Admin Address: ",
    await upgrades.erc1967.getAdminAddress(manager.address)
  );
  console.log("MANAGER deployed to:", manager.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
