
// pragma solidity ^0.8.10;

// import "forge-std/Test.sol";
// import "../src/MyToken.sol"; 


// // 重入攻击合约
// contract ReentrancyAttack {
//     IMyToken public targetToken;
//     address public user;

//     constructor(address _targetToken) {
//         targetToken = IMyToken(_targetToken);
//     }

//     // 攻击入口函数
//     function attack(address _user, uint256 amount) external {
//         user = _user;
//         // 向目标合约发起转账
//         targetToken.transfer(address(this), amount);
//     }

//     // 回调函数，利用重入漏洞
//      receive() external payable {
//         if (user != address(0)) {
//             // 重入攻击，转账给用户
//             targetToken.transfer(user, 100 ether); // 继续转账
//         }
//     }
// }

// // 测试合约
// contract MyTokenTest is Test {
//     MyToken private token;
//     address private owner;
//     address private user1;
//     address private user2;
//     address private attacker;

//     function setUp() public {
//         owner = address(this);
//         user1 = address(0x1);
//         user2 = address(0x2);
//         attacker = address(0x3);
        
//         // 部署合约并铸造1000个代币
//         token = new MyToken(1000);
//     }

//     // 测试重入攻击
//     function testReentrancyAttack() public {
//         // 安排
//         token.setWhitelist(attacker, true);
        
//         // 创建重入攻击合约
//         ReentrancyAttack attackContract = new ReentrancyAttack(address(token));
//         token.transfer(attacker, 100 ether); // 给攻击者转账
        
//         // 执行攻击
//         vm.startPrank(attacker);
//         attackContract.attack(user1, 100 ether);
//         vm.stopPrank();
        
//         // 断言
//         assertEq(token.balanceOf(attacker), 100 ether, "The attacker should not obtain the token");
//         assertEq(token.balanceOf(user1), 0, "User1 should not receive tokens");
//     }

//     // 测试非白名单用户的转账（收取手续费）
//     function testTransferNonWhitelisted() public {
//         uint256 initialBalanceUser1 = token.balanceOf(user1);
//         uint256 transferAmount = 100 ether;
        
//         token.transfer(user1, transferAmount);
        
//         // 执行转账
//         token.transfer(user2, transferAmount);
        
//         // 断言
//         assertEq(token.balanceOf(user2), transferAmount - (transferAmount * token.FEE_PERCENTAGE() / 100), "User2 shall receive the correct amount after the handling fee");
//         assertEq(token.balanceOf(owner), transferAmount * token.FEE_PERCENTAGE() / 100, "The contract owner shall receive a commission");
//     }

//     // 测试白名单用户的转账（不收取手续费）
//     function testTransferWhitelisted() public {
//         token.setWhitelist(user1, true);
//         uint256 transferAmount = 100 ether;
        
//         token.transfer(user1, transferAmount);
        
//         // 执行转账
//         token.transfer(user2, transferAmount);
        
//         // 断言
//         assertEq(token.balanceOf(user2), transferAmount, "User2 should receive the full transfer amount");
//         assertEq(token.balanceOf(owner), 0, "The contract owner shall not receive a commission");
//     }

//     // 测试添加和移除白名单用户
//     function testWhitelistManagement() public {
//         // 添加用户到白名单
//         token.setWhitelist(user1, true);
//         assert(token.whitelisted(user1), "User1 should be in the whitelist");
        
//         // 移除用户出白名单
//         token.setWhitelist(user1, false);
//         assert(!token.whitelisted(user1), "User1 should not be in the whitelist");
//     }
// }





// // pragma solidity ^0.8.10;

// // import "forge-std/Test.sol";
// // import "../src/MyToken.sol";

// // contract MyTokenTest is Test {
// //     MyToken public token;
// //     address owner = address(0x1);
// //     address user1 = address(0x2);
// //     address user2 = address(0x3);

// //     uint256 initialSupply = 1000 ether; // 初始供应量为1000个代币，使用ether单位模拟decimals()

// //     function setUp() public {
// //         vm.prank(owner); // 设置owner为消息发送者
// //         token = new MyToken(initialSupply);

