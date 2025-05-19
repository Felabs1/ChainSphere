// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title User and Post Models for ChainSphere
/// @notice Shared struct definitions for user data and post content

library UserModels {

    struct User {
        address userId;
        string name;
        string username;
        string about;
        string profilePic;
        string coverPhoto;
        uint64 dateRegistered;
        uint8 noOfFollowers;
        uint8 numberFollowing;
        uint256 notifications;
        uint256 zuriPoints;
    }

    struct LightUser {
        address userId;
        string name;
        string username;
        string profilePic;
        uint256 zuriPoints;
    }

    struct Post {
        uint256 postId;
        address caller;
        string content;
        uint8 likes;
        uint256 comments;
        uint8 shares;
        string images;
        uint256 zuriPoints;
        uint64 datePosted;
    }
}
