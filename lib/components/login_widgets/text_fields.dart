import 'package:flutter/material.dart';

import '../../constants/text.dart';

/* -- This file contain all text fields used in login. --
* Add additional fields at the bottom.
* */

// Email Text Form Field
class EmailField extends StatefulWidget {
  const EmailField({super.key});

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: t_Email,
        hintText: t_Email,
      ),
    );
  }
}

// Password Text Form Field
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: t_Password,
        hintText: t_Password,
        suffixIcon: IconButton(
          onPressed: null,
          icon: Icon(Icons.remove_red_eye_sharp),
        ),
      ),
    );
  }
}
