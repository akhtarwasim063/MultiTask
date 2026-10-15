class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AppException(this.message, [this.statusCode, this.details]);

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

class RateLimitException extends AppException {
  final int backoffSeconds;

  const RateLimitException(String message, this.backoffSeconds)
      : super(message, 429);
}

class OfflineException extends AppException {
  const OfflineException([String message = 'Device is offline or host unreachable'])
      : super(message, 0);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Invalid or missing API Key'])
      : super(message, 401);
}
