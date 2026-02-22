/// Exception thrown when a server request fails.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode)';
}

/// Exception thrown when a local cache operation fails.
class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException(message: $message)';
}
