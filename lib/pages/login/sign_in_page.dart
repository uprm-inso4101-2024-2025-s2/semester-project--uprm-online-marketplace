import 'package:flutter/material.dart';

import '../../components/login_widgets/buttons.dart';
import '../../components/login_widgets/text_fields.dart';
import '../../constants/text.dart';

void main() {
  /*
  * The purpose of this main function is to test the class
  * below SignInPage without depending on other components
  * of the application
  */

  // Entry point to Sign In Page
  runApp(MaterialApp(home: SignInPage()));
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t_SignIn),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          EmailField(),
          PasswordField(),
          ForgotPasswordBtn(),
          SignInBtn(),
        ],
      ),
    );
  }
}
