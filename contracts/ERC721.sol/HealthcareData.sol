// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HealthcareData is ERC721, Ownable {
    // Mapping to store authorized addresses
    mapping(address => bool) private _authorizedAddresses;

    constructor() ERC721("HealthcareData", "HCD") {}

    function mint(address to, uint256 tokenId) external onlyOwner {
        _safeMint(to, tokenId);
        // Additional logic for associating token with IPFS hash
    }

    // Function to add an address to the authorized addresses list
    function addAuthorizedAddress(address authorizedAddress) external onlyOwner {
        _authorizedAddresses[authorizedAddress] = true;
    }

    // Function to remove an address from the authorized addresses list
    function removeAuthorizedAddress(address unauthorizedAddress) external onlyOwner {
        _authorizedAddresses[unauthorizedAddress] = false;
    }

    // Overriding the transferFrom function to enforce authorized transfers
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        require(
            _msgSender() == from || _authorizedAddresses[_msgSender()],
            "HealthcareData: Transfer not authorized"
        );
        super.transferFrom(from, to, tokenId);
    }
}
