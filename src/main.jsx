import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import "./index.css";
import App from "./App.jsx";
import { EditLockProvider } from "./lib/editLock.jsx";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <BrowserRouter>
      <EditLockProvider>
        <App />
      </EditLockProvider>
    </BrowserRouter>
  </StrictMode>
);
