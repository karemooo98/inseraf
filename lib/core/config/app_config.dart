class AppConfig {
  AppConfig._();

  /// Base URL for the Attendance API.
  static const String baseUrl = 'https://api.wsl-hr.cloud';

  /// Default connection timeout for all HTTP calls.
  static const Duration connectionTimeout = Duration(seconds: 25);

  /// Default read timeout for all HTTP calls.
  static const Duration receiveTimeout = Duration(seconds: 25);
}




