import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_services.dart';
//import '../../home_page.dart'; // Once succesfull sigh-up where the user should be sent
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
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
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@(gmail\.com|hotmail\.com|mac\.com|me\.com|[a-zA-Z0-9.-]+\.edu)$");
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
    String role = "Student";//auth_service added a role parameter. Signup process has yet to incorporate this adition into the code
                            //Made role Student by default until code can be updated. Comment made by Jayson D. Perez Ramirez

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
        errorMessage = "Invalid email format! Input a supported email provider.";
        isLoading = false;
      });
      return;
    }

    if (!isPasswordValid) {
      setState(() {
        errorMessage = "Password must be at least 8 characters long, contain a number and an uppercase letter.";
        isLoading = false;
      });
      return;
    }

    try {
      String? user = (await authService.signUp(email, password, username, role));

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: isEmailValid ? Colors.green : 
                    (emailController.text.isEmpty ? Colors.grey : Colors.red)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      isEmailValid = isValidEmail(value);
                    });
                  },
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
                        Text("Your email must end in the formats:"),
                        Text("• @gmail.com"),
                        Text("• @hotmail.com"),
                        Text("• .edu"),
                        Text("• @mac.com"),
                        Text("• @me.com"),
                      ],
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: isPasswordValid ? Colors.green : (
                    passwordController.text.isEmpty ? Colors.grey : Colors.red)),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      isPasswordValid = isValidPassword(value);
                    });
                  },
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
              ],
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: signUp,
                    child: const Text("Sign Up"),
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
          ],
        ),
      ),
    );
  }
}
