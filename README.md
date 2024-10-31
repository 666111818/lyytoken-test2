## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
fore clean
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>

export PRIVATE_KEY="a7e342d09b2e973379a98f263fb5dab475b6d0f4829cc8f3561f7040364b67e1"
export RPC_URL="https://arbitrum-sepolia.infura.io/v3/3a0a73ce30784f22a21efd1ad6070c5b"

forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```
### 
```shell
1、安装 Cast 工具（如果尚未安装）：
forge install foundry-rs/forge-std --no-commit
2、使用 Cast 编码参数：
cast abi-encode "constructor(uint256)" 1000000
3、编码参数：
ABI_ARGS=$(cast abi-encode "constructor(uint256)" 1000000)
4、

```

### verify

```shell
forge verify-contract 0xA08F0aAfB517ed5A01831A6Ded8fb89f28519C2a src/MyToken.sol:MyToken --constructor-args $ABI_ARGS --chain arbitrum-sepolia --api-key 4A23BIE7RMBWV361YASYRWVEJNZXCSR243


RandomTransfers
forge script script/RandomTransfers.s.sol:RandomTransfers --rpc-url https://arbitrum-sepolia.infura.io/v3/3a0a73ce30784f22a21efd1ad6070c5b --broadcast
```





### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
