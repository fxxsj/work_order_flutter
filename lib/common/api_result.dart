class ApiResult<T> {
  final T? data;
  final String? message;

  const ApiResult({this.data, this.message});
}
