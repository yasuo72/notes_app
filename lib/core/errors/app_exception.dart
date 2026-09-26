/// Custom typed exception for unified error handling across the application.
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Thrown when local SQLite database operations fail.
class AppDatabaseException extends AppException {
  const AppDatabaseException(super.message, {super.originalError})
      : super(code: 'DATABASE_ERROR');
}

/// Thrown when note validation fails (empty title/content).
class ValidationException extends AppException {
  const ValidationException(super.message)
      : super(code: 'VALIDATION_ERROR');
}

/// Thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException(super.message)
      : super(code: 'NOT_FOUND');
}
