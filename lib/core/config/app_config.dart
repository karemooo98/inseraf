class AppConfig {
  AppConfig._();

  /// Base URL for the Attendance API.
  static const String baseUrl = 'http://148.230.108.157:8080';

  /// Default connection timeout for all HTTP calls.
  static const Duration connectionTimeout = Duration(seconds: 25);

  /// Default read timeout for all HTTP calls.
  static const Duration receiveTimeout = Duration(seconds: 25);
}




