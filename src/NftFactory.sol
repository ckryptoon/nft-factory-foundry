// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";
import {Nft} from "./Nft.sol";

/**
 * @title NftFactory
 * @author Casper Kjær Rasmussen / @ckryptoon
 * @notice This is an implementation of a basic NFT factory with a few details of each NFT collection.
 */
contract NftFactory is Ownable2Step {
    error NftFactory__InvalidNameLength();
    error NftFactory__InvalidSymbolLength();

    struct Collection {
        string name;
        string symbol;
        address addr;
    }

    string private _artistName;
    string private _artistSymbol;

    uint256 private _collectionCount;

    mapping(uint256 => Collection) private _collections;

    /**
     * @notice This is the constructor of the basic NFT factory.
     * @param _name The name of the artist of all collections made with this contract.
     * @param _symbol The symbol of the artist of all collections made with this contract.
     */
    constructor(string memory _name, string memory _symbol) Ownable(msg.sender) {
        if (bytes(_name).length == 0) revert NftFactory__InvalidNameLength();
        if (bytes(_symbol).length == 0) revert NftFactory__InvalidSymbolLength();

        _artistName = _name;
        _artistSymbol = _symbol;
    }

    /**
     * @notice This function will create a new NFT collection.
     * @param _name The name of the NFT collection.
     * @param _symbol The symbol of the NFT collection.
     * @return collectionName Returns the full name of the NFT collection.
     * @return collectionSymbol Returns the full symbol of the NFT collection.
     * @return collectionAddress Returns the address of the NFT collection.
     */
    function createCollection(string calldata _name, string calldata _symbol)
        external
        onlyOwner
        returns (string memory collectionName, string memory collectionSymbol, address collectionAddress)
    {
        if (bytes(_name).length == 0) revert NftFactory__InvalidNameLength();
        if (bytes(_symbol).length == 0) revert NftFactory__InvalidSymbolLength();

        collectionName = string(abi.encodePacked(_artistName, _getSeperator(), _name));
        collectionSymbol = string(abi.encodePacked(_artistSymbol, _getSeperator(), _symbol));
        collectionAddress = address(new Nft(collectionName, collectionSymbol));

        _collections[_collectionCount] = Collection(collectionName, collectionSymbol, collectionAddress);

        _collectionCount += 1;
    }

    /**
     * @notice This function will let you mint a new NFT from any NFT collection made by this factory.
     * @param _collectionId The ID of the NFT collection you want to mint an NFT from.
     * @param _account The acccount that'll receive the newly minted NFT.
     * @param _tokenId The token ID of the newly minted NFT.
     * @param _tokenUri The token URI of the newly minted NFT.
     */
    function mint(uint256 _collectionId, address _account, uint256 _tokenId, string calldata _tokenUri)
        external
        onlyOwner
    {
        Nft(_collections[_collectionId].addr).mint(_account, _tokenId, _tokenUri);
    }

    /**
     * @notice This function will change the ownership of any NFT collection made by this factory.
     * @param _collectionId The ID of the NFT collection you want to change ownership of.
     * @param _newOwner The new owner of the NFT collection.
     */
    function transferOwnership(uint256 _collectionId, address _newOwner) external onlyOwner {
        Nft(_collections[_collectionId].addr).transferOwnership(_newOwner);
    }

    /**
     * @notice This function will renounce the ownership of any NFT collection made by this factory.
     * @param _collectionId The ID of the collection you want to renounce the ownership of.
     */
    function renounceOwnership(uint256 _collectionId) external onlyOwner {
        Nft(_collections[_collectionId].addr).renounceOwnership();
    }

    function getArtistName() external view returns (string memory) {
        return _artistName;
    }

    function getArtistSymbol() external view returns (string memory) {
        return _artistSymbol;
    }

    function getCollectionCount() external view returns (uint256) {
        return _collectionCount;
    }

    /**
     * @notice This function will return the details of any NFT collection made by this factory.
     * @param _collectionId The ID of the collection you want to return details about.
     * @return collectionName Returns the full collection name.
     * @return collectionSymbol Returns the full collection symbol.
     * @return collectionAddress Returns the address of the collection.
     */
    function getCollectionById(uint256 _collectionId)
        external
        view
        returns (string memory collectionName, string memory collectionSymbol, address collectionAddress)
    {
        collectionName = _collections[_collectionId].name;
        collectionSymbol = _collections[_collectionId].symbol;
        collectionAddress = _collections[_collectionId].addr;
    }

    /**
     * @dev The seperator between the artist to collection name and the artist to collection symbol.
     */
    function _getSeperator() internal pure returns (string memory) {
        return " | ";
    }
}
