// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC165.sol";

//interface id: 0x3a84c458
interface ISBT is IERC165 {

    event Mint(address indexed to, uint256 indexed tokenId);

    event Burn(address indexed from, uint256 indexed tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);
}