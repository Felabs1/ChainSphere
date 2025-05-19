import { client } from "../client";
import { getContract, prepareContractCall, sendTransaction } from "thirdweb";
import React from "react";
import { TransactionButton, useReadContract, useSendAndConfirmTransaction } from "thirdweb/react";
import { lensTestnet } from "../utils/Third";

// defining the contract

export const PostManagementContract = getContract({
    address: "0x9D96B5421b4c14A795A21AB1200f36469454c48b",
    chain: lensTestnet,
    client,
})


// write function for post
export function createPost(content, images) {

    try {
        return prepareContractCall({
            contract: PostManagementContract,
            method: "function createPost()",
            params: [content, images]
        })
    } catch (e) {
        console.error("some error occured " + e)
    }
    
}