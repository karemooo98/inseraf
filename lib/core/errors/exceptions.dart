class ServerException implements Exception {
  ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class CacheException implements Exception {
  CacheException(this.message);

  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}




