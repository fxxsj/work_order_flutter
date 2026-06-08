import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/widgets/shimmer_loading.dart';

void main() {
  group('ShimmerLoading', () {
    testWidgets('enabled=true 渲染子组件', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerLoading(
            enabled: true,
            child: SizedBox(width: 100, height: 50),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('enabled=false 不渲染 ShaderMask', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerLoading(
            enabled: false,
            child: SizedBox(width: 100, height: 50),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
    });
  });

  group('ShimmerBox', () {
    testWidgets('渲染指定尺寸的容器', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerBox(width: 120, height: 16),
        ),
      );
      final box = tester.widget<Container>(find.byType(Container));
      expect(box.constraints?.maxWidth, 120);
      expect(box.constraints?.maxHeight, 16);
    });
  });

  group('ShimmerListTile', () {
    testWidgets('包含圆形头像和两行文本骨架', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerListTile(),
        ),
      );
      expect(find.byType(ShimmerBox), findsNWidgets(3));
    });
  });

  group('ShimmerCard', () {
    testWidgets('包含标题、内容行和操作按钮骨架', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerCard(),
        ),
      );
      expect(find.byType(ShimmerBox), findsNWidgets(7));
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('ShimmerList', () {
    testWidgets('渲染指定数量的列表项', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShimmerList(itemCount: 4),
        ),
      );
      expect(find.byType(ShimmerListTile), findsNWidgets(4));
    });
  });
}
