// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol"; // 导入 Script 库
import "../src/MyToken.sol"; // 调整导入路径以匹配你的 MyToken 合约位置

contract DeployMyToken is Script {
    function run() public {
        // 设置初始供应量
        uint256 initialSupply = 1000000; // 根据需要更改初始供应量

        // 开始广播
        vm.startBroadcast();

        // 部署 MyToken 合约
        MyToken myToken = new MyToken(initialSupply);

        // 停止广播
        vm.stopBroadcast();

        // 可选：打印合约地址
        console.log("MyToken address", address(myToken));
    }
}

// pragma solidity ^0.8.10;

// import "forge-std/Script.sol";
// import "../src/MyToken.sol";

// contract DeployMyToken {
//     MyToken public myToken;

//     function deploy() public {
//         myToken = new MyToken(1000000); 
//         myToken.addToWhitelist(msg.sender); 
//     }
// }
