// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.10; 
 
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol"; 
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol"; 
 
contract MyToken is ERC20, Ownable { 
    uint256 public constant FEE_PERCENTAGE = 1; 
    mapping(address => bool) public whitelisted; 
    bool private locked; 

    
    event TransferWithFee(address indexed from, address indexed to, uint256 amount, uint256 fee, uint256 timestamp); 
    event WhitelistUpdated(address indexed user, bool isWhitelisted); 
 
    constructor(uint256 initialSupply)  
          ERC20("LyyToken", "LYY")  
          Ownable(msg.sender)  
      { 
          _mint(msg.sender, initialSupply * 10 ** decimals()); 
          locked = false; 
      } 
 
    function setWhitelist(address user, bool isWhitelisted) external onlyOwner { 
        whitelisted[user] = isWhitelisted; 
        emit WhitelistUpdated(user, isWhitelisted); 
    } 
 
    modifier nonReentrant() { 
        require(!locked, "ReentrancyGuard: reentrant call"); 
        locked = true; 
        _; 
        locked = false; 
    } 
 
    function _calculateFee(uint256 amount) private pure returns (uint256) { 
        return (amount * FEE_PERCENTAGE) / 100; 
    } 
 
    function transfer(address recipient, uint256 amount) public virtual override nonReentrant returns (bool) { 
        uint256 fee = whitelisted[msg.sender] ? 0 : _calculateFee(amount); 
        require(amount > fee, "Transfer amount must be greater than fee"); 
        require(balanceOf(msg.sender) >= amount, "Insufficient balance for transfer"); 

        uint256 amountAfterFee = amount - fee; 
        super.transfer(recipient, amountAfterFee); 
 
        if (fee > 0) { 
            super.transfer(owner(), fee); 
        } 

        
        emit TransferWithFee(msg.sender, recipient, amountAfterFee, fee, block.timestamp); 
        return true; 
    } 
 
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override nonReentrant returns (bool) { 
        uint256 fee = whitelisted[sender] ? 0 : _calculateFee(amount); 
        require(amount > fee, "Transfer amount must be greater than fee"); 
        require(balanceOf(sender) >= amount, "Insufficient balance for transfer"); 

        uint256 amountAfterFee = amount - fee; 
        super.transferFrom(sender, recipient, amountAfterFee); 
 
        if (fee > 0) { 
            super.transferFrom(sender, owner(), fee); 
        } 

        
        emit TransferWithFee(sender, recipient, amountAfterFee, fee, block.timestamp); 
        return true; 
    } 
}


