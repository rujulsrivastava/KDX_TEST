// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";


contract DNFT is ERC1155Pausable, Ownable {
  // ...

  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 10 ether;
  uint256 public maxSupply = 5555;
  uint256 public maxMintAmount = 2;
  uint256 public nftPerAddressLimit = 2;
  bool public isPaused;
  bool public revealed = false;
  bool public onlyWhitelisted = true;
  address[] public whitelistedAddresses;
  mapping(address => uint256) public addressMintedBalance;

  constructor(
    string memory _uri
  ) ERC1155(_uri) {
    setBaseURI(_uri);
    setNotRevealedURI(_uri);
  }

//   constructor(
//     string memory _name,
//     string memory _symbol,
//     string memory _initBaseURI,
//     string memory _initNotRevealedUri
//   ) ERC721(_name, _symbol) {
//     setBaseURI(_initBaseURI);
//     setNotRevealedURI(_initNotRevealedUri);
//   }

  // internal
//   function _baseURI() internal view virtual override returns (string memory) {
//     return baseURI;
//   }

  // public
  // Define a counter variable to keep track of the total tokens minted
  uint256 private tokenIdCounter;
//   function mint(uint256 _mintAmount) public payable {
//     require(!paused, "the contract is paused");
//     uint256 ownerMintedCount = addressMintedBalance[msg.sender];
//     require(_mintAmount > 0, "need to mint at least 1 NFT");
//     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
//     require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
//     require(msg.value >= cost * _mintAmount, "insufficient funds");

//     for (uint256 i = 0; i < _mintAmount; i++) {
//         tokenIdCounter++;
//         uint256 tokenId = tokenIdCounter;
//         _mint(msg.sender, tokenId, 1, "");
//     }
//     addressMintedBalance[msg.sender] += _mintAmount;
//     }

  
  function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }

  mapping(address => uint256[]) private tokensOwned;
  function mint(uint256 _mintAmount) public payable {
    // ... (your existing mint function code)

    for (uint256 i = 0; i < _mintAmount; i++) {
        tokenIdCounter++;
        uint256 tokenId = tokenIdCounter;
        _mint(msg.sender, tokenId, 1, "");
        tokensOwned[msg.sender].push(tokenId);
    }
    addressMintedBalance[msg.sender] += _mintAmount;
    }
    
    function walletOfOwner(address _owner) public view returns (uint256[] memory){
         return tokensOwned[_owner];
    }

    function uri(uint256 tokenId) public view virtual override returns (string memory) {
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = super.uri(tokenId);
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
    }




//   function tokenURI(uint256 tokenId)
//     public
//     view
//     virtual
//     override
//     returns (string memory)
//   {
//     require(
//       _exists(tokenId),
//       "ERC721Metadata: URI query for nonexistent token"
//     );
    
//     if(revealed == false) {
//         return notRevealedUri;
//     }

//     string memory currentBaseURI = _baseURI();
//     return bytes(currentBaseURI).length > 0
//         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
//         : "";
//   }

  //only owner
//   function reveal() public onlyOwner {
//       revealed = true;
//   }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    nftPerAddressLimit = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

 
  function pause(bool _state) public onlyOwner {
    isPaused = _state;
  }

  
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }
  
  function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
 
  function withdraw() public payable onlyOwner {
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
}
