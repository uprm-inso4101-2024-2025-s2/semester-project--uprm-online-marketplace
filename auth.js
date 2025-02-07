import { auth } from "./firebase-config.js";
import { 
    signInWithEmailAndPassword, 
    createUserWithEmailAndPassword, 
    signOut 
} from "https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js";

// Login
document.getElementById("loginForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    signInWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            alert("Login successful!");
            console.log(userCredential.user);
        })
        .catch((error) => {
            alert("Login failed: " + error.message);
        });
});

// Register
document.getElementById("registerForm").addEventListener("submit", (e) => {
    e.preventDefault();
    const email = document.getElementById("regEmail").value;
    const password = document.getElementById("regPassword").value;

    createUserWithEmailAndPassword(auth, email, password)
        .then((userCredential) => {
            alert("Registration successful!");
            console.log(userCredential.user);
        })
        .catch((error) => {
            alert("Registration failed: " + error.message);
        });
});

// Logout
document.getElementById("logout").addEventListener("click", () => {
    signOut(auth)
        .then(() => {
            alert("Logged out!");
        })
        .catch((error) => {
            alert("Logout failed: " + error.message);
        });
});