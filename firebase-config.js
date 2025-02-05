// Import Firebase modules
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.2.0/firebase-app.js";
//import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.2.0/firebase-analytics.js"; (could use in the future, don't think it's necessary now)
//Our Firebase configuration
  const firebaseConfig = {
    apiKey: "AIzaSyBqajpsar7nw9tlbDNRu13505v-PaeC0os",
    authDomain: "online-market-f5c9f.firebaseapp.com",
    projectId: "online-market-f5c9f",
    storageBucket: "online-market-f5c9f.firebasestorage.app",
    messagingSenderId: "771212475650",
    appId: "1:771212475650:web:b1748012b5d858873cd61b",
    measurementId: "G-WNKC1KHM1R"
  };
// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);