import { inAppWallet } from "thirdweb/wallets";
import { claimTo } from "thirdweb/extensions/erc1155";
import { ConnectButton, TransactionButton } from "thirdweb/react";
import {defineChain } from "thirdweb/chains";
import { client } from "../client";

export const lensTestnet = defineChain({
  id: 37111,
  name: "Lens Testnet",
  nativeCurrency: {
    name: "GRASS",
    symbol: "GRASS",
    decimals: 18
  },
  rpc: "https://37111.rpc.thirdweb.com", 
  blockExplorers: [
    {
      name: "Lens BlockExplorer",
      url: "https://explorer.staging.lens.zksync.dev/"
      // apiUrl is optional, so we can omit it
    }
  ],
  testnet: true
});

export const wallets = [
  inAppWallet({
    // turn on gas sponsorship for in-app wallets
    // Can use EIP4337 or EIP7702 on supported chains
    executionMode: {
      mode: "EIP4337",
      smartAccount: { chain: lensTestnet, sponsorGas: true },
    },
  }),
];

