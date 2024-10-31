// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "forge-std/console.sol"; // Make sure this is correct

contract RandomTransfers is Script {
    address[5] accounts = [
        0xe82d3B9473F0A06D6715581C336E18E949030da1,
        0x3a27719ef5f46c917680eb59cCD744aaa0998Bd8,
        0x09c3B4Cd85a4D9A490c0fd6a8976D2d4e83E165b,
        0xF4e9e57b57D5D58834164A01a1FbD36A68daC47E,
        0xdaC88f55d8BD5C041a02a281F4ca2F3F1cb4A0f3
    ];

    uint256[5] privateKeys = [
        0xa7e342d09b2e973379a98f263fb5dab475b6d0f4829cc8f3561f7040364b67e1,
        0x66caabea841797ccd23d0ee8165d5493e4df475d127935b23e2fc6983111f3a9,
        0x39beb1d48b44c28bd9eb4b4a4d4c3a9f1bfc772ca5d247f9f11d4fc58b3f58bf,
        0x29c1c3e90c60bd956f62d478946ef4f2e88fe1ef713fc957524a5959f8361d0b,
        0xbd2116a40dff8c49ee99b3be14f78ee0f534c7f2507d9dd54cc66addd048cce3
    ];

    function run() external {
        MyToken myToken = MyToken(0xA08F0aAfB517ed5A01831A6Ded8fb89f28519C2a); 

        for (uint i = 0; i < accounts.length; i++) {
            vm.startBroadcast(privateKeys[i]);

            uint256 amount = (uint256(keccak256(abi.encodePacked(block.timestamp, accounts[i], i))) % 10) + 1;
            uint256 amountInTokens = amount * 10 ** 18;

            uint256 fee = (amountInTokens * myToken.feePercent()) / 1000; 
            uint256 amountAfterFee = amountInTokens - fee;

            address recipient = i < accounts.length - 1 ? accounts[i + 1] : accounts[0];
            myToken.transfer(recipient, amountAfterFee);

            // Make sure to use correct log format
            // console.log("Transferred %s tokens from %s to %s (fee: %s)", amount, accounts[i], recipient, fee);

            vm.stopBroadcast();
        }
    }
}


// pragma solidity ^0.8.10;

// import "forge-std/Script.sol";
// import "../src/MyToken.sol";
// import "forge-std/console.sol";

// contract RandomTransfers is Script {
//     // 5个账户地址
//     address[5] accounts = [
//         0xe82d3B9473F0A06D6715581C336E18E949030da1,
//         0x3a27719ef5f46c917680eb59cCD744aaa0998Bd8,
//         0x09c3B4Cd85a4D9A490c0fd6a8976D2d4e83E165b,
//         0xF4e9e57b57D5D58834164A01a1FbD36A68daC47E,
//         0xdaC88f55d8BD5C041a02a281F4ca2F3F1cb4A0f3
//     ];

//     // 5个账户私钥
//     uint256[5] privateKeys = [
//         0xa7e342d09b2e973379a98f263fb5dab475b6d0f4829cc8f3561f7040364b67e1,
//         0x66caabea841797ccd23d0ee8165d5493e4df475d127935b23e2fc6983111f3a9,
//         0x39beb1d48b44c28bd9eb4b4a4d4c3a9f1bfc772ca5d247f9f11d4fc58b3f58bf,
//         0x29c1c3e90c60bd956f62d478946ef4f2e88fe1ef713fc957524a5959f8361d0b,
//         0xbd2116a40dff8c49ee99b3be14f78ee0f534c7f2507d9dd54cc66addd048cce3
//     ];

//     function run() external {
//         // 获取MyToken合约的实例
//         MyToken myToken = MyToken(0x95254258a6A50B5c8Bb971A990de15C583A59007); 

//         // 随机转账
//         for (uint i = 0; i < accounts.length; i++) {
//             // 使用每个账户的私钥来广播交易
//             vm.startBroadcast(privateKeys[i]);

//             // 生成随机转账金额（1到10个LYY之间）
//             uint256 amount = (uint256(keccak256(abi.encodePacked(block.timestamp, accounts[i], i))) % 10) + 1;
//             uint256 amountInTokens = amount * 10 ** 18;

//             // 从当前账户转账到下一个账户
//             address recipient = i < accounts.length - 1 ? accounts[i + 1] : accounts[0];
//             myToken.transfer(recipient, amountInTokens);
//             console.log("Transferred %s tokens from %s to %s", amount, accounts[i], recipient);

//             // 停止当前账户的广播
//             vm.stopBroadcast();
//         }
//     }
// }
