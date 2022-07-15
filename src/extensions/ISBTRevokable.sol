// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/ISBT.sol";

interface ISBTRevokeable is ISBT {
    event Revoked(address indexed from, address indexed reissueTo, uint256 indexed tokenId);
}