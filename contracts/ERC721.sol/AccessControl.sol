// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    mapping(uint256 => address) private _tokenOwners;

    function transferTokenOwnership(uint256 tokenId, address to) external {
        _tokenOwners[tokenId] = to;
    }

    function getTokenOwner(uint256 tokenId) external view returns (address) {
        return _tokenOwners[tokenId];
    }
}
