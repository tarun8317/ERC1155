require("@nomicfoundation/hardhat-toolbox");
  const process = require("process");

  const INFURA_API_KEY = "INFURA API KEY" ;

  const SEPOLIA_PRIVATE_KEY = "METAMASK WALLET KEY";

  /** @type import('hardhat/config').HardhatUserConfig */
  module.exports = {
    solidity: "0.8.18",
    etherscan: {
      apiKey: {
        sepolia: "ETHERSCAN API KEY",
      }
    },
    networks: {
      sepolia: {

        url: `YOUR SEPOLIA URL`,
        accounts: [SEPOLIA_PRIVATE_KEY]
      },
      
    }
  };
