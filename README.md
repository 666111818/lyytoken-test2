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

forge script script/DeployMyToken.s.sol:DeployMyToken --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### verify

```shell
forge verify-contract --chain-id 421614 --constructor-args $(cast abi-encode "constructor(uint256)" 1000000) --compiler-version 0.8.10 0x0c0076feA3c20bA7954F2e6e30D6749F23fdc9cD MyToken --etherscan-api-key "4A23BIE7RMBWV361YASYRWVEJNZXCSR243"
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
