// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
//0xd8b77e5b
interface ISBTReceiver {
    function onSBTReceived(
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}