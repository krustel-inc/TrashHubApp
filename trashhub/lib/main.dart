import 'package:flutter/material.dart';
import 'package:trashhub/trashhub.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color(0xFF4CAF50), // Green
      // Light Green
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 9, 91, 11),
        ),
      ),
    ),
    home: const TrashHub(),
  ));
}
