import Safe, { type PredictedSafeProps, type SafeDeploymentConfig } from '@safe-global/protocol-kit'
import { sepolia } from 'viem/chains'
import SafeApiKit from '@safe-global/api-kit'
import {
  MetaTransactionData,
  OperationType
} from '@safe-global/types-kit'

const SAFE_ADDRESS = "0x40409922a31C0F9ab78Aab27312d609aaD30Ef51"

const OWNER_1_ADDRESS = "0x53f6AFc6f3CaA1303517c04C3a4b820ac1779Dc3"
const OWNER_1_PRIVATE_KEY = "6f9ac313b876c0e91c317ae47ea4daa1b9207698b9efe036fd2f1f5efb843643"


const RPC_URL = sepolia.rpcUrls.default.http[0];






const SIGNER_PRIVATE_KEY = "6f9ac313b876c0e91c317ae47ea4daa1b9207698b9efe036fd2f1f5efb843643";
const safeAccountConfig = {
  owners: ["0x53f6AFc6f3CaA1303517c04C3a4b820ac1779Dc3"],
  threshold: 1
  // More optional properties
}

const safeDeploymentConfig:  SafeDeploymentConfig = {
  saltNonce: Math.floor(Math.random() * 1000000).toString()
}

const predictedSafe: PredictedSafeProps= {
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

  if (!client) return;

  const transactionHash = await client.sendTransaction({
    to: deploymentTransaction.to,
    value: BigInt(deploymentTransaction.value),
    data: deploymentTransaction.data as `0x${string}`,
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


export const executeLensTransaction = async () => {
  const protocolKitOwner1 = await Safe.init({
    provider: RPC_URL,
    signer: OWNER_1_PRIVATE_KEY,
    safeAddress: SAFE_ADDRESS,
  
  })

  const safeTransactionData: MetaTransactionData = {
    to: '0xF3bAAfEEFebCC23A9D87118Aa3D96D1bADCC6daB',
    value: '1000', // 1 wei
    data: '0x',
    operation: OperationType.Call
  }
  
  const safeTransaction = await protocolKitOwner1.createTransaction({
    transactions: [safeTransactionData]
  })

  const apiKit = new SafeApiKit({
    chainId: 11155111n
  })

  // Deterministic hash based on transaction parameters
const safeTxHash = await protocolKitOwner1.getTransactionHash(safeTransaction)

// Sign transaction to verify that the transaction is coming from owner 1
const senderSignature = await protocolKitOwner1.signHash(safeTxHash)

await apiKit.proposeTransaction({
  safeAddress: SAFE_ADDRESS,
  safeTransactionData: safeTransaction.data,
  safeTxHash,
  senderAddress: OWNER_1_ADDRESS,
  senderSignature: senderSignature.data
})

const pendingTransactions = (await apiKit.getPendingTransactions(SAFE_ADDRESS)).results
console.log("Pending transactions: ", pendingTransactions);


const executeTxResponse = await protocolKitOwner1.executeTransaction(safeTransaction)
console.log(executeTxResponse);


  
  
}


