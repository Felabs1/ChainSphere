import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { predictSafeAddress, reinitializeProtocolKit, generateAccount } from './utils/lens'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      
      <button onClick={predictSafeAddress}> click me</button>
      <button onClick={reinitializeProtocolKit}> execute transaction</button>
    </>
  )
}

export default App
