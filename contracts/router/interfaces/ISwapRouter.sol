// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;
pragma abicoder v2;

import '../../v3/periphery/interfaces/ISelfPermit.sol';

import './IV2SwapRouter.sol';
import './IV3SwapRouter.sol';
import './IApproveAndCall.sol';
import './IMulticallExtended.sol';

/// @title Router token swapping functionality
interface ISwapRouter is IV2SwapRouter, IV3SwapRouter, IApproveAndCall, IMulticallExtended, ISelfPermit {

}
