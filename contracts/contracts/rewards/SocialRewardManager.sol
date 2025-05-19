// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../models/UserModels.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title SocialRewardManager
/// @notice Distributes rewards based on social interactions using Zuri Tokens
contract SocialRewardManager is Ownable {
    using UserModels for UserModels.User;
    using UserModels for UserModels.Post;

    IERC20 public zuriToken;

    struct RewardSettings {
        uint256 likeReward;
        uint256 commentReward;
        uint256 shareReward;
    }

    mapping(address => UserModels.User) public users;
    mapping(uint256 => UserModels.Post) public posts;
    mapping(address => bool) public isTrustedSource;

    RewardSettings public rewardSettings;

    event RewardIssued(address indexed user, uint256 amount, string reason);
    event TrustedSourceUpdated(address indexed source, bool status);

    modifier onlyTrustedSource() {
        require(isTrustedSource[msg.sender], "Not a trusted source");
        _;
    }

    constructor(address _token) Ownable(msg.sender) {
        zuriToken = IERC20(_token);
        rewardSettings = RewardSettings({
            likeReward: 10 * 1e18,
            commentReward: 20 * 1e18,
            shareReward: 30 * 1e18
    });
    }


    function setTrustedSource(address source, bool status) external onlyOwner {
        isTrustedSource[source] = status;
        emit TrustedSourceUpdated(source, status);
    }

    function updateRewardSettings(uint256 likeR, uint256 commentR, uint256 shareR) external onlyOwner {
        rewardSettings = RewardSettings({
            likeReward: likeR,
            commentReward: commentR,
            shareReward: shareR
        });
    }

    function rewardUserFromPost(UserModels.Post calldata post) external onlyTrustedSource {
        uint256 totalReward = (post.likes * rewardSettings.likeReward) +
                              (post.comments * rewardSettings.commentReward) +
                              (post.shares * rewardSettings.shareReward);

        require(zuriToken.transfer(post.caller, totalReward), "Reward transfer failed");

        users[post.caller].zuriPoints += totalReward;

        emit RewardIssued(post.caller, totalReward, "Post engagement");
    }

    function registerUser(UserModels.User calldata user) external onlyTrustedSource {
        require(users[user.userId].userId == address(0), "User already registered");
        users[user.userId] = user;
    }

    function getUser(address userId) external view returns (UserModels.User memory) {
        return users[userId];
    }

    function getPost(uint256 postId) external view returns (UserModels.Post memory) {
        return posts[postId];
    }

    function storePost(UserModels.Post calldata post) external onlyTrustedSource {
        posts[post.postId] = post;
    }
}
