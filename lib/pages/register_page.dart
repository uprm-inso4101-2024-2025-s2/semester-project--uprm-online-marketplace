import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/services/auth/auth_service.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_button.dart';
import 'package:semesterprojectuprmonlinemarketplace/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;
  bool showEmailCriteria = true;
  bool showPasswordCriteria = true;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isPasswordVisible = false;

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|mac\.com|me\.com|[a-zA-Z0-9.-]+\.edu)$",
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final RegExp passwordRegex = RegExp(r"^(?=.*[0-9])(?=.*[A-Z]).{8,}$");
    return passwordRegex.hasMatch(password);
  }

  void signUp() async {
    setState(() => isLoading = true);

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    // String role = "Student"; // Temporarily hardcoded

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      setState(() {
        errorMessage = "All fields are required!";
        isLoading = false;
      });
      return;
    }

    setState(() {
      isEmailValid = isValidEmail(email);
      isPasswordValid = isValidPassword(password);
    });

    if (!isEmailValid) {
      setState(() {
        errorMessage =
            "Invalid email format! Input a supported email provider.";
        isLoading = false;
      });
      return;
    }

    if (!isPasswordValid) {
      setState(() {
        errorMessage =
            "Password must be at least 8 characters, include a number and uppercase letter.";
        isLoading = false;
      });
      return;
    }

    try {
      String? user = await authService.signUpWithEmailPassword(email, password);
      if (user != null) {
        // Navigate to home/profile page after successful sign-up
      } else {
        setState(() {
          errorMessage = "Sign-Up Failed. Try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Email input
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),
            if (showEmailCriteria)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your email must end in:"),
                    Text("• @gmail.com"),
                    Text("• @hotmail.com"),
                    Text("• .edu"),
                    Text("• @mac.com"),
                    Text("• @me.com"),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Password input
            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),
            if (showPasswordCriteria)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Password must contain:"),
                    Text("• At least 8 characters"),
                    Text("• At least one number"),
                    Text("• At least one uppercase letter"),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // Username input
            MyTextfield(
              hintText: "Username",
              obscureText: false,
              controller: usernameController,
            ),
            const SizedBox(height: 20),

            // Sign Up button
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : MyButton(
                  text: "Sign Up",
                  onTap: signUp, // This directly calls the sign-up logic
                ),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 25),

            // Go to Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: widget.onTap, // This toggles back to the LoginPage
                  child: const Text(
                    "Login Now",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
