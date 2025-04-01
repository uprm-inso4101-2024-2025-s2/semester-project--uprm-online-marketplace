import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  //Attributes
  final String text;
  final void Function()? onTap; //onTap is a function

  //final int minWitdth;
  //final int maxWidth;

  const MyButton({
    //Contructor
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //purpose of button
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),

        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
