/// Mock clinic details until the backend is ready.
library;

class OpeningHours {
  const OpeningHours(this.days, this.time);

  final String days;
  final String time;
}

class ClinicDetails {
  const ClinicDetails({
    required this.id,
    required this.kicker,
    required this.name,
    required this.doctor,
    required this.about,
    required this.address,
    required this.phone,
    required this.email,
    required this.openingHours,
    required this.sourceLabel,
    required this.sourceHint,
  });

  final String id;
  final String kicker;
  final String name;
  final String doctor;
  final String about;
  final String address;
  final String phone;
  final String email;
  final List<OpeningHours> openingHours;
  final String sourceLabel;
  final String sourceHint;
}

abstract final class ClinicMockData {
  static const _clinics = {
    'neurol-emg': ClinicDetails(
      id: 'neurol-emg',
      kicker: 'Neurology · Outpatient clinic',
      name: 'Neurol.EMG s.r.o.',
      doctor: 'MUDr. Viliam Korenko · Neurologist',
      about: 'Specialist outpatient neurology practice in Košice-Sever. '
          'Contact the clinic to confirm available services and referral requirements.',
      address: 'Národná trieda 214/27\nKošice-Sever, Slovakia',
      phone: '+421 948 927 852',
      email: 'neurolemgvk@gmail.com',
      openingHours: [
        OpeningHours('Monday', '10:00–16:00'),
        OpeningHours('Tuesday', '07:00–13:00'),
        OpeningHours('Wednesday', '07:00–13:00'),
        OpeningHours('Thursday', '07:00–13:00'),
        OpeningHours('Friday', '07:00–13:00'),
        OpeningHours('Saturday / Sunday', 'Closed'),
      ],
      sourceLabel: 'View the official e-VÚC listing ↗',
      sourceHint: 'Published opening hours and contact details can change. '
          'Confirm directly with the clinic.',
    ),
  };

  /// Returns the clinic by id, or the first mock clinic for unknown ids.
  static ClinicDetails byId(String id) => _clinics[id] ?? _clinics.values.first;
}
