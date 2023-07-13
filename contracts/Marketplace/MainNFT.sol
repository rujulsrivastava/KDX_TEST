// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MainNFT is ERC721, Ownable {
    using SafeMath for uint256;

    struct TokenData {
        string ipfsHash;
        uint256 timestamp;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => TokenData) private _tokenData;
    mapping(address => bool) private _authorizedAddresses;

    IERC20 private _paymentToken;
    uint256 private _listingFee;

    event TokenListed(uint256 indexed tokenId, uint256 price);
    event TokenSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    constructor(address paymentTokenAddress) ERC721("MainNFT", "MFT") {
        _paymentToken = IERC20(paymentTokenAddress);
        _listingFee = 0.001 ether;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "MainNFT: Only token owner can perform this action");
        _;
    }

    modifier onlyAuthorized() {
        require(_authorizedAddresses[msg.sender], "MainNFT: Not authorized to perform this action");
        _;
    }

    function addAuthorizedAddress(address authorizedAddress) external onlyOwner {
        _authorizedAddresses[authorizedAddress] = true;
    }

    function removeAuthorizedAddress(address unauthorizedAddress) external onlyOwner {
        _authorizedAddresses[unauthorizedAddress] = false;
    }

    function mint(
        address to,
        uint256 tokenId,
        string memory ipfsHash
    ) external onlyAuthorized {
        _safeMint(to, tokenId);
        _setTokenData(tokenId, ipfsHash, block.timestamp, 0, false);
    }

    function getTokenData(uint256 tokenId)
        external
        view
        returns (
            string memory,
            uint256,
            uint256,
            bool
        )
    {
        TokenData memory data = _tokenData[tokenId];
        return (data.ipfsHash, data.timestamp, data.price, data.isListed);
    }

    function listToken(uint256 tokenId, uint256 price) external onlyTokenOwner(tokenId) {
        require(price > 0, "MainNFT: Price must be greater than zero");

        TokenData storage token = _tokenData[tokenId];
        require(!token.isListed, "MainNFT: Token already listed");

        token.price = price;
        token.isListed = true;

        emit TokenListed(tokenId, price);
    }

    function buyToken(uint256 tokenId) external {
        TokenData storage token = _tokenData[tokenId];
        require(token.isListed, "MainNFT: Token is not listed");

        uint256 saleAmount = token.price;

        _paymentToken.transferFrom(msg.sender, owner(), saleAmount);

        address tokenOwner = ownerOf(tokenId);
        require(tokenOwner != address(0), "MainNFT: Invalid token owner");

        _transfer(tokenOwner, msg.sender, tokenId);
        token.isListed = false;

        emit TokenSold(tokenId, msg.sender, tokenOwner, saleAmount);
    }

    function setPaymentToken(address paymentTokenAddress) external onlyOwner {
        _paymentToken = IERC20(paymentTokenAddress);
    }

    function setListingFee(uint256 listingFee) external onlyOwner {
        _listingFee = listingFee;
    }

    function _setTokenData(
        uint256 tokenId,
        string memory ipfsHash,
        uint256 timestamp,
        uint256 price,
        bool isListed
    ) internal {
        _tokenData[tokenId] = TokenData(ipfsHash, timestamp, price, isListed);
    }
}




// pragma solidity ^0.8.9;

// // OpenZeppelin modules
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
// import "ErrorHandling.sol";
// import "Storage.sol";


// contract NFT is ERC1155,
//     NFTStorage
//     {

//     /// @dev Id for NFTs using Counters
//     using CountersUpgradeable for CountersUpgradeable.Counter;
//     CountersUpgradeable.Counter internal tokenIds;
//     address contractAddress;

//   constructor() ERC1155("ipfs://QmeRChz9s7H9fPTK1CAu3ETJpg8tFHKdKMbfPcfaVRpGRa/1.json") {
//         contractAddress = 0x601aAF38C9D3EC1d4b378d0E527D2a538a4D9Dff;
//     }

//     function mintNFT(uint64 _tokenId, uint64 _quantity)
//         public
//         returns (uint256)
//     {
//         tokenIds.increment();
//         uint256 newItemId = tokenIds.current();
//         _mint(msg.sender, _tokenId, _quantity, "");
//         setApprovalForAll(contractAddress, true);
//         return newItemId;
//     }

  
 


//     function _requireMinted(uint256 tokenId) internal view virtual {
//         require(_exists(tokenId), "ERC1155: invalid token ID");
//     }

//     function getApproved(uint256 tokenId)
//         public
//         view
//         virtual
//         returns (address)
//     {
//         _requireMinted(tokenId);
//         return _tokenApprovals[tokenId];
//     }

//     function isApprovedForAll(address owner, address operator)
//         public
//         view
//         virtual
//         override
//         returns (bool)
//     {
//         return _operatorApprovals[owner][operator];
//     }

//     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
//         return _owners[tokenId];
//     }

//     function ownerOf(uint256 tokenId) public view virtual returns (address) {
//         address owner = _ownerOf(tokenId);
//         require(owner != address(0), "ERC721: invalid token ID");
//         return owner;
//     }

//     function _exists(uint256 tokenId) internal view virtual returns (bool) {
//         return _ownerOf(tokenId) != address(0);
//     }

//     function _isApprovedOrOwner(address spender, uint256 tokenId)
//         internal
//         view
//         virtual
//         returns (bool)
//     {
//         address owner = ownerOf(tokenId);
//         return (spender == owner ||
//             isApprovedForAll(owner, spender) ||
//             getApproved(tokenId) == spender);
//     }


// }