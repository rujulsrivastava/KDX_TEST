// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Metadata {
    mapping(uint256 => string) private _tokenURIs;

    function setTokenURI(uint256 tokenId, string memory tokenURI) external {
        _tokenURIs[tokenId] = tokenURI;
    }

    function getTokenURI(uint256 tokenId) external view returns (string memory) {
        return _tokenURIs[tokenId];
    }
}
