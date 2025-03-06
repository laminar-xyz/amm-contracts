// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import '../interfaces/IPeripheryPayments.sol';
import '../interfaces/external/IWHYPE.sol';

import '../libraries/PeripheryTransferHelper.sol';

import './PeripheryImmutableState.sol';

abstract contract PeripheryPayments is IPeripheryPayments, PeripheryImmutableState {
    receive() external payable {
        require(msg.sender == WHYPE, 'Not WHYPE');
    }

    /// @inheritdoc IPeripheryPayments
    function unwrapWHYPE(uint256 amountMinimum, address recipient) public payable override {
        uint256 balanceWHYPE = IWHYPE(WHYPE).balanceOf(address(this));
        require(balanceWHYPE >= amountMinimum, 'Insufficient WHYPE');

        if (balanceWHYPE > 0) {
            IWHYPE(WHYPE).withdraw(balanceWHYPE);
            PeripheryTransferHelper.safeTransferHYPE(recipient, balanceWHYPE);
        }
    }

    /// @inheritdoc IPeripheryPayments
    function sweepToken(
        address token,
        uint256 amountMinimum,
        address recipient
    ) public payable override {
        uint256 balanceToken = IERC20(token).balanceOf(address(this));
        require(balanceToken >= amountMinimum, 'Insufficient token');

        if (balanceToken > 0) {
            PeripheryTransferHelper.safeTransfer(token, recipient, balanceToken);
        }
    }

    /// @inheritdoc IPeripheryPayments
    function refundHYPE() external payable override {
        if (address(this).balance > 0) PeripheryTransferHelper.safeTransferHYPE(msg.sender, address(this).balance);
    }

    /// @param token The token to pay
    /// @param payer The entity that must pay
    /// @param recipient The entity that will receive payment
    /// @param value The amount to pay
    function pay(
        address token,
        address payer,
        address recipient,
        uint256 value
    ) internal {
        if (token == WHYPE && address(this).balance >= value) {
            // pay with WHYPE
            IWHYPE(WHYPE).deposit{value: value}(); // wrap only what is needed to pay
            IWHYPE(WHYPE).transfer(recipient, value);
        } else if (payer == address(this)) {
            // pay with tokens already in the contract (for the exact input multihop case)
            PeripheryTransferHelper.safeTransfer(token, recipient, value);
        } else {
            // pull payment
            PeripheryTransferHelper.safeTransferFrom(token, payer, recipient, value);
        }
    }
}
