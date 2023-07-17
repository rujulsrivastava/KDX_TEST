// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.9.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.2/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts@4.9.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.9.2/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.9.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.2/utils/Counters.sol";


contract MainNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    using SafeMath for uint256;
    mapping(uint256 => TokenData) private _tokenData;
    mapping(address => bool) private _authorizedAddresses;

    IERC20 private _paymentToken;
    uint256 private _listingFee;

    event TokenListed(uint256 indexed tokenId, uint256 price);
    event TokenSold(uint256 indexed tokenId, address indexed buyer, address indexed seller, uint256 price);

    struct TokenData {
        string ipfsHash;
        uint256 timestamp;
        uint256 price;
        bool isListed;
    }

    Counters.Counter private _tokenIdCounter;

    constructor(address paymentTokenAddress) ERC721("MainNFT", "MFT") {
        // _paymentToken = IERC20(paymentTokenAddress);
        // _listingFee = 0.0001 ether;
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        // _setTokenData(tokenId, ipfsHash, block.timestamp, 0, false);
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




    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
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



    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}




    // function mint(
    //     // address to,
    //     uint256 tokenId,
    //     string memory ipfsHash
    // ) external onlyAuthorized {
    //     _safeMint(to, tokenId);
    //     
    // }


    

    



