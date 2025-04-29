import 'package:flutter/material.dart';

//Our Format for our TextField (Where we write)

//When we need a textfield we use this

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? labelText;
  final TextStyle? labelStyle;
  final FormFieldValidator<String>? validator;

  const MyTextfield({
    //my parameters for my class
    super.key,
    this.labelText,
    this.labelStyle,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        // for it to fit good on the screen
        horizontal: 25.0,
      ),

      child: TextFormField(
        obscureText: obscureText,
        //is a bool , we need it as a variable because we don't one every single textbox to be hidden , just like HintText
        controller: controller,
        // for us to access what they write on the TextBox
        focusNode: focusNode,
        decoration: InputDecoration(
          //Lets me Decorate our TextField
          enabledBorder: OutlineInputBorder(
            //Focuses on Border when not typing
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            //When Typing
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          //For every border have the same thing
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          labelText: labelText,
          labelStyle: labelStyle,
        ),
        validator: this.validator,
      ),
    );
  }
}
