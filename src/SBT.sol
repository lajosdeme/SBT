// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/ISBTReceiver.sol";
import "./interfaces/ISBT.sol";
import "./extensions/ISBTMetadata.sol";
import "./utils/Address.sol";
import "./utils/Context.sol";
import "./utils/Strings.sol";
import "./ERC165.sol";

contract SBT is ERC165, ISBT, ISBTMetadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC165, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(ISBT).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {ISBT-balanceOf}.
     */
    function balanceOf(address owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(owner != address(0), "SBT: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {ISBT-ownerOf}.
     */
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(owner != address(0), "SBT: invalid token ID");
        return owner;
    }

    /**
     * @dev See {ISBTMetadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {ISBTMetadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {ISBTMetadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "SBT: Token has not been minted yet");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnSBTReceived(to, tokenId, data),
            "SBT: Mint to non SBTReceiver implementer"
        );
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "SBT: mint to the zero address");
        require(!_exists(tokenId), "SBT: token already minted");

        _beforeMint(to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Mint(to, tokenId);

        _afterMint(to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = SBT.ownerOf(tokenId);

        _beforeBurn(owner, tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Burn(owner, tokenId);

        _afterBurn(owner, tokenId);
    }

    function _checkOnSBTReceived(
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                ISBTReceiver(to).onSBTReceived(address(this), tokenId, data)
            returns (bytes4 retval) {
                return retval == ISBTReceiver.onSBTReceived.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("SBT: Mint to non SBTReceiver implementer.");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function _beforeMint(address to, uint256 tokenId) internal virtual {}

    function _afterMint(address to, uint256 tokenId) internal virtual {}

    function _beforeBurn(address from, uint256 tokenId) internal virtual {}

    function _afterBurn(address from, uint256 tokenId) internal virtual {}
}
