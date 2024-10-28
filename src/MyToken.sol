// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { ERC20 } from "@openzeppelin/token/ERC20/ERC20.sol";
import { Ownable } from "@openzeppelin/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/security/ReentrancyGuard.sol";

contract MyToken is ERC20, Ownable, ReentrancyGuard {
    // 费用比例 (0.1%)
    uint256 public constant FEE_PERCENTAGE = 10; // 0.1% 表示为 10
    mapping(address => bool) public whitelisted;

    // 事件记录
    event TransferWithFee(address indexed from, address indexed to, uint256 amount, uint256 fee);

    constructor(uint256 initialSupply) 
        ERC20("LyyToken", "LYY") 
        Ownable(msg.sender) 
    {
        _mint(msg.sender, initialSupply * 10 ** decimals()); // 铸造初始供应量
    }

    // 设置白名单地址
    function setWhitelist(address user, bool isWhitelisted) external onlyOwner {
        whitelisted[user] = isWhitelisted;
    }

    // 重写转账函数，收取费用
    function transfer(address recipient, uint256 amount) public virtual override nonReentrant returns (bool) {
        uint256 fee = 0;

        if (!whitelisted[msg.sender]) {
            fee = (amount * FEE_PERCENTAGE) / 10000; // 计算费用
        }

        uint256 amountAfterFee = amount - fee;

        // 执行转账
        super.transfer(recipient, amountAfterFee);
        if (fee > 0) {
            super.transfer(owner(), fee); // 将费用转给合约拥有者
        }

        emit TransferWithFee(msg.sender, recipient, amountAfterFee, fee); // 记录事件

        return true;
    }

    // 重写 transferFrom 函数
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override nonReentrant returns (bool) {
        uint256 fee = 0;

        if (!whitelisted[sender]) {
            fee = (amount * FEE_PERCENTAGE) / 10000; // 计算费用
        }

        uint256 amountAfterFee = amount - fee;

        // 执行转账
        super.transferFrom(sender, recipient, amountAfterFee);
        if (fee > 0) {
            super.transferFrom(sender, owner(), fee); // 将费用转给合约拥有者
        }

        emit TransferWithFee(sender, recipient, amountAfterFee, fee); // 记录事件

        return true;
    }
}


// pragma solidity ^0.8.10;

// import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

// contract MyToken is ERC20, Ownable {
//     // 费用比例 (0.1%)
//     uint256 public constant FEE_PERCENTAGE = 10; // 0.1% 表示为 10
//     mapping(address => bool) public whitelisted;

//     constructor(uint256 initialSupply) 
//         ERC20("MyToken", "MTK") 
//         Ownable(msg.sender) 
//     {
//         _mint(msg.sender, initialSupply * 10 ** decimals()); // 铸造初始供应量
//     }

//     // 设置白名单地址
//     function setWhitelist(address user, bool isWhitelisted) external onlyOwner {
//         whitelisted[user] = isWhitelisted;
//     }

//     // 重写转账函数，收取费用
//     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
//         uint256 fee = 0;

//         if (!whitelisted[msg.sender]) {
//             fee = (amount * FEE_PERCENTAGE) / 10000; // 计算费用
//         }

//         uint256 amountAfterFee = amount - fee;

//         // 执行转账
//         super.transfer(recipient, amountAfterFee); 
//         if (fee > 0) {
//             super.transfer(owner(), fee); // 将费用转给合约拥有者
//         }

//         return true;
//     }

//     // 重写 transferFrom 函数
//     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
//         uint256 fee = 0;

//         if (!whitelisted[sender]) {
//             fee = (amount * FEE_PERCENTAGE) / 10000; // 计算费用
//         }

//         uint256 amountAfterFee = amount - fee;

//         // 执行转账
//         super.transferFrom(sender, recipient, amountAfterFee); 
//         if (fee > 0) {
//             super.transferFrom(sender, owner(), fee); // 将费用转给合约拥有者
//         }

//         return true;
//     }
// }