// //         // 分配一些初始代币
// //         vm.prank(owner);
// //         token.transfer(user1, 100 ether);
// //     }

// //     // function testReentrancyProtection() public {
// //     //     // 使用 owner 进行测试，防止 Ownable 权限问题
// //     //     vm.startPrank(owner);
// //     //     token.setWhitelist(user1, false); // 确保 user1 不在白名单
// //     //     vm.stopPrank();

// //     //     // 启动 user1 的 prank，测试重入保护
// //     //     vm.startPrank(user1);
// //     //     vm.expectRevert("ReentrancyGuard: reentrant call");
// //     //     token.transfer(user2, 1 ether);
// //     //     vm.stopPrank();
// //     // }

// //     function testTransferWithinWhitelist() public {
// //         // 白名单内转账测试（无手续费）
// //         vm.prank(owner);
// //         token.setWhitelist(user1, true);

// //         uint256 balanceBefore = token.balanceOf(user2);
// //         vm.prank(user1);
// //         token.transfer(user2, 10 ether);

// //         uint256 balanceAfter = token.balanceOf(user2);
// //         assertEq(balanceAfter, balanceBefore + 10 ether, "Transfers for whitelisted users should be free of handling charges");
// //     }

// //     function testTransferOutsideWhitelistWithFee() public {
// //         // 非白名单内转账测试（收取手续费）
// //         vm.prank(owner);
// //         token.setWhitelist(user1, false);

// //         uint256 balanceBefore = token.balanceOf(user2);
// //         uint256 feeExpected = (10 ether * token.FEE_PERCENTAGE()) / 10000;

// //         vm.prank(user1);
// //         token.transfer(user2, 10 ether);

// //         uint256 balanceAfter = token.balanceOf(user2);
// //         assertEq(balanceAfter, balanceBefore + (10 ether - feeExpected), "Transfers from non-whitelisted users are subject to a handling fee");
// //     }

// //     function testAddToWhitelist() public {
// //         // 添加到白名单测试
// //         vm.prank(owner);
// //         token.setWhitelist(user1, true);
// //         assertTrue(token.whitelisted(user1), "Users should be whitelisted");
// //     }

// //     function testRemoveFromWhitelist() public {
// //         // 移除白名单测试
// //         vm.prank(owner);
// //         token.setWhitelist(user1, true);
// //         assertTrue(token.whitelisted(user1), "The user should be in the whitelist");

// //         vm.prank(owner);
// //         token.setWhitelist(user1, false);
// //         assertFalse(token.whitelisted(user1), "The user should be removed from the whitelist");
// //     }
// // }



// // pragma solidity ^0.8.10;

// // import "forge-std/Test.sol";
// // import "../src/MyToken.sol";

// // contract MyTokenTest is Test {
// //     MyToken public token;
// //     address public owner = address(1);
// //     address public recipient = address(2);
// //     uint256 public initialSupply = 1000 * 1e18; // 使用较小的初始供应量进行测试

// //     function setUp() public {
// //         vm.prank(owner);
// //         token = new MyToken(initialSupply);
// //     }

// //     function testTransfer() public {
// //         uint256 transferAmount = 100 * 1e18;

// //         // 获取初始余额
// //         uint256 ownerInitialBalance = token.balanceOf(owner);
// //         uint256 recipientInitialBalance = token.balanceOf(recipient);

// //         // 模拟 owner 地址的转账行为
// //         vm.prank(owner);
// //         token.transfer(recipient, transferAmount);

// //         // 使用 token.FEE_PERCENTAGE() 获取费率
// //         uint256 fee = (transferAmount * token.FEE_PERCENTAGE()) / 10000;
// //         uint256 amountAfterFee = transferAmount - fee;

// //         // 验证 recipient 的余额增加
// //         assertEq(token.balanceOf(recipient), recipientInitialBalance + amountAfterFee);

// //         // 验证 owner 的余额变化
// //         assertEq(token.balanceOf(owner), ownerInitialBalance - transferAmount + fee);
// //     }
// // }
