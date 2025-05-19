// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// models.sol
library ChainsphereModels {
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
        uint256 chainspherePoints;
    }

    struct LightUser {
        address userId;
        string name;
        string username;
        string profilePic;
        uint256 chainspherePoints;
    }

    struct Post {
        uint256 postId;
        address caller;
        string content;
        uint8 likes;
        uint256 comments;
        uint8 shares;
        string images;
        uint256 chainspherePoints;
        uint64 datePosted;
    }

    struct PostView {
        uint256 postId;
        LightUser author;
        string content;
        uint8 likes;
        uint256 comments;
        uint8 shares;
        string images;
        uint256 chainspherePoints;
        uint64 datePosted;
    }

    struct Comment {
        uint256 postId;
        uint256 commentId;
        address caller;
        string content;
        uint8 likes;
        uint8 replies;
        uint64 timeCommented;
        uint256 chainspherePoints;
    }

    struct Community {
        uint256 communityId;
        address communityAdmin;
        string communityName;
        string description;
        uint256 members;
        uint256 onlineMembers;
        string profileImage;
        string coverImage;
        uint256 chainspherePoints;
    }

    struct Notification {
        uint256 notificationId;
        address caller;
        address receiver;
        string notificationMessage;
        string notificationType;
        string notificationStatus;
        uint64 timestamp;
    }
    struct Message {
        address sender;
        address receiver;
        string message;
        uint64 timestamp;
        string groupName;
        string media;
    }

    struct Reel {
        uint256 reelId;
        address caller;
        uint256 likes;
        uint256 dislikes;
        uint256 comments;
        uint256 shares;
        string video;
        uint64 timestamp;
        string description;
        uint256 chainspherePoints;
    }
}