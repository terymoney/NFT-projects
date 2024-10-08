NFT Projects
This repository contains three different NFT projects built using Solidity and deployed on the Sepolia test network using Remix IDE. Each project demonstrates the implementation of different ERC standards for NFTs: ERC-721, ERC-1155, and ERC-721A.

Projects Overview
ERC-721: BlackGirl.sol – A standard ERC-721 NFT collection.
ERC-1155: Sneakers(1).sol – A multi-token standard (ERC-1155) used for NFTs and semi-fungible tokens.
ERC-721A: ERC721A-NFT.sol – A more gas-efficient version of ERC-721, designed for batch minting.
Technologies Used
Remix IDE: Used for developing, testing, and deploying the smart contracts.
OpenZeppelin: A library of secure and community-vetted smart contracts used for implementing standard NFT functionality.
Sepolia Test Network: Deployed on Sepolia, an Ethereum testnet, using Alchemy API.
Solidity: The smart contract programming language used for building the NFTs.
1. BlackGirl (ERC-721)
Overview
This project implements a standard ERC-721 NFT collection named BlackGirl using the OpenZeppelin contracts. Each NFT represents a unique digital asset with a single owner.

Features
Minting function to create new NFTs.
Supports transferring ownership of NFTs between accounts.
Metadata associated with each NFT (e.g., image, attributes).
Contract: BlackGirl.sol
The smart contract is based on the ERC-721 standard, with custom functionality for minting and transferring NFTs.

Deployment
Deployed using Remix IDE.
Tested on the Sepolia test network via Remix IDE and Alchemy API.
2. Sneakers (ERC-1155)
Overview
This project demonstrates the implementation of the ERC-1155 multi-token standard for NFTs. Sneakers is a collection of semi-fungible tokens where different sneaker items can be minted as either fungible or non-fungible items. ERC-1155 is efficient for scenarios where multiple types of assets are handled in a single contract.

Features
Supports both fungible and non-fungible tokens.
Batch minting to create multiple tokens in a single transaction.
Transfer function to transfer tokens between wallets.
Contract: Sneakers(1).sol
The smart contract follows the ERC-1155 standard, utilizing OpenZeppelin's implementation to allow creating and managing multiple token types with a single contract.

Deployment
Deployed using Remix IDE.
Tested on the Sepolia test network via Remix IDE and Alchemy API.
3. ERC721A (ERC-721A)
Overview
ERC721A is a more gas-efficient implementation of the ERC-721 standard that reduces the gas cost of minting multiple tokens in a single transaction. The project implements ERC-721A NFTs, which is useful for batch minting, reducing the cost of creating several tokens at once.

Features
Efficient minting of multiple NFTs in a single transaction.
Supports standard ERC-721 functions like transfer, ownerOf, and tokenURI.
Optimized for low gas fees during bulk minting.
Contract: ERC721A-NFT.sol
This contract implements ERC721A, providing an efficient way to mint a collection of NFTs while minimizing gas costs using batch processing techniques.

Deployment
Deployed using Remix IDE.
Tested on the Sepolia test network via Remix IDE and Alchemy API.
Getting Started
Prerequisites
Before setting up the project, ensure you have the following:

Remix IDE: Used for developing, compiling, and deploying the smart contracts.
Alchemy API Key: Used to connect to the Sepolia test network.
A Sepolia testnet wallet with some Sepolia ETH (for transaction costs).
