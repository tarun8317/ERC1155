// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Web3 is ERC1155, Ownable, Pausable, ERC1155Supply, PaymentSplitter {
    uint256 public publicPrice = 0.02 ether;
    uint public allowListPrice = 0.01 ether;
    uint256 public maxSupply = 20;
    uint public maxPerWallet = 3;

    bool public publicMintOpen = false;
    bool public allowListMintOpen = true;

    mapping(address => bool) allowList;
    mapping(address => uint256) purchasesPerWallet;

    constructor(
        address[] memory _payees,
        uint256[] memory _shares
    )
        ERC1155("ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/")
        PaymentSplitter(_payees, _shares)
    {}

    //create an edit function
   function editMintWindows(
    bool _publicMintOpen,
    bool _allowListMintOpen
    ) external onlyOwner {
    publicMintOpen = _publicMintOpen;
    allowListMintOpen = _allowListMintOpen;
    }

    //create a function to set the allow list 
    function setAllowList(address[] calldata addresses) external onlyOwner {
        for(uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]] = true;
        }
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function allowListMint(uint256 id, uint256 amount) public payable {
        require(allowListMintOpen,"allow list mint closed");
        require(allowList[msg.sender],"you are not on the allow list");
        require(msg.value == allowListPrice * amount);
        mint(id, amount);
    }


    // add supply tracking 
    function publicMint(uint256 id, uint256 amount)
        public
        payable 
    {
        require(publicMintOpen,"public list mint closed");
        require(id < 2, " sorry you are trying to mint the wrong nft");
        require(msg.value == publicPrice * amount, " Wrong! not enough money sent");
        mint(id, amount);
    }

    function mint(uint256 id, uint256 amount) internal {
        require(purchasesPerWallet[msg.sender] + amount <=maxPerWallet, "wallet limit reached");
        require(id < 2, " sorry you are trying to mint the wrong nft");
        require(totalSupply(id) + amount <= maxSupply, " sorry we have minted out");
        _mint(msg.sender, id, amount, "");
        purchasesPerWallet[msg.sender] += amount;
    }

    function withdraw(address _addr) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }
    
    function uri(uint256 id) public view virtual override  returns (string memory) {
        require(exists(id), "URI: non existent token");

        return string(abi.encodePacked(super.uri(id), Strings.toString(id), ".json"));
    }    

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}