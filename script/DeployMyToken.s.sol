// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol"; 
import "../src/MyToken.sol"; 

contract DeployMyToken is Script {
    function run() public {
        
        uint256 initialSupply = 1000000;

        vm.startBroadcast();

        MyToken myToken = new MyToken(initialSupply);

        vm.stopBroadcast();

        console.log("MyToken address", address(myToken));
    }
}


