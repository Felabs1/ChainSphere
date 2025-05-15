import Safe from '@safe-global/protocol-kit'
import { sepolia } from 'viem/chains'
import SafeApiKit from '@safe-global/api-kit'
import {
  MetaTransactionData,
  OperationType
} from '@safe-global/types-kit'

const SAFE_ADDRESS = ""

const OWNER_1_ADDRESS = ""
const OWNER_1_PRIVATE_KEY = ""


const RPC_URL = sepolia.rpcUrls.default.http[0];






const SIGNER_PRIVATE_KEY = "6f9ac313b876c0e91c317ae47ea4daa1b9207698b9efe036fd2f1f5efb843643";
const safeAccountConfig = {
  owners: ["0x53f6AFc6f3CaA1303517c04C3a4b820ac1779Dc3"],
  threshold: 1
  // More optional properties
}

const safeDeploymentConfig = {
  saltNonce: Math.floor(Math.random() * 1000000)
}

const predictedSafe= {
  safeAccountConfig,
  safeDeploymentConfig // Optional
  // More optional properties
}

const getSafeAddress = async() => {
  const protocolKit = await Safe.init({
    provider: sepolia.rpcUrls.default.http[0],
    signer: SIGNER_PRIVATE_KEY,
    
    predictedSafe
  })
  return await protocolKit.getAddress();
}



export async function predictSafeAddress() {
  const protocolKit = await Safe.init({
    provider: sepolia.rpcUrls.default.http[0],
    signer: SIGNER_PRIVATE_KEY,
    
    predictedSafe
  })

  const safeAddress = await protocolKit.getAddress();
  console.log(safeAddress);

  const deploymentTransaction = await protocolKit.createSafeDeploymentTransaction()
  console.log(deploymentTransaction)

  console.log("executing transaction")
  const client = await protocolKit.getSafeProvider().getExternalSigner()

const transactionHash = await client.sendTransaction({
  to: deploymentTransaction.to,
  value: BigInt(deploymentTransaction.value),
  data: deploymentTransaction.data,
  chain: sepolia
})

console.log(transactionHash)

// const transactionReceipt = await client.waitForTransactionReceipt({
//   hash: transactionHash
// })

// console.log(transactionReceipt)




  
}

export async function generateAccount() {
  const protocolKit = await Safe.init({
    provider: sepolia.rpcUrls.default.http[0],
    signer: SIGNER_PRIVATE_KEY,
    
    predictedSafe
  })
  const safeAddress = await protocolKit.getAddress();
  console.log(safeAddress);
}

export async function reinitializeProtocolKit() {

  console.log("reinitializing new protocol kit")
  

  const protocolKit = await Safe.init({
    provider: sepolia.rpcUrls.default.http[0],
    signer: SIGNER_PRIVATE_KEY,
    predictedSafe
  })



 
  const newProtocolKit = await protocolKit.connect({
    safeAddress: (await getSafeAddress()).toString(),
  })

  const safeAddress = await newProtocolKit.getAddress()

  
  const isSafeDeployed = await newProtocolKit.isSafeDeployed() // True
  const safeOwners = await newProtocolKit.getOwners()
  const safeThreshold = await newProtocolKit.getThreshold()

  console.log("safe deployed", isSafeDeployed)
  console.log("safe address" , safeAddress);
  console.log("safe owners", safeOwners);
  console.log("Safe threshhold", safeThreshold);
  
}


const executeTransaction = async () => {
  const protocolKitOwner1 = await Safe.init({
    provider: RPC_URL,
    signer: OWNER_1_PRIVATE_KEY,
    safeAddress: SAFE_ADDRESS,
  
  })
  
}


