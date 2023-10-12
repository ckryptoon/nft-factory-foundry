// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title Nft
 * @author Casper Kjær Rasmussen / @ckryptoon
 * @notice This is a simple implementation of a mintable NFT collection.
 */
contract Nft is ERC721URIStorage, Ownable {
    error Nft__InvalidNameLength();
    error Nft__InvalidSymbolLength();
    error Nft__InvalidTokenUriLength();
    error Nft__TokenUriHasBeenUsed();

    mapping(bytes32 => bool) private _isTokenUriInUse;

    /**
     * @notice The constructor for a basic NFT collection.
     * @param _name The name of the NFT collection.
     * @param _symbol The symbol of the NFT collection.
     */
    constructor(string memory _name, string memory _symbol) Ownable(msg.sender) ERC721(_name, _symbol) {
        if (bytes(_name).length == 0) revert Nft__InvalidNameLength();
        if (bytes(_symbol).length == 0) revert Nft__InvalidSymbolLength();
    }

    /**
     * @notice This function will mint a new NFT to the account that's been provided.
     * @param _account The accounts that'll receive the newly minted NFT.
     * @param _tokenId The token ID of the newly minted NFT.
     * @param _tokenUri The token URI of the newly minted NFT.
     */
    function mint(address _account, uint256 _tokenId, string calldata _tokenUri) external onlyOwner {
        if (bytes(_tokenUri).length != 46) revert Nft__InvalidTokenUriLength();

        bytes32 tokenUriHash = keccak256(abi.encode(_tokenUri));
        if (_isTokenUriInUse[tokenUriHash]) revert Nft__TokenUriHasBeenUsed();

        _mint(_account, _tokenId);
        _setTokenURI(_tokenId, _tokenUri);
        _isTokenUriInUse[tokenUriHash] = true;
    }

    /**
     * @dev The base URI serves as a prefix to the token URI provided in the mint function.
     */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
}
