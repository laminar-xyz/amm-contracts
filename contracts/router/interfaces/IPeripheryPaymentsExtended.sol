// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;

import '../../v3/periphery/interfaces/IPeripheryPayments.sol';

/// @title Periphery Payments Extended
/// @notice Functions to ease deposits and withdrawals of HYPE and tokens
interface IPeripheryPaymentsExtended is IPeripheryPayments {
    /// @notice Unwraps the contract's WHYPE balance and sends it to msg.sender as HYPE.
    /// @dev The amountMinimum parameter prevents malicious contracts from stealing WHYPE from users.
    /// @param amountMinimum The minimum amount of WHYPE to unwrap
    function unwrapWHYPE(uint256 amountMinimum) external payable;

    /// @notice Wraps the contract's HYPE balance into WHYPE
    /// @dev The resulting WHYPE is custodied by the router, thus will require further distribution
    /// @param value The amount of HYPE to wrap
    function wrapHYPE(uint256 value) external payable;

    /// @notice Transfers the full amount of a token held by this contract to msg.sender
    /// @dev The amountMinimum parameter prevents malicious contracts from stealing the token from users
    /// @param token The contract address of the token which will be transferred to msg.sender
    /// @param amountMinimum The minimum amount of token required for a transfer
    function sweepToken(address token, uint256 amountMinimum) external payable;

    /// @notice Transfers the specified amount of a token from the msg.sender to address(this)
    /// @param token The token to pull
    /// @param value The amount to pay
    function pull(address token, uint256 value) external payable;
}
