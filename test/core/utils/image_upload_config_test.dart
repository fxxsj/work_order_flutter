import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/utils/image_upload_config.dart';

void main() {
  test('ImageUploadConfig matches backend image upload limits', () {
    expect(ImageUploadConfig.maxCount, 12);
    expect(ImageUploadConfig.maxBytes, 10 * 1024 * 1024);
    expect(ImageUploadConfig.allowedExtensions, [
      'jpg',
      'jpeg',
      'png',
      'webp',
      'gif',
    ]);
    expect(
      ImageUploadConfig.limitHintText,
      '支持 JPG、PNG、WebP、GIF，单张不超过 10MB，最多 12 张',
    );
  });
}
