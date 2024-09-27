// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

contract Sneakers is ERC1155, Ownable, ERC1155Pausable, ERC1155Supply, PaymentSplitter {
    uint256 public publicPrice = 0.0002 ether;
    uint256 public AllowListPrice = 0.0001 ether;
    uint256 public maxSupply = 100;
    uint256 public maxPerWallet = 1;

    bool public AllowListOpen = false;
    bool public PublicMintOpen = false;

    mapping(address => bool) allowList;
    mapping(address => uint) walletMints;

    constructor(
        address initialOwner,
        address[] memory _payees,
        uint256[] memory _shares
    )
        ERC1155("ipfs:/QmXVVLyCWNcdikZcEuroYTkXGZw3XiXtsStcqLCuueY7pY") //QmXVVLyCWNcdikZcEuroYTkXGZw3XiXtsStcqLCuueY7pY
        Ownable(initialOwner)
        PaymentSplitter(_payees, _shares)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function AllowListmint( uint256 id, uint256 amount)
        public
        payable 
    {
           require(allowList[msg.sender], "NOT ON THE ALLOW LIST");
           require(AllowListOpen, "ALLOW LIST IS NOT OPEN");
           require(msg.value == amount * AllowListPrice, "NOT ENOUGH FUNDS");
           internalFunction(id, amount);
    }

    //require payment
    function publicMint(uint256 id, uint amount)
        public
        payable 
    {
           require(PublicMintOpen, " PUBLIC LIST NOT OPENED"); 
           require(msg.value == amount * publicPrice, "NOT ENOUGH FUNDS");
           internalFunction(id, amount);
           
           
    }

    function internalFunction(uint256 id, uint256 amount) internal{
           require(id < 2, "TOKEN ID DOESNT EXIST");
           require(walletMints[msg.sender] + amount <= maxPerWallet, "EXCEEDED MAX PER WALLET");
           require(totalSupply(id) + amount <= maxSupply, "MINTED OUT");
           walletMints[msg.sender] += amount;
           _mint(msg.sender, id, amount, "");
    }

    function editWindow(
        bool _AllowListOpen,
        bool _PublicMintOpen) 
        external onlyOwner {
          AllowListOpen = _AllowListOpen;
          PublicMintOpen = _PublicMintOpen; 
        }
    function setAllowList(address[] calldata addresses) external onlyOwner{
        for(uint256 i = 0; i < addresses.length; i++){
            allowList[addresses[i]] = true;
        }
    }


    /*function withdraw(address _addr) external onlyOwner{
        uint256 balance = address(this).balance; //get balance of the smart contract
        payable(_addr).transfer(balance);
    }*/

    function uri(uint256  _id) public view virtual override returns (string memory) {
        require(exists(_id), "TOKEN'S URI DOESN'T EXIST");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
