import 'package:http/http.dart' as http;

/// HTTP client that adds `Authorization: Bearer <token>` to every request
/// and reports 401 responses, like an axios interceptor.
class AuthorizedClient extends http.BaseClient {
  AuthorizedClient({
    required this.token,
    required this.onUnauthorized,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  /// Current backend token, read at send time.
  final String? Function() token;

  /// Called with the token that was rejected.
  final void Function(String rejectedToken) onUnauthorized;

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final current = token();
    if (current != null) {
      request.headers['Authorization'] = 'Bearer $current';
    }

    final response = await _inner.send(request);
    if (response.statusCode == 401 && current != null) {
      onUnauthorized(current);
    }
    return response;
  }

  @override
  void close() => _inner.close();
}
