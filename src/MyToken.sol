// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    // 费用比例 (0.1%)
    uint256 public constant FEE_PERCENTAGE = 10; // 0.1% 表示为 10
    mapping(address => bool) public whitelisted;

    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply * 10 ** decimals()); // 铸造初始供应量
    }

    // 设置白名单地址
    function setWhitelist(address user, bool isWhitelisted) external onlyOwner {
        whitelisted[user] = isWhitelisted;
    }

    // 重写转账函数，收取费用
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 fee = 0;

        if (!whitelisted[sender]) {
            fee = (amount * FEE_PERCENTAGE) / 10000; // 计算费用
        }

        uint256 amountAfterFee = amount - fee;

        super._transfer(sender, recipient, amountAfterFee); // 执行转账
        if (fee > 0) {
            super._transfer(sender, owner(), fee); // 将费用转给合约拥有者
        }
    }
}
