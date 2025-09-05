import 'package:flutter/material.dart';
import 'package:ecopraia/theme.dart';
import 'package:ecopraia/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praia+Segura',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const PraiaMaisSeguraApp(),
    );
  }
}
