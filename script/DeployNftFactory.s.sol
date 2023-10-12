// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Script} from "@forge/Script.sol";
import {NftFactory} from "../src/NftFactory.sol";

contract DeployNftFactory is Script {
    NftFactory public nftFactory;

    string public constant NAME = "Name";
    string public constant SYMBOL = "SYMBOL";

    uint256 public deployerKey = vm.envUint("DEPLOYER_KEY");

    function run() external returns (NftFactory) {
        vm.startBroadcast(deployerKey);
        nftFactory = new NftFactory(NAME, SYMBOL);
        vm.stopBroadcast();
        
        return nftFactory;
    }
}
