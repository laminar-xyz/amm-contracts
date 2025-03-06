// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

import './pool/ILaminarV3PoolImmutables.sol';
import './pool/ILaminarV3PoolState.sol';
import './pool/ILaminarV3PoolDerivedState.sol';
import './pool/ILaminarV3PoolActions.sol';
import './pool/ILaminarV3PoolOwnerActions.sol';
import './pool/ILaminarV3PoolEvents.sol';

/// @title The interface for a Laminar V3 Pool
/// @notice A Laminar pool facilitates swapping and automated market making between any two assets that strictly conform
/// to the ERC20 specification
/// @dev The pool interface is broken up into many smaller pieces
interface ILaminarV3Pool is
    ILaminarV3PoolImmutables,
    ILaminarV3PoolState,
    ILaminarV3PoolDerivedState,
    ILaminarV3PoolActions,
    ILaminarV3PoolOwnerActions,
    ILaminarV3PoolEvents
{

}
