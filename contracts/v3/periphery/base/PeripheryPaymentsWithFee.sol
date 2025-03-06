// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../../core/libraries/LowGasSafeMath.sol';

import './PeripheryPayments.sol';
import '../interfaces/IPeripheryPaymentsWithFee.sol';

import '../interfaces/external/IWHYPE.sol';
import '../libraries/PeripheryTransferHelper.sol';

abstract contract PeripheryPaymentsWithFee is PeripheryPayments, IPeripheryPaymentsWithFee {
    using LowGasSafeMath for uint256;

    /// @inheritdoc IPeripheryPaymentsWithFee
    function unwrapWHYPEWithFee(
        uint256 amountMinimum,
        address recipient,
        uint256 feeBips,
        address feeRecipient
    ) public payable override {
        require(feeBips > 0 && feeBips <= 100);

        uint256 balanceWHYPE = IWHYPE(WHYPE).balanceOf(address(this));
        require(balanceWHYPE >= amountMinimum, 'Insufficient WHYPE');

        if (balanceWHYPE > 0) {
            IWHYPE(WHYPE).withdraw(balanceWHYPE);
            uint256 feeAmount = balanceWHYPE.mul(feeBips) / 10_000;
            if (feeAmount > 0) PeripheryTransferHelper.safeTransferHYPE(feeRecipient, feeAmount);
            PeripheryTransferHelper.safeTransferHYPE(recipient, balanceWHYPE - feeAmount);
        }
    }

    /// @inheritdoc IPeripheryPaymentsWithFee
    function sweepTokenWithFee(
        address token,
        uint256 amountMinimum,
        address recipient,
        uint256 feeBips,
        address feeRecipient
    ) public payable override {
        require(feeBips > 0 && feeBips <= 100);

        uint256 balanceToken = IERC20(token).balanceOf(address(this));
        require(balanceToken >= amountMinimum, 'Insufficient token');

        if (balanceToken > 0) {
            uint256 feeAmount = balanceToken.mul(feeBips) / 10_000;
            if (feeAmount > 0) PeripheryTransferHelper.safeTransfer(token, feeRecipient, feeAmount);
            PeripheryTransferHelper.safeTransfer(token, recipient, balanceToken - feeAmount);
        }
    }
}
