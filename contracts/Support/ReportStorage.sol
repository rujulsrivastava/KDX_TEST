// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Model.sol";


contract ReportStorage {

    /// @dev Owner is the contract address that created the smart contract
    address payable owner;
    /// @dev
    uint256 public listingfee = 0.002 ether;
    /// @dev The fee charged by the marketplace to be allowed to list an NFT
    uint256 listPrice = 0.002 ether;
    /// @dev This mapping mas tokenId to the NFT info and is helpful when retrieving details about a tokenId
    mapping(uint256 => Model.HealthItem) internal idToListedToken;
    
}