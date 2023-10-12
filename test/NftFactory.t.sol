// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Test} from "@forge/Test.sol";
import {IERC721} from "@openzeppelin/token/ERC721/IERC721.sol";
import {IERC721Metadata} from "@openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {NftFactory} from "../src/NftFactory.sol";

contract NftFactoryTest is Test {
    NftFactory public nftFactory;

    string public constant ARTIST_NAME = "Artist";
    string public constant ARTIST_SYMBOL = "ARTIST";

    string public constant COLLECTION_NAME = "Test";
    string public constant COLLECTION_SYMBOL = "TEST";

    uint256 public constant COLLECTION_ID = 0;

    string public constant SEPERATOR = " | ";

    string public collectionName;
    string public collectionSymbol;

    function setUp() external {
        nftFactory = new NftFactory(ARTIST_NAME, ARTIST_SYMBOL);
        collectionName = string(abi.encodePacked(ARTIST_NAME, SEPERATOR, COLLECTION_NAME));
        collectionSymbol = string(abi.encodePacked(ARTIST_SYMBOL, SEPERATOR, COLLECTION_SYMBOL));
    }

    modifier createCollection() {
        nftFactory.createCollection(COLLECTION_NAME, COLLECTION_SYMBOL);
        _;
    }

    ////////////////////////////////////////////////////////////////
    // constructor                                                //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfArtistNameLengthIsZero() public {
        string memory invalidArtistName = "";
        vm.expectRevert(NftFactory.NftFactory__InvalidNameLength.selector);
        nftFactory = new NftFactory(invalidArtistName, ARTIST_SYMBOL);
    }

    function test_RevertIfArtistSymbolLengthIsZero() public {
        string memory invalidArtistSymbol = "";
        vm.expectRevert(NftFactory.NftFactory__InvalidSymbolLength.selector);
        nftFactory = new NftFactory(ARTIST_NAME, invalidArtistSymbol);
    }

    ////////////////////////////////////////////////////////////////
    // createCollection                                           //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfCollectionNameLengthIsZero() public {
        string memory invalidCollectionName = "";
        vm.expectRevert(NftFactory.NftFactory__InvalidNameLength.selector);
        nftFactory.createCollection(invalidCollectionName, COLLECTION_SYMBOL);
    }

    function test_RevertIfCollectionSymbolLengthIsZero() public {
        string memory invalidCollectionSymbol = "";
        vm.expectRevert(NftFactory.NftFactory__InvalidSymbolLength.selector);
        nftFactory.createCollection(COLLECTION_NAME, invalidCollectionSymbol);
    }

    function test_CreateCollectionSuccessfully() public createCollection {
        (string memory name, string memory symbol,) = nftFactory.getCollectionById(COLLECTION_ID);
        assertEq(name, collectionName, "name == collectionName");
        assertEq(symbol, collectionSymbol, "symbol == collectionSymbol");
    }

    ////////////////////////////////////////////////////////////////
    // mint                                                       //
    ////////////////////////////////////////////////////////////////

    function test_MintNftSuccessfully() public {
        address recipient = address(this);
        uint256 tokenId = 0;
        string memory baseUri = "ipfs://";
        string memory tokenUri = "QmRTV3h1jLcACW4FRfdisokkQAk4E4qDhUzGpgdrd4JAFy";
        string memory fullTokenUri = string(abi.encodePacked(baseUri, tokenUri));

        (string memory name, string memory symbol, address nft) =
            nftFactory.createCollection(COLLECTION_NAME, COLLECTION_SYMBOL);
        nftFactory.mint(COLLECTION_ID, recipient, tokenId, tokenUri);

        assertEq(IERC721Metadata(nft).name(), name, "nft.name() == name");
        assertEq(IERC721Metadata(nft).symbol(), symbol, "nft.symbol() == symbol");
        assertEq(IERC721Metadata(nft).tokenURI(tokenId), fullTokenUri, "nft.tokenURI() == fullTokenUri");
        assertEq(IERC721(nft).ownerOf(tokenId), recipient, "nft.ownerOf(tokenId) == recipient");
    }

    ////////////////////////////////////////////////////////////////
    // transferOwnership                                          //
    ////////////////////////////////////////////////////////////////

    function test_TransferOwnershipSuccessfully() public {
        address newOwner = address(1);
        (,, address nft) = nftFactory.createCollection(COLLECTION_NAME, COLLECTION_SYMBOL);
        nftFactory.transferOwnership(COLLECTION_ID, newOwner);
        assertEq(Ownable(nft).owner(), newOwner);
    }

    ////////////////////////////////////////////////////////////////
    // renounceOwnership                                          //
    ////////////////////////////////////////////////////////////////

    function test_RenounceOwnershipSuccessfully() public {
        address zeroAddress = address(0);
        (,, address nft) = nftFactory.createCollection(COLLECTION_NAME, COLLECTION_SYMBOL);
        nftFactory.renounceOwnership(COLLECTION_ID);
        assertEq(Ownable(nft).owner(), zeroAddress);
    }

    ////////////////////////////////////////////////////////////////
    // getArtistName                                              //
    ////////////////////////////////////////////////////////////////

    function test_GetCorrectArtistName() public {
        string memory name = nftFactory.getArtistName();
        assertEq(name, ARTIST_NAME);
    }

    ////////////////////////////////////////////////////////////////
    // getArtistSymbol                                            //
    ////////////////////////////////////////////////////////////////

    function test_GetCorrectArtistSymbol() public {
        string memory symbol = nftFactory.getArtistSymbol();
        assertEq(symbol, ARTIST_SYMBOL);
    }

    ////////////////////////////////////////////////////////////////
    // getCollectionCount                                         //
    ////////////////////////////////////////////////////////////////

    function test_GetCorrectCollectionCount() public {
        uint256 count = 1;
        nftFactory.createCollection(COLLECTION_NAME, COLLECTION_SYMBOL);
        uint256 collectionCount = nftFactory.getCollectionCount();
        assertEq(collectionCount, count);
    }

    ////////////////////////////////////////////////////////////////
    // getCollectionById                                          //
    ////////////////////////////////////////////////////////////////

    function test_GetCorrectCollectionById() public createCollection {
        (string memory name, string memory symbol,) = nftFactory.getCollectionById(COLLECTION_ID);
        assertEq(name, collectionName, "name == collectionName");
        assertEq(symbol, collectionSymbol, "symbol == collectionSymbol");
    }
}
