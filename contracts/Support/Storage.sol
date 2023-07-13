// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Storage {

    mapping(uint256 => address) internal _owners;
  

    /// @dev Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    /// @dev Mapping from token ID to approved address
    mapping(uint256 => address) internal _tokenApprovals;
}


// pragma solidity >=0.7.0 <0.9.0;

// /**
//  * @title Storage
//  * @dev Store & retrieve value in a variable
//  * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
//  */
// contract Storage {

//     uint256 number;

//     /**
//      * @dev Store value in variable
//      * @param num value to store
//      */
//     function store(uint256 num) public {
//         number = num;
//     }

//     /**
//      * @dev Return value 
//      * @return value of 'number'
//      */
//     function retrieve() public view returns (uint256){
//         return number;
//     }
// }