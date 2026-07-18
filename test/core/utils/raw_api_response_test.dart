import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/utils/raw_api_response.dart';

void main() {
  group('requireRawApiResponseData', () {
    test('unwraps the standard API envelope', () {
      final payload = requireRawApiResponseData(
        label: '上传文件',
        data: {
          'success': true,
          'code': 200,
          'data': {'id': 7, 'file': '/media/file.pdf'},
          'timestamp': '2026-07-18T00:00:00Z',
        },
      );

      expect(payload, {'id': 7, 'file': '/media/file.pdf'});
    });

    test('supports legacy direct map responses', () {
      final payload = requireRawApiResponseData(
        label: '上传文件',
        data: {'id': 7, 'code': 'FILE-007', 'file': '/media/file.pdf'},
      );

      expect(payload['id'], 7);
      expect(payload['code'], 'FILE-007');
    });

    test('preserves the server message for failed envelopes', () {
      expect(
        () => requireRawApiResponseData(
          label: '上传文件',
          data: {
            'success': false,
            'code': 400,
            'message': '文件格式不支持',
            'data': null,
          },
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            '文件格式不支持',
          ),
        ),
      );
    });

    test('rejects an envelope without a map payload', () {
      expect(
        () => requireRawApiResponseData(
          label: '上传文件',
          data: {'success': true, 'code': 200, 'data': null},
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('rejects a non-map response', () {
      expect(
        () => requireRawApiResponseData(label: '上传文件', data: ['unexpected']),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
