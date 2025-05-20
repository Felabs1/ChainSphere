import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import { predictSafeAddress, reinitializeProtocolKit, generateAccount, executeLensTransaction } from './utils/lens'
import './App.css'
import { ConnectButton, TransactionButton,useActiveAccount } from "thirdweb/react";
import { client } from './client'
import { wallets } from './components/Third'
import { CounterDisplay, CreatePostButton, DecrementButton, IncrementButton } from './components/ContractInteraction'

function App() {
 
  const [content, setContent] = useState("");
  const [images, setImages] = useState("");
  const [isPosting, setIsPosting] = useState(false);
  const [postStatus, setPostStatus] = useState(null);




  return (
    <>
      
      <button onClick={predictSafeAddress}> click me</button>
      <button onClick={reinitializeProtocolKit}> execute transaction</button>
      <button onClick={executeLensTransaction}>lens transaction execution</button>
       <ConnectButton client={client} wallets={wallets} />
       <IncrementButton />
       <DecrementButton />
       <CounterDisplay />
       <div className="post-creation-form">
      <h2>Create New Post</h2>
      
      {/* Post content textarea */}
      <div className="form-field">
        <label htmlFor="postContent">Content</label>
        <textarea
          id="postContent"
          value={content}
          onChange={(e) => setContent(e.target.value)}
          placeholder="What's on your mind?"
          rows={4}
          required
        />
      </div>
      
      {/* Images input */}
      <div className="form-field">
        <label htmlFor="postImages">Images (URLs separated by commas)</label>
        <input
          id="postImages"
          type="text"
          value={images}
          onChange={(e) => setImages(e.target.value)}
          placeholder="https://example.com/image1.jpg, https://example.com/image2.jpg"
        />
      </div>
      
      {/* Status message (success/error) */}
      {postStatus && (
        <div className={`status-message ${postStatus.type}`}>
          {postStatus.message}
        </div>
      )}
      
      {/* Using the CreatePostButton component */}
      <div className="form-actions">
        {content ? (
          <CreatePostButton 
            content={content} 
            images={images}
          />
        ) : (
          <button disabled>Post content required</button>
        )}
      </div>
    </div>
    </>
  )
}

export default App
