// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../SBT.sol";
import "./ISBTRevokable.sol";

abstract contract SBTRevokeable is SBT, ISBTRevokeable {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, SBT) returns (bool) {
        return interfaceId == type(ISBTRevokeable).interfaceId || super.supportsInterface(interfaceId);
    }

    function _revoke(address reissueTo, uint256 tokenId) internal {
        address from = ownerOf(tokenId);
        _burn(tokenId);
        if (reissueTo != address(0)) {
            _safeMint(reissueTo, tokenId);   
        }
        emit Revoked(from, reissueTo, tokenId);
    }
}