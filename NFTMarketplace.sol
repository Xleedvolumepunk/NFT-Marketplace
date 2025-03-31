// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;

    event NFTListed(address indexed seller, address indexed nftAddress, uint256 indexed tokenId, uint256 price);
    event NFTSold(address indexed buyer, address indexed nftAddress, uint256 indexed tokenId, uint256 price);

    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external {
        IERC721 nft = IERC721(nftAddress);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(nft.isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        listings[nftAddress][tokenId] = Listing(price, msg.sender);
        emit NFTListed(msg.sender, nftAddress, tokenId, price);
    }

    function buyNFT(address nftAddress, uint256 tokenId) external payable nonReentrant {
        Listing memory listing = listings[nftAddress][tokenId];
        require(msg.value == listing.price, "Incorrect price");

        delete listings[nftAddress][tokenId];
        IERC721(nftAddress).safeTransferFrom(listing.seller, msg.sender, tokenId);

        payable(listing.seller).transfer(msg.value);

        emit NFTSold(msg.sender, nftAddress, tokenId, listing.price);
    }
}
