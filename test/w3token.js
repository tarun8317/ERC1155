const { expect } = require("chai");

describe("Web3 1155 Token", function () {
  let Web3Token;
  let web3Token;
  let owner;
  let user;
  let provider; // Add a provider variable

  // Define the provider URL for your Ethereum network (e.g., Hardhat Network)

  const providerUrl = "http://127.0.0.1:8545/"; // Update with your network URL

  before(async function () {
    // Create a new provider
    provider = new ethers.JsonRpcProvider(providerUrl);

    // Get signers using the provider
    [owner, user] = await ethers.getSigners();

    // Deploy the contract using the provider
    Web3Token = await ethers.getContractFactory("Web3");
    web3Token = await Web3Token.connect(owner).deploy();
    await web3Token.deployed();
  });

  it("should deploy the token", async function () {
    expect(web3Token.address).to.not.be.undefined;
  });

  it("should have the correct name and symbol", async function () {
    expect(await web3Token.name()).to.equal("Web3");
    expect(await web3Token.symbol()).to.equal("WE3");
  });
});