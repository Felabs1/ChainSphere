// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../models/UserModels.sol";
import "./ProposalLib.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title ChainSphereDAO
/// @notice Decentralized governance for ChainSphere using proposals and user voting
contract ChainSphereDAO is Ownable {
    using UserModels for UserModels.User;
    using UserModels for UserModels.LightUser;
    using ProposalLib for ProposalLib.ProposalCore;

    uint256 public proposalCount;

    mapping(uint256 => ProposalLib.ProposalCore) public proposals;
    mapping(uint256 => mapping(address => ProposalLib.VoteType)) public votes;
    mapping(address => UserModels.User) public users;

    event ProposalCreated(uint256 indexed id, address indexed proposer, string description);
    event VoteCast(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlyRegisteredUser() {
        require(users[msg.sender].userId != address(0), "Not a registered user");
        _;
    }

    constructor() Ownable(msg.sender) {}

    function registerUser(UserModels.User calldata user) external onlyOwner {
        require(users[user.userId].userId == address(0), "User already registered");
        users[user.userId] = user;
    }

    function createProposal(string calldata description) external onlyRegisteredUser returns (uint256) {
        proposalCount++;
        ProposalLib.ProposalCore storage proposal = proposals[proposalCount];
        proposal.id = proposalCount;
        proposal.description = description;
        proposal.proposer = msg.sender;
        proposal.deadline = uint64(block.timestamp + 3 days);
        proposal.executed = false;

        emit ProposalCreated(proposalCount, msg.sender, description);
        return proposalCount;
    }

    function vote(uint256 proposalId, bool support) external onlyRegisteredUser {
        ProposalLib.ProposalCore storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.deadline, "Voting period over");
        require(votes[proposalId][msg.sender] == ProposalLib.VoteType.None, "Already voted");

        if (support) {
            proposal.voteYes++;
            votes[proposalId][msg.sender] = ProposalLib.VoteType.Yes;
        } else {
            proposal.voteNo++;
            votes[proposalId][msg.sender] = ProposalLib.VoteType.No;
        }

        emit VoteCast(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external onlyOwner {
        ProposalLib.ProposalCore storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting still ongoing");
        require(!proposal.executed, "Already executed");
        require(proposal.voteYes > proposal.voteNo, "Proposal did not pass");

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    function getUser(address userAddr) external view returns (UserModels.User memory) {
        return users[userAddr];
    }

    function getProposal(uint256 id) external view returns (ProposalLib.ProposalCore memory) {
        return proposals[id];
    }
}
