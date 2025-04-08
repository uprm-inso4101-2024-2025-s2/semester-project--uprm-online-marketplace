import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter/gestures.dart';

void main() {
  // Entry point to application.
  runApp(SignInPage());
}

class SignInPage extends StatelessWidget {
  // Root widget of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: "Sign In",
      home: SignIn(),
    );
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          TextInputEmail(),
          TextInputPassword(),
          SignInButton(),
          ForgotPasswordLink(),
        ],
      ),
    );
  }
}

class TextInputEmail extends StatefulWidget {
  const TextInputEmail({super.key});

  @override
  State<TextInputEmail> createState() => _TextInputEmailState();
}

class _TextInputEmailState extends State<TextInputEmail> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(label: Text("Email/Username")),
    );
  }
}

class TextInputPassword extends StatefulWidget {
  const TextInputPassword({super.key});

  @override
  State<TextInputPassword> createState() => _TextInputPasswordState();
}

class _TextInputPasswordState extends State<TextInputPassword> {
  @override
  Widget build(BuildContext context) {
    return TextField(decoration: InputDecoration(label: Text("Password")));
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text("Sign In"));
  }
}

class ForgotPasswordLink extends StatefulWidget {
  const ForgotPasswordLink({super.key});

  @override
  State<ForgotPasswordLink> createState() => _ForgotPasswordLinkState();
}

class _ForgotPasswordLinkState extends State<ForgotPasswordLink> {
  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse('https://uprm.edu'),
      builder: (context, followLink) {
        return RichText(
          text: TextSpan(
            text: "Forgot Password",
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        );
      },
    );
  }
}
