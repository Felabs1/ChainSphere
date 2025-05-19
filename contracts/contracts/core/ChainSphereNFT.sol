// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IChainSphereNFT.sol";

contract ChainSphereNFT is IChainSphereNFT {
    string public name = "ChainSphere NFT";
    string public symbol = "CSNFT";

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(uint256 => string) private _tokenURIs;

    string private _baseTokenURI;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event URISet(uint256 indexed tokenId, string uri);
    event BaseURIUpdated(string newBaseURI);

    modifier onlyOwner(uint256 tokenId) {
        require(_owners[tokenId] == msg.sender, "You are not the token owner");
        _;
    }

    modifier exists(uint256 tokenId) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        _;
    }

    constructor(string memory baseURI_) {
        _baseTokenURI = baseURI_;
    }

    function mint(address to, uint256 tokenId, string memory tokenURI_) external override {
        require(to != address(0), "Cannot mint to zero address");
        require(_owners[tokenId] == address(0), "Token already exists");

        _owners[tokenId] = to;
        _balances[to] += 1;
        _tokenURIs[tokenId] = tokenURI_;

        emit Transfer(address(0), to, tokenId);
        emit URISet(tokenId, tokenURI_);
    }

    function burn(uint256 tokenId) external override onlyOwner(tokenId) exists(tokenId) {
        address owner = _owners[tokenId];

        _balances[owner] -= 1;
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        delete _tokenApprovals[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) external override exists(tokenId) {
        require(from != address(0) && to != address(0), "Invalid from or to address");
        require(_owners[tokenId] == from, "From address is not the owner");
        require(
            msg.sender == from || msg.sender == _tokenApprovals[tokenId],
            "Caller is not owner or approved"
        );

        _owners[tokenId] = to;
        _balances[from] -= 1;
        _balances[to] += 1;

        delete _tokenApprovals[tokenId];

        emit Transfer(from, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external onlyOwner(tokenId) exists(tokenId) {
        require(to != address(0), "Cannot approve to zero address");
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function ownerOf(uint256 tokenId) external view override exists(tokenId) returns (address) {
        return _owners[tokenId];
    }

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Invalid address");
        return _balances[owner];
    }

    function getApproved(uint256 tokenId) external view exists(tokenId) returns (address) {
        return _tokenApprovals[tokenId];
    }

    function tokenURI(uint256 tokenId) public view exists(tokenId) returns (string memory) {
        string memory tokenSpecific = _tokenURIs[tokenId];
        return bytes(_baseTokenURI).length > 0
            ? string(abi.encodePacked(_baseTokenURI, tokenSpecific))
            : tokenSpecific;
    }

    function setBaseURI(string memory baseURI_) external {
    
        _baseTokenURI = baseURI_;
        emit BaseURIUpdated(baseURI_);
    }
}
