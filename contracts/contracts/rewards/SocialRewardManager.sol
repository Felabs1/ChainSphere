// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./core/ChainSphereToken.sol";

/// @title Social Reward Manager
/// @notice Distributes ERC20 rewards to users based on social interactions
contract SocialRewardManager is Ownable {
    ChainSphereToken public immutable rewardToken;

    mapping(address => uint256) public totalRewards;
    mapping(address => bool) public isTrustedSource;

    event RewardGranted(address indexed user, uint256 amount, string reason);
    event SourceUpdated(address indexed source, bool trusted);

    /// @notice Constructor
    /// @param _rewardToken Address of the ERC20 reward token
    /// @param _initialOwner Address to be set as contract owner
    constructor(address _rewardToken, address _initialOwner) Ownable(_initialOwner) {
        rewardToken = ChainSphereToken(_rewardToken);
    }

    modifier onlyTrustedSource() {
        require(isTrustedSource[msg.sender], "Not a trusted source");
        _;
    }

    function updateTrustedSource(address source, bool trusted) external onlyOwner {
        isTrustedSource[source] = trusted;
        emit SourceUpdated(source, trusted);
    }

    function grantReward(address user, uint256 amount, string calldata reason) external onlyTrustedSource {
        rewardToken.mint(user, amount);
        totalRewards[user] += amount;
        emit RewardGranted(user, amount, reason);
    }

    function getTotalRewards(address user) external view returns (uint256) {
        return totalRewards[user];
    }
}
