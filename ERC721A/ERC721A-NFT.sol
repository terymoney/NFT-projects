// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/IERC721R.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; // Import ReentrancyGuard
import "@openzeppelin/contracts/utils/Address.sol"; // To use Address.sendValue

contract MyToken is ERC721A, Ownable, ReentrancyGuard {
    uint256 public constant mintPrice = 1 ether;
    uint256 public constant maxMintedPerUser = 2;
    uint256 public constant maxMintSupply = 100;
    uint256 public constant refundPeriod = 2 minutes;

    address public refundAddress;

    mapping(uint256 => uint256) public refundEndTimeStamps; // Maps refund end time for each token
    mapping(uint256 => bool) public hasRefunded; // Tracks refunded tokens

    constructor(address initialOwner)
        ERC721A("MyToken", "MTK")
        Ownable(initialOwner)
    {
        refundAddress = address(this); // Contract address for storing refunded tokens
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://baseURI/"; // Replace with actual IPFS URI
    }

    // Mint tokens
    function safeMint(uint256 quantity) public payable nonReentrant {
        require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");
        require(msg.value == quantity * mintPrice, "NOT ENOUGH FUNDS");
        require(_numberMinted(msg.sender) + quantity <= maxMintedPerUser, "EXCEEDED MINT LIMIT");

        uint256 refundDeadline = block.timestamp + refundPeriod;

        _safeMint(msg.sender, quantity);
        
        // Set refund end timestamps for each minted token
        for (uint256 i = _currentIndex - quantity; i < _currentIndex; i++) {
            refundEndTimeStamps[i] = refundDeadline;
        }
    }

    // Refund functionality
    function refund(uint256 tokenId) external nonReentrant {
        require(block.timestamp < getRefundDeadline(tokenId), "REFUND PERIOD EXPIRED");
        require(msg.sender == ownerOf(tokenId), "NOT YOUR NFT");

        uint256 refundAmount = getRefundAmount(tokenId);

        // Transfer ownership of the NFT to the contract for storage
        _transfer(msg.sender, refundAddress, tokenId);

        // Mark the token as refunded
        hasRefunded[tokenId] = true;

        // Refund the mint price to the user
        Address.sendValue(payable(msg.sender), refundAmount);
    }

    // Returns the refund deadline for a specific token
    function getRefundDeadline(uint256 tokenId) public view returns (uint256) {
        if (hasRefunded[tokenId]) {
            return 0; // If refunded, return 0
        }
        return refundEndTimeStamps[tokenId]; // Return refund end timestamp
    }

    // Returns the refund amount for a specific token
    function getRefundAmount(uint256 tokenId) public view returns (uint256) {
        if (hasRefunded[tokenId]) {
            return 0; // If refunded, return 0
        }
        return mintPrice; // Otherwise, return mint price
    }

    // Withdraw contract balance by the owner after all refund periods have passed
    function withdraw() external onlyOwner nonReentrant {
        // Ensure no tokens are within their refund period before withdrawing
        for (uint256 i = 1; i < _currentIndex; i++) {
            require(block.timestamp > refundEndTimeStamps[i], "REFUND PERIOD NOT YET OVER FOR ALL TOKENS");
        }
        
        uint256 balance = address(this).balance;
        Address.sendValue(payable(msg.sender), balance);
    }
}
