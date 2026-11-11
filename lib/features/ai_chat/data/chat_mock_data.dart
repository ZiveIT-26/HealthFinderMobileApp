/// Mock conversation for the AI chat until the backend is ready.
library;

sealed class ChatMessage {
  const ChatMessage();
}

class UserMessage extends ChatMessage {
  const UserMessage(this.text);

  final String text;
}

class AssistantMessage extends ChatMessage {
  const AssistantMessage({
    required this.paragraphs,
    this.warning,
    this.clinic,
    this.footnote,
  });

  final List<String> paragraphs;
  final ChatWarning? warning;
  final ClinicRecommendation? clinic;
  final String? footnote;
}

/// Highlighted safety note: [title] is bold, [text] follows it.
class ChatWarning {
  const ChatWarning({required this.title, required this.text});

  final String title;
  final String text;
}

class ClinicRecommendation {
  const ClinicRecommendation({
    required this.id,
    required this.category,
    required this.doctor,
    required this.clinic,
    required this.address,
    required this.hours,
    required this.description,
    required this.source,
  });

  final String id; // used in the route: /chat/clinic/:id
  final String category;
  final String doctor;
  final String clinic;
  final String address;
  final String hours;
  final String description;
  final String source;
}

abstract final class ChatMockData {
  static const messages = <ChatMessage>[
    UserMessage("I've had frequent headaches. Which doctor should I see in Košice?"),
    AssistantMessage(
      paragraphs: [
        'For recurring headaches, a general practitioner can help assess your '
            'symptoms and determine whether a specialist visit is appropriate.',
        'Here is a neurological clinic in Košice you can contact. '
            'Confirm referral and appointment requirements directly.',
      ],
      warning: ChatWarning(
        title: 'Seek urgent care',
        text: ' for a sudden severe headache, new weakness, confusion, '
            'or sudden vision changes.',
      ),
      clinic: ClinicRecommendation(
        id: 'neurol-emg',
        category: 'NEUROLOGY · KOŠICE',
        doctor: 'MUDr. Viliam Korenko',
        clinic: 'Neurol.EMG s.r.o. · Neurologist',
        address: 'Národná trieda 27, Košice-Sever',
        hours: 'Mon 10:00–16:00 · Tue–Fri 07:00–13:00',
        description: 'Specialist outpatient neurological care, '
            'including assessment of neurological symptoms.',
        source: 'Source: e-VÚC registry ↗',
      ),
      footnote: 'AI can make mistakes. Verify the clinic details before visiting.',
    ),
  ];
}
