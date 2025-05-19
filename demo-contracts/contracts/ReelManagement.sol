
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./Models.sol";

contract ReelManagement is ChainsphereCore {
    UserManagement public userContract;
    uint256 public reelCount;
    uint256 public reelCommentCount;
    
    // Reels
    mapping(uint256 => ChainsphereModels.Reel) public reels;
    mapping(address => mapping(uint256 => string)) public reelLikes;
    mapping(address => mapping(uint256 => string)) public reelDislikes;
    mapping(uint256 => mapping(uint256 => ChainsphereModels.Comment)) public reelComments;
    mapping(uint256 => uint256) public reelCommentCounts;
    
    event ReelCreated(uint256 indexed reelId, address indexed creator);
    event ReelLiked(uint256 indexed reelId, address indexed liker);
    event ReelDisliked(uint256 indexed reelId, address indexed disliker);
    event ReelCommented(uint256 indexed reelId, uint256 indexed commentId, address indexed commenter);
    
    constructor(address _deployer, address _userContractAddress) ChainsphereCore(_deployer) {
        userContract = UserManagement(_userContractAddress);
    }
    
    function createReel(string memory description, string memory video) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        
        ChainsphereModels.Reel memory newReel = ChainsphereModels.Reel({
            reelId: reelCount,
            caller: caller,
            likes: 0,
            dislikes: 0,
            comments: 0,
            shares: 0,
            video: video,
            timestamp: uint64(block.timestamp),
            description: description,
            chainspherePoints: 0
        });
        
        reels[reelCount] = newReel;
        reelCount++;
        
        emit ReelCreated(reelCount - 1, caller);
    }
    
    function viewReels() external view returns (ChainsphereModels.Reel[] memory) {
        ChainsphereModels.Reel[] memory allReels = new ChainsphereModels.Reel[](reelCount);
        
        for (uint256 i = 0; i < reelCount; i++) {
            allReels[i] = reels[i];
        }
        
        return allReels;
    }

    function viewReel(uint256 reelId) external view returns (ChainsphereModels.Reel memory) {
    require(reelId < reelCount, "Reel does not exist");
    return reels[reelId];
}
    
    function viewReelsForAccount(address owner) external view returns (ChainsphereModels.Reel[] memory) {
        require(userContract.viewUser(owner).userId != address(0), "User does not exist");
        
        uint256 ownerReelCount = 0;
        for (uint256 i = 0; i < reelCount; i++) {
            if (reels[i].caller == owner) {
                ownerReelCount++;
            }
        }
        
        ChainsphereModels.Reel[] memory ownerReels = new ChainsphereModels.Reel[](ownerReelCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < reelCount; i++) {
            if (reels[i].caller == owner) {
                ownerReels[currentIndex] = reels[i];
                currentIndex++;
            }
        }
        
        return ownerReels;
    }
    
    function likeReel(uint256 reelId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(reelId < reelCount, "Reel does not exist");
        require(bytes(reelLikes[caller][reelId]).length == 0, "Already liked this reel");
        
        // If user disliked before, remove the dislike
        if (bytes(reelDislikes[caller][reelId]).length > 0) {
            reels[reelId].dislikes--;
            delete reelDislikes[caller][reelId];
        }
        
        reels[reelId].likes++;
        reelLikes[caller][reelId] = "liked";
        
        emit ReelLiked(reelId, caller);
    }
    
    function dislikeReel(uint256 reelId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(reelId < reelCount, "Reel does not exist");
        require(bytes(reelDislikes[caller][reelId]).length == 0, "Already disliked this reel");
        
        // If user liked before, remove the like
        if (bytes(reelLikes[caller][reelId]).length > 0) {
            reels[reelId].likes--;
            delete reelLikes[caller][reelId];
        }
        
        reels[reelId].dislikes++;
        reelDislikes[caller][reelId] = "disliked";
        
        emit ReelDisliked(reelId, caller);
    }
    
    function commentOnReel(uint256 reelId, string memory content) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(reelId < reelCount, "Reel does not exist");
        
        ChainsphereModels.Comment memory newComment = ChainsphereModels.Comment({
            postId: reelId, // Using postId to store reelId for comment
            commentId: reelCommentCount,
            caller: caller,
            content: content,
            likes: 0,
            replies: 0,
            timeCommented: uint64(block.timestamp),
            chainspherePoints: 0
        });
        
        reelComments[reelId][reelCommentCounts[reelId]] = newComment;
        reelCommentCounts[reelId]++;
        reels[reelId].comments++;
        reelCommentCount++;
        
        emit ReelCommented(reelId, reelCommentCount - 1, caller);
    }
    
    function viewReelComments(uint256 reelId) external view returns (ChainsphereModels.Comment[] memory) {
        require(reelId < reelCount, "Reel does not exist");
        
        uint256 commentCount = reelCommentCounts[reelId];
        ChainsphereModels.Comment[] memory comments = new ChainsphereModels.Comment[](commentCount);
        
        for (uint256 i = 0; i < commentCount; i++) {
            comments[i] = reelComments[reelId][i];
        }
        
        return comments;
    }
    


function repostReel(uint256 reelId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(reelId < reelCount, "Reel does not exist");
        
        // Increment shares count for the original reel
        reels[reelId].shares++;
        
        // Create a new reel as a repost (you could add metadata to indicate it's a repost)
        ChainsphereModels.Reel memory newReel = ChainsphereModels.Reel({
            reelId: reelCount,
            caller: caller,
            likes: 0,
            dislikes: 0,
            comments: 0,
            shares: 0,
            video: reels[reelId].video,
            timestamp: uint64(block.timestamp),
            description: string(abi.encodePacked("Reposted: ", reels[reelId].description)),
            chainspherePoints: 0
        });
        
        reels[reelCount] = newReel;
        reelCount++;
        
        emit ReelCreated(reelCount - 1, caller);
    }
    
    function claimReelPoints(uint256 reelId) external {
        address caller = msg.sender;
        require(reels[reelId].caller == caller, "Only reel creator can claim points");
        require(reels[reelId].chainspherePoints > 0, "No points to claim");
        
        uint256 pointsToClaim = reels[reelId].chainspherePoints;
        reels[reelId].chainspherePoints = 0;
        

    }
}