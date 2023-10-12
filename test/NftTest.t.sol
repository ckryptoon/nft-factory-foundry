// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Test} from "@forge/Test.sol";
import {Nft} from "../src/Nft.sol";

contract NftTest is Test {
    Nft public nft;

    string public constant NAME = "Test";
    string public constant SYMBOL = "TEST";

    uint256 public constant TOKEN_ID = 0;
    string public constant VALID_TOKEN_URI = "QmRTV3h1jLcACW4FRfdisokkQAk4E4qDhUzGpgdrd4JAFy";

    address public recipient = address(this);

    function setUp() external {
        nft = new Nft(NAME, SYMBOL);
    }

    ////////////////////////////////////////////////////////////////
    // constructor                                                //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfNameLengthIsZero() public {
        string memory name = "";
        vm.expectRevert(Nft.Nft__InvalidNameLength.selector);
        nft = new Nft(name, SYMBOL);
    }

    function test_RevertIfSymbolLengthIsZero() public {
        string memory symbol = "";
        vm.expectRevert(Nft.Nft__InvalidSymbolLength.selector);
        nft = new Nft(NAME, symbol);
    }

    ////////////////////////////////////////////////////////////////
    // mint                                                       //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfTokenUriLengthIsNotFourtySix() public {
        string memory invalidTokenUri = "";
        vm.expectRevert(Nft.Nft__InvalidTokenUriLength.selector);
        nft.mint(recipient, TOKEN_ID, invalidTokenUri);
    }

    function test_RevertIfTokenUriHasBeenUsed() public {
        uint256 nextTokenId = TOKEN_ID + 1;
        nft.mint(recipient, TOKEN_ID, VALID_TOKEN_URI);
        vm.expectRevert(Nft.Nft__TokenUriHasBeenUsed.selector);
        nft.mint(recipient, nextTokenId, VALID_TOKEN_URI);
    }

    function test_MintNftSuccessfully() public {
        uint256 balance = 1;
        string memory baseUri = "ipfs://";
        string memory fullTokenUri = string(abi.encodePacked(baseUri, VALID_TOKEN_URI));

        nft.mint(recipient, TOKEN_ID, VALID_TOKEN_URI);

        assertEq(nft.balanceOf(recipient), balance, "nft.balanceOf(recipient) == balance");
        assertEq(nft.ownerOf(TOKEN_ID), recipient, "nft.ownerOf(TOKEN_ID) == recipient");
        assertEq(nft.tokenURI(TOKEN_ID), fullTokenUri, "nft.tokenURI(TOKEN_ID) == fullTokenUri");
    }
}
