import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/connectivity_service.dart';
import 'package:work_order_app/src/core/presentation/widgets/offline_banner.dart';

void main() {
  group('OfflineBanner', () {
    Widget buildTestWidget(ConnectivityService service) {
      return MaterialApp(
        home: Provider.value(
          value: service,
          child: const OfflineBanner(
            child: Scaffold(
              body: Center(child: Text('Content')),
            ),
          ),
        ),
      );
    }

    /// 判断横幅是否在可视区域内（考虑 SlideTransition 的偏移）
    bool _isBannerVisible(WidgetTester tester) {
      final finder = find.text('网络异常，请检查网络连接');
      if (finder.evaluate().isEmpty) return false;
      try {
        final offset = tester.getTopLeft(finder);
        return offset.dy >= -0.5;
      } catch (_) {
        return false;
      }
    }

    testWidgets('在线时不显示横幅', (tester) async {
      final service = ConnectivityService.test(initialOnline: true);
      await tester.pumpWidget(buildTestWidget(service));
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isFalse);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('离线时显示横幅', (tester) async {
      final service = ConnectivityService.test(initialOnline: false);
      await tester.pumpWidget(buildTestWidget(service));
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isTrue);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });

    testWidgets('从在线切换到离线显示横幅', (tester) async {
      final service = ConnectivityService.test(initialOnline: true);
      await tester.pumpWidget(buildTestWidget(service));
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isFalse);

      service.simulateStatusChange(false);
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isTrue);
    });

    testWidgets('从离线恢复到在线收起横幅', (tester) async {
      final service = ConnectivityService.test(initialOnline: false);
      await tester.pumpWidget(buildTestWidget(service));
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isTrue);

      service.simulateStatusChange(true);
      await tester.pumpAndSettle();

      expect(_isBannerVisible(tester), isFalse);
    });

    testWidgets('重复状态不触发额外动画', (tester) async {
      final service = ConnectivityService.test(initialOnline: true);
      await tester.pumpWidget(buildTestWidget(service));
      await tester.pumpAndSettle();

      service.simulateStatusChange(true); // 重复在线
      await tester.pumpAndSettle();
      expect(_isBannerVisible(tester), isFalse);

      service.simulateStatusChange(false);
      await tester.pumpAndSettle();
      expect(_isBannerVisible(tester), isTrue);

      service.simulateStatusChange(false); // 重复离线
      await tester.pumpAndSettle();
      expect(_isBannerVisible(tester), isTrue);
    });
  });
}
