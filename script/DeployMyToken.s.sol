// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {
        vm.startBroadcast();

        // 部署合约
        MyToken myToken = new MyToken(1000000); 

        // 可以在这里调用合约的方法，如设置白名单
        // myToken.setWhitelist(msg.sender, true);

        vm.stopBroadcast();
    }
}
