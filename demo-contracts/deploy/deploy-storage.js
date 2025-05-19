const { Deployer } = require("@matterlabs/hardhat-zksync");
const { Wallet } = require("zksync-ethers");
const fs = require("fs");

module.exports = async function (hre) {
  console.log("Starting deployment process...");
  
  // Initialize the wallet
  const privateKey = process.env.PRIVATE_KEY || "10969715a228797ff439113b59c0bfd70cb25101f3ee716de425971e20d5f120";
  const wallet = new Wallet(privateKey);
  console.log(`Using deployer address: ${wallet.address}`);
  
  // Create deployer object
  const deployer = new Deployer(hre, wallet);
  
  // First deploy core contract and models
  console.log("Deploying ChainsphereCore...");
  const coreArtifact = await deployer.loadArtifact("ChainsphereCore");
  const coreContract = await deployer.deploy(coreArtifact, [wallet.address]);
  console.log(`ChainsphereCore deployed to ${await coreContract.getAddress()}`);
  
  // Load and deploy all the contracts
  console.log("Deploying registry and component contracts...");
  const registryArtifact = await deployer.loadArtifact("ChainsphereRegistry");
  const registryContract = await deployer.deploy(registryArtifact, [wallet.address]);
  
  console.log(`ChainsphereRegistry deployed to ${await registryContract.getAddress()}`);
  
  // Get all contract addresses from the registry
  console.log("Retrieving component contract addresses...");
  const addresses = await registryContract.getContractAddresses();
  
  // Log all contract addresses
  const contractNames = [
    "UserManagement",
    "PostManagement",
    "CommunityManagement",
    "NotificationManagement",
    "ReelManagement",
    "PointManagement"
  ];
  
  const deployedAddresses = {};
  deployedAddresses["ChainsphereRegistry"] = await registryContract.getAddress();
  
  for (let i = 0; i < contractNames.length; i++) {
    console.log(`${contractNames[i]} deployed to ${addresses[i]}`);
    deployedAddresses[contractNames[i]] = addresses[i];
  }
  
  // Save addresses to a file for future reference
  fs.writeFileSync(
    "deployed-addresses.json",
    JSON.stringify(deployedAddresses, null, 2)
  );
  
  console.log("All contracts deployed successfully!");
  console.log("Contract addresses saved to deployed-addresses.json");
  
  // Optional verification
  if (process.env.VERIFY === "true") {
    console.log("Verifying contracts on explorer...");
    // Registry verification
    await hre.run("verify:verify", {
      address: await registryContract.getAddress(),
      constructorArguments: [wallet.address],
    });
    
    console.log("Verification completed!");
  }
  
  return {
    registry: await registryContract.getAddress(),
    addresses: deployedAddresses
  };
};