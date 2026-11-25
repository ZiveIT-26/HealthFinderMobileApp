/// "lina.dev@gmail.com" -> "li***v@gmail.com": the start and the end of the
/// name before "@", the domain in full.
String maskEmail(String email) {
  final at = email.lastIndexOf('@');
  if (at <= 0) return email;
  final name = email.substring(0, at);
  final domain = email.substring(at);
  if (name.length <= 2) return '${name[0]}***$domain';
  return '${name.substring(0, 2)}***${name[name.length - 1]}$domain';
}
