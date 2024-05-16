## Intro

### Theory

#### ERC2771

- A user (sender) signs a request with their private key and sends it to a relayer
- The relayer wraps the request into a tx and sends it to a contract
- The contract unwraps the tx and executes it

following relayers or spin up a custom solution:

- [Biconomy](https://docs.biconomy.io/quickstart)
- [Gelato](https://docs.gelato.network/developer-products/gelato-relay-sdk)

#### ERC20Permit

Gassless ERC20 token transfer

## Todos

- [x] ERC20 permit
- [ ] Gelato ERC2771

## Usage

Build

```shell
$ forge build
```

Test

```shell
$ forge test
```
