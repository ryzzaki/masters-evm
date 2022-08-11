import { ethers, upgrades } from "hardhat";
import type { ContractFactory } from "ethers";
import zeppelin from "../../.openzeppelin/polygon-mumbai.json";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Upgrading BEE with the account: " + deployer.address);
  console.log(ethers.utils.formatUnits(await deployer.getGasPrice(), "gwei"));

  const BEE = await ethers.getContractFactory("BeeToken");
  const bee = await upgrades.upgradeProxy(
    // get the proxy address of BEE at index 0
    zeppelin.proxies[0],
    BEE as ContractFactory
  );
  await bee.deployed();
  console.log(
    "BEE Implementation: ",
    await upgrades.erc1967.getImplementationAddress(bee.address)
  );
  console.log(
    "BEE Admin Address: ",
    await upgrades.erc1967.getAdminAddress(bee.address)
  );
  console.log("BEE deployed to:", bee.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
