const { ethers } = require('hardhat');

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying Web3 ERC1155 contract with the account:", deployer.address);
  const address1 = "0x65786a5DD8267dDD6B718E3323Bb64927De44443";
  const address2 = "0xb2fF9A0B84b6FDE6333bB2282B3c88f242a9689a";
  // Define the payees and shares arrays as needed
  const payees = [address1, address2]; // Replace with actual addresses
  const shares = [50, 50]; // Replace with corresponding shares

  // Replace with the actual URI you want to use
  const uri = "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";

  const Web3Token = await ethers.getContractFactory("Web3");
  
  // Pass the payees and shares arrays as constructor arguments
  const web3Token = await Web3Token.deploy(payees, shares);

  console.log("Web3 Token address:", web3Token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
