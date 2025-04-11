import 'package:flutter/material.dart';
import 'package:semesterprojectuprmonlinemarketplace/src/constants/text.dart';

/* -- This file contain all buttons used in login. --
* Add additional buttons at the bottom.
* */

// Forgot Password Text Button
class ForgotPasswordBtn extends StatefulWidget {
  const ForgotPasswordBtn({super.key});

  @override
  State<ForgotPasswordBtn> createState() =>
      _ForgotPasswordBtnState();
}

class _ForgotPasswordBtnState extends State<ForgotPasswordBtn> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(t_ForgotPassword),
    );
  }
}

// Sign In Elevated Button - All Caps
class SignInBtn extends StatefulWidget {
  const SignInBtn({super.key});

  @override
  State<SignInBtn> createState() => _SignInBtnState();
}

class _SignInBtnState extends State<SignInBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(t_SignInBtn),
    );
  }
}
