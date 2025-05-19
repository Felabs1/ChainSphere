// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../models/UserModels.sol";

/// @title ChainSphereNFT
/// @notice NFT contract for user-generated content on ChainSphere
contract ChainSphereNFT is ERC721URIStorage, Ownable {
    using UserModels for UserModels.User;
    using UserModels for UserModels.Post;

    uint256 public nextTokenId;

    mapping(uint256 => UserModels.Post) public postMetadata;
    mapping(uint256 => address) public originalAuthors;
    mapping(address => UserModels.User) public registeredUsers;

    event NFTMinted(uint256 indexed tokenId, address indexed creator, string content);

    modifier onlyRegisteredUser() {
        require(registeredUsers[msg.sender].userId != address(0), "Not a registered user");
        _;
    }

    constructor() ERC721("ChainSphereNFT", "CSNFT") Ownable(msg.sender) {}

    function registerUser(UserModels.User calldata user) external onlyOwner {
        require(registeredUsers[user.userId].userId == address(0), "User already registered");
        registeredUsers[user.userId] = user;
    }

    function mintPostNFT(UserModels.Post calldata post, string calldata tokenURI) external onlyRegisteredUser {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        postMetadata[tokenId] = post;
        originalAuthors[tokenId] = msg.sender;

        emit NFTMinted(tokenId, msg.sender, post.content);
    }

    function getPostMetadata(uint256 tokenId) external view returns (UserModels.Post memory) {
        return postMetadata[tokenId];
    }

    function getAuthorLightUser(uint256 tokenId) external view returns (UserModels.LightUser memory) {
        address author = originalAuthors[tokenId];
        UserModels.User memory fullUser = registeredUsers[author];
        return UserModels.LightUser({
            userId: fullUser.userId,
            name: fullUser.name,
            username: fullUser.username,
            profilePic: fullUser.profilePic,
            zuriPoints: fullUser.zuriPoints
        });
    }
}
