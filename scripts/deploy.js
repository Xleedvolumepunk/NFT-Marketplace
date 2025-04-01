const hre = require("hardhat");

async function main() {
console.log("Deploy script started...");
const [deployer] = await ethers.getSigners();
console.log("Deployer address:", deployer.address);

const ContractFactory = await ethers.getContractFactory("MyNFT");
console.log("Deploying contract...");

const contract = await ContractFactory.deploy();
await contract.deployed();

console.log("Contract deployed to:", contract.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
