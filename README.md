# Basic NFT Factory in Foundry

## Introduction

This repository contains a very simple implementation of a NFT factory with a few details of each NFT collection that's created from it. This is a very simple setup made in Foundry, and it'll be very easy to run the tests on and deploy these contracts, so there's really no need for a longer documentation which is why I've chosen to leave it extremely simple and minimal.

You need to make use of the following code first to load your .env file, which contains a few environment variables you need to update yourself for your specific project!

    source .env

## Testing

This setup does not require you to connect to a node for the Ethereum mainnet, Sepolia testnet or other active networks, except for the local blockchain, which will be run automatically while running the tests. So, in order to run the tests, you simply have to use this command:

    forge test
Run all tests on the local blockchain.

## Deployment

Right here, you're provided with two ways to deploy the NFT factory. The first way is to use a script to deploy it to the Sepolia testnet, where it'll get the private key of the deployer from the .env file. The second way makes use of the create command in Foundry in order to provide better protection for your private key, since this private key will become the owner of the NFT factory contract, that'll be deployed to the Ethereum mainnet. Always remember to protect your private keys!

### Using a Script to Deploy to Sepolia Testnet

    forge script DeployNftFactory.s.sol --rpc-url $SEPOLIA_TESTNET --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast
Broadcast transaction, deploy NftFactory and verify it on Etherscan.

### Using the Create Command to Deploy on Ethereum mainnet

    forge create src/NftFactory.sol:NftFactory --rpc-url $MAINNET_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast --interactive
Broadcast transaction, deploy NftFactory and verify it on Etherscan, while providing better security for your private key.

## Thanks

Thank you for reading this short documentation on simple NFT factories. I hope you may find these contracts and tests useful in the future! :)
