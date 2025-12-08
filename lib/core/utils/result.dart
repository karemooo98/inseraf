class Result<T> {
  Result._(this._data, this._error);

  factory Result.success(T data) => Result<T>._(data, null);

  factory Result.failure(Exception error) => Result<T>._(null, error);

  static Future<Result<R>> guard<R>(Future<R> Function() operation) async {
    try {
      final R data = await operation();
      return Result<R>.success(data);
    } catch (error) {
      if (error is Exception) {
        return Result<R>.failure(error);
      }
      return Result<R>.failure(Exception(error.toString()));
    }
  }

  final T? _data;
  final Exception? _error;

  bool get isSuccess => _error == null;

  T get data {
    if (_data == null) {
      throw StateError('Result does not contain data. Check isSuccess before accessing data.');
    }
    return _data as T;
  }

  Exception? get error => _error;
}

