/// All route paths in one place, so screens never hardcode strings.
abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const home = '/home';
  static const chat = '/chat';
  static const profile = '/profile';

  static String clinicDetails(String clinicId) => '/chat/clinic/$clinicId';
  static const medicalCard = '/profile/medical-card';
  static const personalInfo = '/profile/personal-info';
  static const settings = '/profile/settings';

  /// Top level, not under /profile: it is opened from the profile and from
  /// the chat, and must return to where it was opened.
  static const homeLocation = '/home-location';
}
