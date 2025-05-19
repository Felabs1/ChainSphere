import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { predictSafeAddress, reinitializeProtocolKit, generateAccount, executeLensTransaction } from './utils/lens'
import './App.css'
import { ConnectButton, TransactionButton,useActiveAccount } from "thirdweb/react";
import { client } from './client'
import { wallets } from './components/Third'
import { CounterDisplay, DecrementButton, IncrementButton } from './components/ContractInteraction'

function App() {
 

  return (
    <>
      
      <button onClick={predictSafeAddress}> click me</button>
      <button onClick={reinitializeProtocolKit}> execute transaction</button>
      <button onClick={executeLensTransaction}>lens transaction execution</button>
       <ConnectButton client={client} wallets={wallets} />
       <IncrementButton />
       <DecrementButton />
       <CounterDisplay />
    </>
  )
}

export default App
