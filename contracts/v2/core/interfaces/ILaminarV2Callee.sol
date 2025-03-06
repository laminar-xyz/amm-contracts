// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.0;

interface ILaminarV2Callee {
    function laminarV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
