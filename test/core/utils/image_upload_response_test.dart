import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/utils/image_upload_response.dart';

void main() {
  group('requireImageUploadResponseData', () {
    test('returns wrapped data map', () {
      final map = requireImageUploadResponseData(
        label: '上传图片',
        data: {
          'data': {'id': 1, 'image': '/media/a.jpg', 'sort_order': 2},
        },
      );

      expect(map['id'], 1);
      expect(map['image'], '/media/a.jpg');
      expect(map['sort_order'], 2);
    });

    test('returns raw image map', () {
      final map = requireImageUploadResponseData(
        label: '上传图片',
        data: {'id': '2', 'image': '/media/b.png'},
      );

      expect(map['id'], '2');
      expect(map['image'], '/media/b.png');
    });

    test('throws when response is not a map', () {
      expect(
        () =>
            requireImageUploadResponseData(label: '上传图片', data: ['unexpected']),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws when image id is missing or invalid', () {
      expect(
        () => requireImageUploadResponseData(
          label: '上传图片',
          data: {'id': 0, 'image': '/media/a.jpg'},
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('throws when image url is missing or empty', () {
      expect(
        () => requireImageUploadResponseData(
          label: '上传图片',
          data: {'id': 1, 'image': ' '},
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
