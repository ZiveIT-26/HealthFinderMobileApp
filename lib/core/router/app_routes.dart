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
}
