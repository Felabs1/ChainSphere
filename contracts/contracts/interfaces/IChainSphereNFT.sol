// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IChainSphereNFT {
    function mint(address to, uint256 tokenId, string memory tokenURI_) external;
    function burn(uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}
