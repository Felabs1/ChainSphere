// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ChainsphereCore.sol";
import "./UserManagement.sol";
import "./Models.sol";

contract PostManagement is ChainsphereCore {
    UserManagement public userContract;
    uint256 public postsCount;
    uint256 public commentCount;
    
    // Posts and comments
    mapping(uint256 => ChainsphereModels.Post) public posts;
    mapping(uint256 => mapping(uint256 => ChainsphereModels.Comment)) public postComments;
    mapping(address => mapping(uint256 => string)) public postLikes;
    
    event PostCreated(uint256 indexed postId, address indexed creator);
    event PostLiked(uint256 indexed postId, address indexed liker);
    event PostCommented(uint256 indexed postId, uint256 indexed commentId, address indexed commenter);
    
    constructor(address _deployer, address _userContractAddress) ChainsphereCore(_deployer) {
        userContract = UserManagement(_userContractAddress);
    }
    
    function createPost(string memory content, string memory images) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        
        ChainsphereModels.Post memory newPost = ChainsphereModels.Post({
            postId: postsCount,
            caller: caller,
            content: content,
            likes: 0,
            comments: 0,
            shares: 0,
            images: images,
            chainspherePoints: 0,
            datePosted: uint64(block.timestamp)
        });
        
        posts[postsCount] = newPost;
        postsCount++;
        
        emit PostCreated(postsCount - 1, caller);
    }
    
    function likePost(uint256 postId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(postId < postsCount, "Post does not exist");
        require(bytes(postLikes[caller][postId]).length == 0, "Already liked this post");
        
        posts[postId].likes++;
        postLikes[caller][postId] = "liked";
        
        emit PostLiked(postId, caller);
    }
    
    function unlikePost(uint256 postId) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(postId < postsCount, "Post does not exist");
        require(bytes(postLikes[caller][postId]).length > 0, "Have not liked this post");
        
        posts[postId].likes--;
        delete postLikes[caller][postId];
    }
    
    function viewLikes(uint256 postId) external view returns (ChainsphereModels.User[] memory) {
        require(postId < postsCount, "Post does not exist");
        
        uint8 likesCount = posts[postId].likes;
        ChainsphereModels.User[] memory likersList = new ChainsphereModels.User[](likesCount);
        uint8 currentIndex = 0;
        
        for (uint256 i = 0; i < userContract.viewUserCount(); i++) {
            address potentialLiker = userContract.userAddresses(i);
            if (bytes(postLikes[potentialLiker][postId]).length > 0) {
                likersList[currentIndex] = userContract.viewUser(potentialLiker);
                currentIndex++;
                
                if (currentIndex == likesCount) {
                    break;
                }
            }
        }
        
        return likersList;
    }
    
    function commentOnPost(uint256 postId, string memory content) external {
        address caller = msg.sender;
        require(userContract.viewUser(caller).userId != address(0), "User not registered");
        require(postId < postsCount, "Post does not exist");
        
        ChainsphereModels.Comment memory newComment = ChainsphereModels.Comment({
            postId: postId,
            commentId: commentCount,
            caller: caller,
            content: content,
            likes: 0,
            replies: 0,
            timeCommented: uint64(block.timestamp),
            chainspherePoints: 0
        });
        
        postComments[postId][posts[postId].comments] = newComment;
        posts[postId].comments++;
        commentCount++;
        
        emit PostCommented(postId, commentCount - 1, caller);
    }
    
    function viewComments(uint256 postId) external view returns (ChainsphereModels.Comment[] memory) {
        require(postId < postsCount, "Post does not exist");
        
        uint256 commentsCount = posts[postId].comments;
        ChainsphereModels.Comment[] memory postCommentsList = new ChainsphereModels.Comment[](commentsCount);
        
        for (uint256 i = 0; i < commentsCount; i++) {
            postCommentsList[i] = postComments[postId][i];
        }
        
        return postCommentsList;
    }
    
    function viewPosts(uint256 page) external view returns (ChainsphereModels.PostView[] memory) {
        uint256 pageSize = 10;
        uint256 startIdx = page * pageSize;
        uint256 endIdx = startIdx + pageSize;
        
        if (endIdx > postsCount) {
            endIdx = postsCount;
        }
        
        if (startIdx >= postsCount) {
            return new ChainsphereModels.PostView[](0);
        }
        
        uint256 resultSize = endIdx - startIdx;
        ChainsphereModels.PostView[] memory result = new ChainsphereModels.PostView[](resultSize);
        
        for (uint256 i = 0; i < resultSize; i++) {
            uint256 postIdx = startIdx + i;
            ChainsphereModels.Post memory post = posts[postIdx];
            ChainsphereModels.User memory author = userContract.viewUser(post.caller);
            
            ChainsphereModels.LightUser memory lightUser = ChainsphereModels.LightUser({
                userId: author.userId,
                name: author.name,
                username: author.username,
                profilePic: author.profilePic,
                chainspherePoints: author.chainspherePoints
            });
            
            result[i] = ChainsphereModels.PostView({
                postId: post.postId,
                author: lightUser,
                content: post.content,
                likes: post.likes,
                comments: post.comments,
                shares: post.shares,
                images: post.images,
                chainspherePoints: post.chainspherePoints,
                datePosted: post.datePosted
            });
        }
        
        return result;
    }
    
    function filterPost(address user) external view returns (ChainsphereModels.Post[] memory) {
        require(userContract.viewUser(user).userId != address(0), "User does not exist");
        
        uint256 userPostCount = 0;
        for (uint256 i = 0; i < postsCount; i++) {
            if (posts[i].caller == user) {
                userPostCount++;
            }
        }
        
        ChainsphereModels.Post[] memory userPosts = new ChainsphereModels.Post[](userPostCount);
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < postsCount; i++) {
            if (posts[i].caller == user) {
                userPosts[currentIndex] = posts[i];
                currentIndex++;
            }
        }
        
        return userPosts;
    }
    
    function viewPost(uint256 postId) external view returns (ChainsphereModels.Post memory) {
        require(postId < postsCount, "Post does not exist");
        return posts[postId];
    }
    
    function claimPostPoints(uint256 postId) external {
        address caller = msg.sender;
        require(posts[postId].caller == caller, "Only post creator can claim points");
        require(posts[postId].chainspherePoints > 0, "No points to claim");
        
        uint256 pointsToClaim = posts[postId].chainspherePoints;
        posts[postId].chainspherePoints = 0;
        
       
    }
    
    function getTotalPosts() external view returns (uint256) {
        return postsCount;
    }
}