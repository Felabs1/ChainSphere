// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../core/ChainSphereToken.sol";
import "./IGovernance.sol";
import "./ProposalLib.sol";

contract ChainSphereDAO is IGovernance {
    struct Proposal {
        uint256 id;
        string description;
        address proposer;
        uint256 voteYes;
        uint256 voteNo;
        uint256 deadline;
        bool executed;
        mapping(address => bool) voted;
    }

    ChainSphereToken public governanceToken;
    uint256 public proposalCount;
    mapping(uint256 => ProposalLib.ProposalState) public proposals;

    uint256 public votingPeriod = 3 days;
    address public admin;

    modifier onlyTokenHolders() {
        require(governanceToken.balanceOf(msg.sender) > 0, "Must hold CST to participate");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    event ProposalCreated(uint256 indexed id, address proposer, string description);
    event Voted(uint256 indexed id, address voter, bool support, uint256 weight);
    event ProposalExecuted(uint256 indexed id);

    constructor(address _token) {
        governanceToken = ChainSphereToken(_token);
        admin = msg.sender;
    }

    function createProposal(string memory description) external onlyTokenHolders returns (uint256) {
        proposalCount++;
        ProposalLib.ProposalState storage p = proposals[proposalCount];
        p.core.id = proposalCount;
        p.core.description = description;
        p.core.proposer = msg.sender;
        p.core.deadline = block.timestamp + votingPeriod;

        emit ProposalCreated(p.core.id, msg.sender, description);
        return p.core.id;
    }

    function vote(uint256 proposalId, bool support) external onlyTokenHolders {
        ProposalLib.ProposalState storage proposal = proposals[proposalId];
        require(block.timestamp <= proposal.core.deadline, "Voting period has ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");

        uint256 weight = governanceToken.balanceOf(msg.sender);
        proposal.hasVoted[msg.sender] = true;

        if (support) {
            proposal.core.voteYes += weight;
        } else {
            proposal.core.voteNo += weight;
        }

        emit Voted(proposalId, msg.sender, support, weight);
    }

    function executeProposal(uint256 proposalId) external onlyAdmin {
        ProposalLib.ProposalState storage proposal = proposals[proposalId];
        require(!proposal.core.executed, "Already executed");
        require(block.timestamp > proposal.core.deadline, "Voting not ended yet");

        if (proposal.core.voteYes > proposal.core.voteNo) {
            proposal.core.executed = true;
            emit ProposalExecuted(proposalId);
        }
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }
}
