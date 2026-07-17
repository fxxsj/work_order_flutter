import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/image_gallery_upload_section.dart';

class _TestImage {
  const _TestImage(this.url, this.description);

  final String url;
  final String description;
}

void main() {
  ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      extensions: const [
        AppColors(
          background: Colors.white,
          surface: Colors.white,
          sidebar: Colors.white,
          subtleText: Colors.black54,
          sidebarText: Colors.black87,
          borderColor: Colors.black12,
        ),
      ],
    );
  }

  Future<void> pumpSection(
    WidgetTester tester, {
    required List<_TestImage> images,
    Future<void> Function()? onUpload,
    Future<void> Function(_TestImage image)? onDelete,
    bool canUpload = true,
    bool uploading = false,
    int? maxCount,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ImageGalleryUploadSection<_TestImage>(
              images: images,
              imageUrlBuilder: (image) => image.url,
              descriptionBuilder: (image) => image.description,
              onUpload: onUpload ?? () async {},
              onDelete: onDelete ?? (_) async {},
              canUpload: canUpload,
              uploading: uploading,
              maxCount: maxCount,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders empty state and upload button', (tester) async {
    var uploaded = false;
    await pumpSection(
      tester,
      images: const [],
      onUpload: () async => uploaded = true,
    );

    expect(find.text('暂无图片，点击下方按钮上传'), findsOneWidget);
    expect(find.text('上传图片'), findsOneWidget);

    await tester.tap(find.text('上传图片'));
    await tester.pump();

    expect(uploaded, isTrue);
  });

  testWidgets('shows unsaved hint when upload is disabled', (tester) async {
    await pumpSection(tester, images: const [], canUpload: false);

    expect(find.text('请先保存后再上传图片'), findsOneWidget);
    expect(find.text('上传图片'), findsNothing);
  });

  testWidgets('disables upload when max count is reached', (tester) async {
    await pumpSection(
      tester,
      images: const [_TestImage('/media/a.jpg', '正面')],
      maxCount: 1,
    );

    expect(find.text('最多上传 1 张图片'), findsOneWidget);
    final button = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('image_gallery_upload_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('confirms before deleting image', (tester) async {
    var deleted = false;
    await pumpSection(
      tester,
      images: const [_TestImage('/media/a.jpg', '正面')],
      onDelete: (_) async => deleted = true,
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('删除图片'), findsOneWidget);
    expect(find.text('确定要删除这张图片吗？'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(deleted, isFalse);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(deleted, isTrue);
  });

  testWidgets('opens preview and navigates images', (tester) async {
    await pumpSection(
      tester,
      images: const [
        _TestImage('/media/a.jpg', '正面'),
        _TestImage('/media/b.jpg', '背面'),
      ],
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(find.text('正面'), findsWidgets);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('下一张'), findsOneWidget);

    await tester.tap(find.text('下一张'));
    await tester.pumpAndSettle();

    expect(find.text('背面'), findsWidgets);
    expect(find.text('2/2'), findsOneWidget);

    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();

    expect(find.text('1/2'), findsNothing);
  });

  testWidgets('shows uploading spinner instead of upload button', (
    tester,
  ) async {
    await pumpSection(tester, images: const [], uploading: true);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('上传图片'), findsNothing);
  });
}
