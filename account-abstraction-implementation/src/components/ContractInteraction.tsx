// counter.ts - Contract Interaction Adapter for Counter Contract
import { client } from "../client";
import { getContract, prepareContractCall, sendTransaction } from "thirdweb";
import React from "react";
import { TransactionButton, useReadContract, useSendAndConfirmTransaction } from "thirdweb/react";
import { lensTestnet } from "./Third";

// Define the contract
export const counterContract = getContract({
  address: "0x78830168bB80d240714C58b623451E898DA0f086",
  chain: lensTestnet,
  client,
});

export const PostManagementContract = getContract({
    address: "0x9D96B5421b4c14A795A21AB1200f36469454c48b",
    chain: lensTestnet,
    client,
})
// Contract read function for getCount
export function getCountCall() {
  return {
    contract: counterContract,
    method: "function getCount() view returns (uint256)",
    params: [] // Adding empty params array to satisfy TypeScript
  };
}

export function createPostCall(content: string, images: string) {
  console.log("Preparing createPost call with:", { content, images });
  
    return prepareContractCall({
        contract: PostManagementContract,
        method:     {
      inputs: [
        {
          internalType: "string",
          name: "content",
          type: "string"
        },
        {
          internalType: "string",
          name: "images",
          type: "string"
        }
      ],
      name: "createPost",
      output: [],
      stateMutability: "nonpayable",
      type: "function"
    },
        params: [content, images],
        maxPriorityFeePerGas: 5000000000n, // 2 gwei
    })
}

export function CreatePostButton({ content, images }: { content: string, images: string }) {
  return (
    <TransactionButton
      transaction={() => createPostCall(content, images)}
      onError={(error) => {
        console.error("Post creation failed:", error);
        // You can add custom error handling here
      }}
    >
      Create Post
    </TransactionButton>
  );
}

// Contract write function for increment
export function incrementCall() {
  return prepareContractCall({
    contract: counterContract,
    method: "function increment()"
  });
}

// Contract write function for decrement
export function decrementCall() {
  return prepareContractCall({
    contract: counterContract,
    method: "function decrement()"
  });
}

// React components for interacting with the counter
export function CounterDisplay() {
  const { data: count, isLoading, error } = useReadContract(getCountCall());
  
  if (isLoading) return <div>Loading counter value...</div>;
  if (error) return <div>Error: {error.message}</div>;
  
  return <div>Current Count: {count?.toString()}</div>;
}

export function IncrementButton() {
  return (
    <TransactionButton
      transaction={() => incrementCall()}
    >
      Increment
    </TransactionButton>
  );
}

export function DecrementButton() {
  return (
    <TransactionButton
      transaction={() => decrementCall()}
    >
      Decrement
    </TransactionButton>
  );
}

// Usage example with hooks
export function CounterExample() {
  const { data: count } = useReadContract(getCountCall());
  const { mutateAsync: sendTx } = useSendAndConfirmTransaction();
  
  return (
    <div>
      <h2>Counter Value: {count?.toString()}</h2>
      <button onClick={() => sendTx(incrementCall())}>Increment</button>
      <button onClick={() => sendTx(decrementCall())}>Decrement</button>
    </div>
  );
}