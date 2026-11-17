import 'package:flutter/material.dart';
import '../core/network/chat_api.dart';
import '../core/network/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.baseUrl});
  final String baseUrl;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _controller =
      ChatController(ChatApi(widget.baseUrl));
  final _input = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty || _controller.loading) return;
    _input.clear();
    _controller.send(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HealthFinder')),
      body: SafeArea(
        child: Column(
          children: [
            // Message list: rebuilds whenever the controller calls notifyListeners()
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _controller.messages.length,
                  itemBuilder: (context, i) =>
                      MessageBubble(message: _controller.messages[i]),
                ),
              ),
            ),
            // Input row
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Describe your symptoms...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final waiting = message.text.isEmpty && message.doctors.isEmpty;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? scheme.primaryContainer
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(waiting ? '...' : message.text),
            for (final d in message.doctors)
              Card(
                margin: const EdgeInsets.only(top: 8),
                child: ListTile(
                  title: Text(d.name),
                  subtitle: Text(
                    [
                      d.speciality,
                      d.address,
                      if (d.phone != null) d.phone!,
                    ].join('\n'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}