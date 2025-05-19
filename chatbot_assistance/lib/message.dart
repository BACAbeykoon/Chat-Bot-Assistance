import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Message Bubble")));
  }
}
