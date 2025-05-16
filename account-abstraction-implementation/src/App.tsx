import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { predictSafeAddress, reinitializeProtocolKit, generateAccount, executeLensTransaction } from './utils/lens'
import './App.css'
import { testDeploy, testLens } from './utils/lensP'
import { ConnectButton, TransactionButton } from "thirdweb/react";
import { client } from './client'
import { wallets } from './components/Third'

function App() {
 

  return (
    <>
      
      <button onClick={predictSafeAddress}> click me</button>
      <button onClick={reinitializeProtocolKit}> execute transaction</button>
      <button onClick={executeLensTransaction}>lens transaction execution</button>
      <button onClick={testLens}>lens account</button>

      <button onClick={testDeploy}>lens connect</button>

       <ConnectButton client={client} wallets={wallets} />
    </>
  )
}

export default App
