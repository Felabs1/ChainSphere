
import { client } from "../client";
import type { Chain } from "thirdweb";
import { createThirdwebClient, getContract, prepareContractCall, sendTransaction } from "thirdweb";

const lensTestnet: Readonly<Chain & { rpc: string }> = {
  id: 37111,
  name: "Lens Testnet",
  nativeCurrency: {
    name: "GRASS",
    symbol: "GRASS",
    decimals: 18
  },
  rpc: "https://37111.rpc.thirdweb.com", // Make sure this is included
  blockExplorers: {
    default: {
      name: "Lens BlockExplorer",
      url: "https://explorer.staging.lens.zksync.dev/",
      apiUrl: "https://block-explorer-api.staging.lens.dev/api" // Added API URL
    }
  },
  testnet: true
} as const;

async function increaseCounter() {
  try {
    // Get the contract
    const contract = getContract({
      client,
      chain: lensTestnet,
      address: "0xYourCounterContractAddress",
    });

    // Prepare the contract call
    const transaction = await prepareContractCall({
      contract,
      method: "incrementCounter", // The function name in your contract
      params: [], // Any parameters your function takes
    });

    // Send the transaction
    const result = await sendTransaction({
      transaction,
      client,
      account: walletClient,
    });

    console.log("Transaction hash:", result.transactionHash);
    
    return result;
  } catch (error) {
    console.error("Error increasing counter:", error);
    throw error;
  }
}
