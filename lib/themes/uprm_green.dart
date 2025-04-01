import 'package:flutter/material.dart';

//variable for theme , for excess usage of colors

ThemeData greenMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.green.shade300,
    primary: const Color.fromARGB(255, 7, 92, 10),
    secondary: Colors.green.shade200,
    tertiary: Colors.green.shade100,
    inversePrimary: Colors.green.shade900,
  ),
);
