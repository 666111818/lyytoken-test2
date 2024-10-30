// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {
        vm.startBroadcast();

        MyToken myToken = new MyToken(1000000); 

        
        myToken.setWhitelist(msg.sender, true);

        vm.stopBroadcast();
    }
}
