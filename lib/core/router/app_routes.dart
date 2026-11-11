/// Шляхи всіх екранів в одному місці, щоб не писати рядки вручну.
abstract final class AppRoutes {
  static const home = '/home';
  static const chat = '/chat';
  static const profile = '/profile';

  static String clinicDetails(String clinicId) => '/chat/clinic/$clinicId';
  static const medicalCard = '/profile/medical-card';
}
