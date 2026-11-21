// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// import 'chat_composer.dart';

// /// Example: how a screen owns the speech recognition and feeds the composer.
// /// Needs `speech_to_text` in pubspec.yaml plus platform permissions
// /// (see notes in the chat reply).
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _controller = TextEditingController();
//   final _speech = SpeechToText();

//   bool _speechReady = false;
//   bool _listening = false;

//   /// Text that was already in the field when recording started, so the
//   /// recognized words are appended instead of replacing it.
//   String _textBeforeListening = '';

//   @override
//   void initState() {
//     super.initState();
//     _initSpeech();
//   }

//   Future<void> _initSpeech() async {
//     final ready = await _speech.initialize(
//       onStatus: (status) {
//         // Recognition can stop by itself (silence timeout).
//         if (!mounted) return;
//         if (status == 'done' || status == 'notListening') {
//           setState(() => _listening = false);
//         }
//       },
//       onError: (_) {
//         if (mounted) setState(() => _listening = false);
//       },
//     );
//     if (mounted) setState(() => _speechReady = ready);
//   }

//   Future<void> _toggleVoice() async {
//     if (_listening) {
//       await _speech.stop();
//       if (mounted) setState(() => _listening = false);
//       return;
//     }

//     _textBeforeListening = _controller.text.trim();
//     setState(() => _listening = true);

//     await _speech.listen(
//       // localeId: 'en_US', // set this if your app isn't English-only
//       onResult: (result) {
//         final spoken = result.recognizedWords;
//         final text = _textBeforeListening.isEmpty
//             ? spoken
//             : '$_textBeforeListening $spoken';
//         _controller.value = TextEditingValue(
//           text: text,
//           selection: TextSelection.collapsed(offset: text.length),
//         );
//       },
//     );
//   }

//   void _handleSend(String text) {
//     // TODO: send the message to your chat logic.
//   }

//   @override
//   void dispose() {
//     _speech.cancel();
//     _controller.dispose(); // we created it, so we dispose it
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const Expanded(child: SizedBox()), // message list goes here
//           ChatComposer(
//             controller: _controller,
//             onSend: _handleSend,
//             // null hides the mic when speech isn't available or permission was denied
//             onVoiceTap: _speechReady ? _toggleVoice : null,
//             isListening: _listening,
//           ),
//         ],
//       ),
//     );
//   }
// }