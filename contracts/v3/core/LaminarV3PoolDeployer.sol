// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import './interfaces/ILaminarV3PoolDeployer.sol';

import './LaminarV3Pool.sol';

contract LaminarV3PoolDeployer is ILaminarV3PoolDeployer {
    struct Parameters {
        address factory;
        address token0;
        address token1;
        uint24 fee;
        int24 tickSpacing;
        uint8 feeProtocol0;
        uint8 feeProtocol1;
    }

    /// @inheritdoc ILaminarV3PoolDeployer
    Parameters public override parameters;

    /// @dev Deploys a pool with the given parameters by transiently setting the parameters storage slot and then
    /// clearing it after deploying the pool.
    /// @param factory The contract address of the Laminar V3 factory
    /// @param token0 The first token of the pool by address sort order
    /// @param token1 The second token of the pool by address sort order
    /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
    /// @param tickSpacing The spacing between usable ticks
    /// @param feeProtocol0 The initial protocol fee for token0
    /// @param feeProtocol1 The initial protocol fee for token1
    function deploy(
        address factory,
        address token0,
        address token1,
        uint24 fee,
        int24 tickSpacing,
        uint8 feeProtocol0,
        uint8 feeProtocol1
    ) internal returns (address pool) {
        parameters = Parameters({factory: factory, token0: token0, token1: token1, fee: fee, tickSpacing: tickSpacing, feeProtocol0: feeProtocol0, feeProtocol1: feeProtocol1});
        pool = address(new LaminarV3Pool{salt: keccak256(abi.encode(token0, token1, fee))}());
        delete parameters;
    }
}
