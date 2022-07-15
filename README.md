# Soulbound Tokens
This is an example implementation of a Soulbound Token (SBT). It draws heavily from ERC721, since SBTs are basically the same as ERC721, except that they can not be transferred away once they are minted.

It includes an optional extension SBTRevokable, which allows the SBT to be revoked by the owner, and potentially be reiussed to a different address.