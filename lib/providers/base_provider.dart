import 'package:flutter/foundation.dart';

enum Status {
  initial,
  loading,
  success,
  error,
}

class BaseProvider extends ChangeNotifier {
  Status _status = Status.initial;
  String? _errorMessage;
  bool _disposed = false;

  Status get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == Status.loading;
  bool get isError => _status == Status.error;
  bool get isSuccess => _status == Status.success;
  bool get isInitial => _status == Status.initial;

  @protected
  void setStatus(Status status) {
    _status = status;
    notifyListeners();
  }

  @protected
  void setError(String message) {
    _status = Status.error;
    _errorMessage = message;
    notifyListeners();
  }

  @protected
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @protected
  Future<T> handleFuture<T>(Future<T> Function() future) async {
    try {
      setStatus(Status.loading);
      final result = await future();
      setStatus(Status.success);
      return result;
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

mixin LoadingMixin on ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @protected
  Future<T> withLoading<T>(Future<T> Function() operation) async {
    try {
      _isLoading = true;
      notifyListeners();
      return await operation();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

mixin ErrorHandlerMixin on ChangeNotifier {
  String? _error;
  String? get error => _error;
  bool get hasError => _error != null;

  @protected
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  @protected
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @protected
  Future<T> handleError<T>(Future<T> Function() operation) async {
    try {
      clearError();
      return await operation();
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }
}

mixin DisposableMixin on ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
