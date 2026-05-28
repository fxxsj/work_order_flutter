class ImageUploadConfig {
  const ImageUploadConfig._();

  static const int maxCount = 12;
  static const int maxBytes = 10 * 1024 * 1024;
  static const int maxMegabytes = 10;
  static const List<String> allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
  ];

  static const String limitHintText =
      '支持 JPG、PNG、WebP、GIF，单张不超过 10MB，最多 $maxCount 张';

  static String maxCountErrorText() => '图片最多上传 $maxCount 张';
}
