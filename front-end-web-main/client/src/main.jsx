import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { ThirdwebProvider } from "thirdweb/react";
import { Web3Provider } from "./pages/Web3Provider";


ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
     <Web3Provider>
    <ThirdwebProvider>
      <App />

    </ThirdwebProvider>
    </Web3Provider>
  </React.StrictMode>
);
