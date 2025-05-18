import 'package:chatbot_assistance/main.dart';
import 'package:chatbot_assistance/message.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotHome extends StatefulWidget {
  const ChatbotHome({super.key});

  @override
  State<ChatbotHome> createState() => _ChatbotHomeState();
}

class _ChatbotHomeState extends State<ChatbotHome> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [];
  bool _isBotTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MychatbotApp()),
              );
            },
            icon: Icon(Icons.close),
          ),
        ],
        title: Row(
          children: [
            Image.asset('assets/bot_icon.png', height: 30),
            const SizedBox(width: 10),
            Text(
              'M  Assistant',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              padding: const EdgeInsets.only(bottom: 16),
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  message: message,
                ).animate().fadeIn(duration: 200.ms);
              },
            ),
          ),
          if (_isBotTyping) _buildTypingIndicator(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.surface,
        child: TextField(
          controller: _controller,
          style: GoogleFonts.poppins(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Ask me anything...',
            hintStyle: GoogleFonts.poppins(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _handleSend,
            ),
          ),
          onSubmitted: (_) => _handleSend(),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Image.asset('assets/bot_icon.png'),
          ),
          const SizedBox(width: 16),
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    _addMessage(text, true);
    _scrollToBottom();

    setState(() => _isBotTyping = true);
    try {
      final response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );
      if (response.message != null &&
          response.message!.text!.text!.isNotEmpty) {
        _addMessage(response.message!.text!.text![0], false);
      }
    } finally {
      setState(() => _isBotTyping = false);
      _scrollToBottom();
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      messages.add({
        "text": text,
        "isUserMessage": isUser,
        "timestamp": DateTime.now(),
      });
    });
  }
}
