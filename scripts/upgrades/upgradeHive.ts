import { ethers, upgrades } from "hardhat";
import type { ContractFactory } from "ethers";
import zeppelin from "../../.openzeppelin/polygon-mumbai.json";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Upgrading HIVE with the account: " + deployer.address);
  console.log(ethers.utils.formatUnits(await deployer.getGasPrice(), "gwei"));

  const HIVE = await ethers.getContractFactory("HiveToken");
  const hive = await upgrades.upgradeProxy(
    // get the proxy address of HIVE at index 1
    zeppelin.proxies[1],
    HIVE as ContractFactory
  );
  await hive.deployed();
  console.log(
    "HIVE Implementation: ",
    await upgrades.erc1967.getImplementationAddress(hive.address)
  );
  console.log(
    "HIVE Admin Address: ",
    await upgrades.erc1967.getAdminAddress(hive.address)
  );
  console.log("HIVE deployed to:", hive.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
