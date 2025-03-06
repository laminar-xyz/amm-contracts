// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;

import '../../v3/periphery/base/PeripheryPayments.sol';
import '../../v3/periphery/libraries/PeripheryTransferHelper.sol';

import '../interfaces/IPeripheryPaymentsExtended.sol';

abstract contract PeripheryPaymentsExtended is IPeripheryPaymentsExtended, PeripheryPayments {
    /// @inheritdoc IPeripheryPaymentsExtended
    function unwrapWHYPE(uint256 amountMinimum) external payable override {
        unwrapWHYPE(amountMinimum, msg.sender);
    }

    /// @inheritdoc IPeripheryPaymentsExtended
    function wrapHYPE(uint256 value) external payable override {
        IWHYPE(WHYPE).deposit{value: value}();
    }

    /// @inheritdoc IPeripheryPaymentsExtended
    function sweepToken(address token, uint256 amountMinimum) external payable override {
        sweepToken(token, amountMinimum, msg.sender);
    }

    /// @inheritdoc IPeripheryPaymentsExtended
    function pull(address token, uint256 value) external payable override {
        PeripheryTransferHelper.safeTransferFrom(token, msg.sender, address(this), value);
    }
}
