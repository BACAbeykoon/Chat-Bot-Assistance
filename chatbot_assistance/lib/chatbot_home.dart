import 'package:flutter/material.dart';

class ChatbotHome extends StatefulWidget {
  const ChatbotHome({super.key});

  @override
  State<ChatbotHome> createState() => _ChatbotHomeState();
}

class _ChatbotHomeState extends State<ChatbotHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("My Assistence")));
  }
}
