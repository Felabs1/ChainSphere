// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Models.sol";

contract ChainsphereCore is Ownable {
    address public deployer;
    uint256 public versionNumber; // Renamed to avoid conflict
    
    mapping(string => address) public tokenAddresses;
    mapping(address => uint256) public balances;
    
    event Upgraded(address indexed implementation);
    
    constructor(address _deployer) Ownable(_deployer) { // Pass deployer to Ownable constructor
        deployer = _deployer;
        // No need to call transferOwnership as we already passed the owner to Ownable
    }
    
    function getOwner() external view returns (address) {
        return owner();
    }
    
    function addTokenAddress(string memory tokenName, address tokenAddress) external onlyOwner {
        tokenAddresses[tokenName] = tokenAddress;
    }
    
    function viewContractBalance(address addr) external view returns (uint256) {
        return balances[addr];
    }
    
    function getVersion() external view returns (uint256) { // Renamed to avoid conflict
        return versionNumber;
    }
}