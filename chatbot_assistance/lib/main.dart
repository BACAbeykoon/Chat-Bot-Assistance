import 'package:chatbot_assistance/chatbot_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MychatbotApp());
}

class MychatbotApp extends StatelessWidget {
  const MychatbotApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Chat-Bot Assistance',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 38, 129, 240),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 38, 129, 240),
        ),
      ),
      home: const ChatbotHome(),
    );
  }
}
