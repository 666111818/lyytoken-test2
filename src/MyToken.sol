// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol"; 

contract MyToken is ERC20, Ownable, ReentrancyGuard { 
    uint256 public feePercent = 1; 
    mapping(address => bool) public whitelisted;

    event TransferWithFee(
        address indexed from,
        address indexed to,
        uint256 value,
        uint256 feeAmount
    );

    constructor(uint256 initialSupply)  
        ERC20("LyyToken", "LYY")  
        Ownable(msg.sender)  
    { 
        _mint(msg.sender, initialSupply * 10 ** decimals()); 
    } 

    function _update(address from, address to, uint256 value) internal override nonReentrant { 
        uint256 fee = 0;

        if (!whitelisted[from]) {
            fee = (value * feePercent) / 1000; 
        }

        uint256 amountAfterFee = value - fee;

        if (from == address(0)) {
            super._update(from, to, value); 
        } else {
            uint256 fromBalance = balanceOf(from);
            require(fromBalance >= value, "ERC20: insufficient balance");

            super._update(from, to, amountAfterFee); 

            if (fee > 0) {
                super._update(from, address(this), fee); 
            }
        }

        emit TransferWithFee(from, to, amountAfterFee, fee);
    }

    function addToWhitelist(address account) external onlyOwner {
        whitelisted[account] = true;
    }

    function removeFromWhitelist(address account) external onlyOwner {
        whitelisted[account] = false;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount); 
    }
}

