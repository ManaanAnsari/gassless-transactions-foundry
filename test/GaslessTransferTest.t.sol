// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {IERC20Permit} from "../src/interfaces/IERC20Permit.sol";
import {ERC20Permit} from "../src/ERC20Permit.sol";
import {GasLessTokenTransfer} from "./../src/GassLessTokenTransfer.sol";

contract TestGasLessTransfer is Test {
    ERC20Permit token;
    GasLessTokenTransfer gasless;
    uint256 SENDER_PRIV_KEY = 123;
    address sender;
    address receiver;
    uint256 amount = 1000e18;
    uint256 fee = 100e18;

    function setUp() external {
        sender = vm.addr(SENDER_PRIV_KEY);
        receiver = makeAddr("receiver");
        token = new ERC20Permit("Test", "TST", 18);
        token.mint(sender, 10000e18);
        gasless = new GasLessTokenTransfer();
    }

    function testGasless() external {
        // prepare permit message
        bytes32 permitHash =
            _getPermitHash(sender, address(gasless), amount + fee, token.nonces(sender), block.timestamp + 60);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SENDER_PRIV_KEY, permitHash);

        // execute send
        gasless.send(address(token), sender, receiver, amount, fee, block.timestamp + 60, v, r, s);
        //  check token balance
        assertEq(token.balanceOf(sender), 8900e18);
        assertEq(token.balanceOf(receiver), 1000e18);
        // assertEq(token.balanceOf(address(gasless)), 100e18);
    }

    function _getPermitHash(address owner, address spender, uint256 value, uint256 nonces, uint256 deadline)
        internal
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                token.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                        owner,
                        spender,
                        value,
                        nonces,
                        deadline
                    )
                )
            )
        );
    }
}
