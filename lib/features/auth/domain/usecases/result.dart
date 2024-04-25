class Result<T> {
  final T value;
  final int statusCode;
  final Object? error;

  const Result({
    required this.value,
    required this.statusCode,
    this.error,
  });

  bool get hasError => statusCode != 200;
}
