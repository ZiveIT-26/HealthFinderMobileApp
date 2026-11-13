class Doctor {
  final String name, speciality, address, url;
  final String? doctorName, phone, email, additionalInfo;

  Doctor.fromJson(Map<String, dynamic> j)
      : name = j['name'] ?? '',
        doctorName = j['doctorName'],
        speciality = j['speciality'] ?? '',
        address = j['address'] ?? '',
        url = j['url'] ?? '',
        phone = j['phone'],
        email = j['email'],
        additionalInfo = j['additionalInfo'];
}

// One class per kind of SSE event your server sends
sealed class ChatEvent {}

class TokenEvent extends ChatEvent {
  final String text;
  TokenEvent(this.text);
}

class DoctorsEvent extends ChatEvent {
  final List<Doctor> doctors;
  DoctorsEvent(this.doctors);
}

class ErrorEvent extends ChatEvent {
  final String message;
  ErrorEvent(this.message);
}

class HeartbeatEvent extends ChatEvent {}