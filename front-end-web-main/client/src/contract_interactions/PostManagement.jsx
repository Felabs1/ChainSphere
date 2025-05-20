import { client } from "../client";
import { getContract, prepareContractCall, sendTransaction } from "thirdweb";
import React from "react";
import { TransactionButton, useReadContract, useSendAndConfirmTransaction } from "thirdweb/react";
import { lensTestnet } from "../utils/Third";


// defining the contract

export const PostManagementContract = getContract({
    address: "0x0B200a8fFCF4Ed04F501C0A7df5a2EdB7782475F",
    chain: lensTestnet,
    client,
})

export const counterContract = getContract({
  address: "0x78830168bB80d240714C58b623451E898DA0f086",
  chain: lensTestnet,
  client,
});

export function incrementCall() {
  return prepareContractCall({
    contract: counterContract,
    method: "function increment()"
  });
}

// write function for post
export function createPost(content, images) {

    return prepareContractCall({
        contract: PostManagementContract,
        method: "function createPost(string memory content, string memory images)",
        params: [content, images],
    })

    
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



    // {
    //   inputs: [
    //     {
    //       internalType: "string",
    //       name: "content",
    //       type: "string"
    //     },
    //     {
    //       internalType: "string",
    //       name: "images",
    //       type: "string"
    //     }
    //   ],
    //   name: "createPost",
    //   output: [],
    //   stateMutability: "nonpayable",
    //   type: "function"
    // }