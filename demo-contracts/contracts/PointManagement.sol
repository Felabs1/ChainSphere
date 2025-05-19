// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./PostManagement.sol";
import "./ReelManagement.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Models.sol";

contract PointManagement is ChainsphereCore {
    UserManagement public userContract;
    PostManagement public postContract;
    ReelManagement public reelContract;
    
    // Points tracking
    mapping(address => uint256) public claimedPoints;
    mapping(address => uint256) public pendingPoints;
    mapping(address => mapping(string => mapping(uint256 => bool))) public pointsClaimedForContent;
    
    // Reward constants
    uint256 public constant POST_CREATION_POINTS = 5;
    uint256 public constant POST_LIKE_POINTS = 1;
    uint256 public constant POST_COMMENT_POINTS = 2;
    uint256 public constant REEL_CREATION_POINTS = 10;
    uint256 public constant REEL_LIKE_POINTS = 1;
    uint256 public constant REEL_COMMENT_POINTS = 2;
    
    event PointsEarned(address indexed user, uint256 amount, string actionType, uint256 contentId);
    event PointsClaimed(address indexed user, uint256 amount);
    event PointsConverted(address indexed user, uint256 pointsAmount, uint256 tokenAmount);
    
    constructor(
        address _deployer,
        address _userContractAddress,
        address _postContractAddress,
        address _reelContractAddress
    ) ChainsphereCore(_deployer) {
        userContract = UserManagement(_userContractAddress);
        postContract = PostManagement(_postContractAddress);
        reelContract = ReelManagement(_reelContractAddress);
    }
    
    // Award points when a user creates content or interacts with the platform
    function awardPoints(
        address user, 
        uint256 amount, 
        string memory actionType,
        uint256 contentId
    ) external {
        // Only allow specific contracts to award points
        require(
            msg.sender == address(postContract) || 
            msg.sender == address(reelContract) ||
            msg.sender == owner(),
            "Unauthorized point allocation"
        );
        
        // Add points to user's pending balance
        pendingPoints[user] += amount;
        
        emit PointsEarned(user, amount, actionType, contentId);
    }
    
    // Function for users to claim points for a specific post
    function claimPostPoints(uint256 postId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        
        // Verify the post exists and belongs to the caller
        ChainsphereModels.Post memory post = postContract.viewPost(postId);
        require(post.caller == caller, "Not the post owner");
        
        // Check if points have already been claimed for this post
        require(!pointsClaimedForContent[caller]["post"][postId], "Points already claimed");
        
        // Calculate points based on engagement
        uint256 pointsToAward = POST_CREATION_POINTS;
        pointsToAward += post.likes * POST_LIKE_POINTS;
        pointsToAward += uint256(post.comments) * POST_COMMENT_POINTS;
        
        // Mark as claimed
        pointsClaimedForContent[caller]["post"][postId] = true;
        
        // Update points balance
        claimedPoints[caller] += pointsToAward;
        
        emit PointsClaimed(caller, pointsToAward);
    }
    
    // Function for users to claim points for a specific reel
    function claimReelPoints(uint256 reelId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        
        // Verify the reel exists and belongs to the caller
        ChainsphereModels.Reel memory reel = reelContract.viewReel(reelId);
        require(reel.caller == caller, "Not the reel owner");
        
        // Check if points have already been claimed for this reel
        require(!pointsClaimedForContent[caller]["reel"][reelId], "Points already claimed");
        
        // Calculate points based on engagement
        uint256 pointsToAward = REEL_CREATION_POINTS;
        pointsToAward += reel.likes * REEL_LIKE_POINTS;
        pointsToAward += reel.comments * REEL_COMMENT_POINTS;
        
        // Mark as claimed
        pointsClaimedForContent[caller]["reel"][reelId] = true;
        
        // Update points balance
        claimedPoints[caller] += pointsToAward;
        
        emit PointsClaimed(caller, pointsToAward);
    }
    
    // Function to claim all pending points
    function claimAllPendingPoints() external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(pendingPoints[caller] > 0, "No pending points to claim");
        
        uint256 pointsToAward = pendingPoints[caller];
        pendingPoints[caller] = 0;
        claimedPoints[caller] += pointsToAward;
        
        emit PointsClaimed(caller, pointsToAward);
    }
    
    // Check a user's total points (claimed + pending)
    function getTotalPoints(address user) external view returns (uint256) {
        return claimedPoints[user] + pendingPoints[user];
    }
    
    // Convert points to tokens (if implemented)
    function convertPointsToTokens(uint256 pointsAmount) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(claimedPoints[caller] >= pointsAmount, "Insufficient points");
        
        // Get the token address for the chainsphere token
        address tokenAddress = tokenAddresses["chainsphere"];
        require(tokenAddress != address(0), "Token not configured");
        
        // Conversion rate (e.g., 10 points = 1 token)
        uint256 conversionRate = 10;
        uint256 tokensToMint = pointsAmount / conversionRate;
        
        // Ensure there's something to convert
        require(tokensToMint > 0, "Too few points to convert");
        
        // Deduct points
        claimedPoints[caller] -= pointsAmount;
        
        
        emit PointsConverted(caller, pointsAmount, tokensToMint);
    }
    
    // Admin function to adjust points (for corrections or special events)
    function adjustPoints(address user, int256 pointAdjustment) external onlyOwner {
        require(userContract.viewUser(user).userId != address(0), "User not registered");
        
        if (pointAdjustment >= 0) {
            claimedPoints[user] += uint256(pointAdjustment);
        } else {
            uint256 absAdjustment = uint256(-pointAdjustment);
            // Ensure we don't underflow
            if (absAdjustment > claimedPoints[user]) {
                claimedPoints[user] = 0;
            } else {
                claimedPoints[user] -= absAdjustment;
            }
        }
    }
    
    // Award points based on specific actions
    function awardPointsForAction(address user, string memory actionType) external {
        // Only allow specific contracts to call this function
        require(
            msg.sender == address(postContract) || 
            msg.sender == address(reelContract) ||
            msg.sender == address(userContract) ||
            msg.sender == owner(),
            "Unauthorized"
        );
        
        uint256 pointsToAward = 0;
        
        // Different points for different action types
        if (keccak256(abi.encodePacked(actionType)) == keccak256(abi.encodePacked("login"))) {
            pointsToAward = 1;
        } else if (keccak256(abi.encodePacked(actionType)) == keccak256(abi.encodePacked("profile_update"))) {
            pointsToAward = 5;
        } else if (keccak256(abi.encodePacked(actionType)) == keccak256(abi.encodePacked("refer_user"))) {
            pointsToAward = 20;
        }
        
        if (pointsToAward > 0) {
            pendingPoints[user] += pointsToAward;
            emit PointsEarned(user, pointsToAward, actionType, 0);
        }
    }
}