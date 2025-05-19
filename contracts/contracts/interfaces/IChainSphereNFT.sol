// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../models/UserModels.sol";

/// @title IChainSphereNFT
/// @notice Interface for ChainSphere NFT contract
interface IChainSphereNFT {

    /// @notice Mint a new NFT representing a post
    /// @param post The metadata of the post to mint
    /// @param tokenURI The metadata URI for the token
    function mintPostNFT(UserModels.Post calldata post, string calldata tokenURI) external;

    /// @notice Retrieve metadata associated with a post NFT
    /// @param tokenId The ID of the token
    function getPostMetadata(uint256 tokenId) external view returns (UserModels.Post memory);

    /// @notice Retrieve light user info for a given token's creator
    /// @param tokenId The ID of the token
    function getAuthorLightUser(uint256 tokenId) external view returns (UserModels.LightUser memory);
} 
