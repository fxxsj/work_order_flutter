import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/models/api_response.dart';

/// Mock Dio for testing HTTP layer.
///
/// Usage:
/// ```dart
/// final mockDio = MockDioClient();
/// mockDio.stubGet('/api/test', ApiResponse(success: true, data: [...]));
/// // Use mockDio in your test
/// ```
class MockDioClient {
  final List<_MockHandler> _handlers = [];

  Dio get dio => _createMockDio();

  void stubGet(String path, ApiResponse response) {
    _handlers.add(_MockHandler('GET', path, response));
  }

  void stubPost(String path, ApiResponse response) {
    _handlers.add(_MockHandler('POST', path, response));
  }

  void stubPut(String path, ApiResponse response) {
    _handlers.add(_MockHandler('PUT', path, response));
  }

  void stubPatch(String path, ApiResponse response) {
    _handlers.add(_MockHandler('PATCH', path, response));
  }

  void stubDelete(String path, ApiResponse response) {
    _handlers.add(_MockHandler('DELETE', path, response));
  }

  void stubError(String path, String method, int statusCode, String message) {
    final response = ApiResponse(
      success: false,
      message: message,
      code: statusCode,
    );
    _handlers.add(
      _MockHandler(
        method.toUpperCase(),
        path,
        response,
        error: true,
        statusCode: statusCode,
      ),
    );
  }

  Dio _createMockDio() {
    final dio = Dio();
    dio.httpClientAdapter = _MockHttpClientAdapter(this);
    return dio;
  }

  _MockHandler? getHandler(String method, String path) {
    for (final handler in _handlers) {
      if (handler.method == method && path.startsWith(handler.path)) {
        return handler;
      }
    }
    return null;
  }
}

class _MockHandler {
  final String method;
  final String path;
  final ApiResponse response;
  final bool error;
  final int? statusCode;

  _MockHandler(this.method, this.path, this.response,
      {this.error = false, this.statusCode});
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  final MockDioClient _mockClient;

  _MockHttpClientAdapter(this._mockClient);

  @override
  Future<ResponseBody> fetch(
    RequestOptions requestOptions,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final handler = _mockClient.getHandler(
      requestOptions.method,
      requestOptions.uri.path,
    );

    if (handler == null) {
      return ResponseBody.fromString(
        jsonEncode({'success': false, 'message': 'No mock handler'}),
        404,
      );
    }

    if (handler.error) {
      return ResponseBody.fromString(
        jsonEncode({
          'success': false,
          'message': handler.response.message,
          'code': handler.statusCode.toString(),
        }),
        handler.statusCode ?? 500,
      );
    }

    return ResponseBody.fromString(
      jsonEncode({
        'success': handler.response.success,
        'data': handler.response.data,
        'message': handler.response.message,
        'code': handler.response.code,
      }),
      200,
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Creates a successful ApiResponse.
ApiResponse successApiResponse({dynamic data, String? message}) {
  return ApiResponse(
    success: true,
    data: data,
    message: message,
  );
}

/// Creates an error ApiResponse.
ApiResponse errorApiResponse({String? message, int? code}) {
  return ApiResponse(
    success: false,
    message: message ?? 'Error',
    code: code,
  );
}
