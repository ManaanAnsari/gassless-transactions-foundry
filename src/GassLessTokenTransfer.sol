// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {IERC20Permit} from "./interfaces/IERC20Permit.sol";

contract GasLessTokenTransfer {
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        // what are we doing here?
        //  we are calling the permit function on the token contract
        // which allows this contract to spend the tokens on behalf of the sender
        // and can be verified by the signature
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);
        // then we transfer the tokens to the receiver
        IERC20Permit(token).transferFrom(sender, receiver, amount);
        // then we transfer the fee to this contract
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
