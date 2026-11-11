import 'package:flutter/material.dart';
import 'chat/chat_screen.dart';

// Choose the right one for how you run the app (see Step 8)
const apiUrl = 'http://10.0.2.2:3000';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthFinder',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const ChatScreen(baseUrl: apiUrl),
    );
  }
}