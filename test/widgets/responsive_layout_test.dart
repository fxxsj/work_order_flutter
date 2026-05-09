import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  // ScreenSize (3-tier) breakpoints
  // ═══════════════════════════════════════════════════════════════════════

  group('ScreenSize breakpoints', () {
    test('mobile when width < 768', () {
      expect(ResponsiveLayout.getScreenSize(0), ScreenSize.mobile);
      expect(ResponsiveLayout.getScreenSize(640), ScreenSize.mobile);
      expect(ResponsiveLayout.getScreenSize(767), ScreenSize.mobile);
    });

    test('tablet when 768 <= width < 1024', () {
      expect(ResponsiveLayout.getScreenSize(768), ScreenSize.tablet);
      expect(ResponsiveLayout.getScreenSize(1023), ScreenSize.tablet);
    });

    test('desktop when width >= 1024', () {
      expect(ResponsiveLayout.getScreenSize(1024), ScreenSize.desktop);
      expect(ResponsiveLayout.getScreenSize(1280), ScreenSize.desktop);
      expect(ResponsiveLayout.getScreenSize(1920), ScreenSize.desktop);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // BreakpointRange (6-tier) breakpoints
  // ═══════════════════════════════════════════════════════════════════════

  group('BreakpointRange (6-tier) breakpoints', () {
    test('xs when width < 640', () {
      expect(ResponsiveLayout.getBreakpoint(0), BreakpointRange.xs);
      expect(ResponsiveLayout.getBreakpoint(639), BreakpointRange.xs);
    });

    test('sm when 640 <= width < 768', () {
      expect(ResponsiveLayout.getBreakpoint(640), BreakpointRange.sm);
      expect(ResponsiveLayout.getBreakpoint(767), BreakpointRange.sm);
    });

    test('md when 768 <= width < 1024', () {
      expect(ResponsiveLayout.getBreakpoint(768), BreakpointRange.md);
      expect(ResponsiveLayout.getBreakpoint(1023), BreakpointRange.md);
    });

    test('lg when 1024 <= width < 1280', () {
      expect(ResponsiveLayout.getBreakpoint(1024), BreakpointRange.lg);
      expect(ResponsiveLayout.getBreakpoint(1279), BreakpointRange.lg);
    });

    test('xl when 1280 <= width < 1536', () {
      expect(ResponsiveLayout.getBreakpoint(1280), BreakpointRange.xl);
      expect(ResponsiveLayout.getBreakpoint(1535), BreakpointRange.xl);
    });

    test('twoXl when width >= 1536', () {
      expect(ResponsiveLayout.getBreakpoint(1536), BreakpointRange.twoXl);
      expect(ResponsiveLayout.getBreakpoint(1920), BreakpointRange.twoXl);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ScreenSize static helpers
  // ═══════════════════════════════════════════════════════════════════════

  group('ResponsiveLayout ScreenSize static helpers', () {
    testWidgets('isMobile returns true on mobile width', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return ResponsiveLayout.isMobile(ctx)
            ? const Text('mobile')
            : const Text('not mobile');
      });
      expect(find.text('mobile'), findsOneWidget);
    });

    testWidgets('isTablet returns true on tablet width', (tester) async {
      await pumpAtSize(tester, const Size(900, 600), (ctx) {
        return ResponsiveLayout.isTablet(ctx)
            ? const Text('tablet')
            : const Text('not tablet');
      });
      expect(find.text('tablet'), findsOneWidget);
    });

    testWidgets('isDesktop returns true on desktop width', (tester) async {
      await pumpAtSize(tester, const Size(1200, 800), (ctx) {
        return ResponsiveLayout.isDesktop(ctx)
            ? const Text('desktop')
            : const Text('not desktop');
      });
      expect(find.text('desktop'), findsOneWidget);
    });

    testWidgets('of returns correct screen size', (tester) async {
      await pumpAtSize(tester, const Size(1100, 800), (ctx) {
        return Text(ResponsiveLayout.of(ctx).name);
      });
      expect(find.text('desktop'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // 6-tier static helpers
  // ═══════════════════════════════════════════════════════════════════════

  group('ResponsiveLayout 6-tier static helpers', () {
    testWidgets('isXs at narrow width', (tester) async {
      await pumpAtSize(tester, const Size(500, 800), (ctx) {
        return ResponsiveLayout.isXs(ctx)
            ? const Text('xs')
            : const Text('not xs');
      });
      expect(find.text('xs'), findsOneWidget);
    });

    testWidgets('isSm at sm width', (tester) async {
      await pumpAtSize(tester, const Size(700, 800), (ctx) {
        return ResponsiveLayout.isSm(ctx)
            ? const Text('sm')
            : const Text('not sm');
      });
      expect(find.text('sm'), findsOneWidget);
    });

    testWidgets('isMd at md width', (tester) async {
      await pumpAtSize(tester, const Size(900, 600), (ctx) {
        return ResponsiveLayout.isMd(ctx)
            ? const Text('md')
            : const Text('not md');
      });
      expect(find.text('md'), findsOneWidget);
    });

    testWidgets('isLg at lg width', (tester) async {
      await pumpAtSize(tester, const Size(1100, 800), (ctx) {
        return ResponsiveLayout.isLg(ctx)
            ? const Text('lg')
            : const Text('not lg');
      });
      expect(find.text('lg'), findsOneWidget);
    });

    testWidgets('isXl at xl width', (tester) async {
      await pumpAtSize(tester, const Size(1400, 900), (ctx) {
        return ResponsiveLayout.isXl(ctx)
            ? const Text('xl')
            : const Text('not xl');
      });
      expect(find.text('xl'), findsOneWidget);
    });

    testWidgets('is2xl at 2xl width', (tester) async {
      await pumpAtSize(tester, const Size(1600, 900), (ctx) {
        return ResponsiveLayout.is2xl(ctx)
            ? const Text('2xl')
            : const Text('not 2xl');
      });
      expect(find.text('2xl'), findsOneWidget);
    });

    testWidgets('isNarrow is true when width < 768', (tester) async {
      await pumpAtSize(tester, const Size(600, 800), (ctx) {
        return ResponsiveLayout.isNarrow(ctx)
            ? const Text('narrow')
            : const Text('wide');
      });
      expect(find.text('narrow'), findsOneWidget);
    });

    testWidgets('isWide is true when width >= 1024', (tester) async {
      await pumpAtSize(tester, const Size(1200, 800), (ctx) {
        return ResponsiveLayout.isWide(ctx)
            ? const Text('wide')
            : const Text('narrow');
      });
      expect(find.text('wide'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ResponsiveLayout builder pattern
  // ═══════════════════════════════════════════════════════════════════════

  group('ResponsiveLayout builder pattern', () {
    testWidgets('builder receives correct screen size', (tester) async {
      await pumpAtSize(tester, const Size(500, 800), (ctx) {
        return MaterialApp(
          home: ResponsiveLayout(
            builder: (context, screenSize) {
              return Text(screenSize.name);
            },
          ),
        );
      });
      expect(find.text('mobile'), findsOneWidget);
    });

    testWidgets('builder receives tablet on medium width', (tester) async {
      await pumpAtSize(tester, const Size(900, 600), (ctx) {
        return MaterialApp(
          home: ResponsiveLayout(
            builder: (context, screenSize) {
              return Text(screenSize.name);
            },
          ),
        );
      });
      expect(find.text('tablet'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ResponsiveLayout slot pattern
  // ═══════════════════════════════════════════════════════════════════════

  group('ResponsiveLayout slot pattern', () {
    testWidgets('shows mobile widget on mobile', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return MaterialApp(
          home: ResponsiveLayout(
            mobile: const Text('mobile widget'),
            desktop: const Text('desktop widget'),
          ),
        );
      });
      expect(find.text('mobile widget'), findsOneWidget);
      expect(find.text('desktop widget'), findsNothing);
    });

    testWidgets('shows desktop widget on desktop', (tester) async {
      await pumpAtSize(tester, const Size(1200, 800), (ctx) {
        return MaterialApp(
          home: ResponsiveLayout(
            mobile: const Text('mobile widget'),
            desktop: const Text('desktop widget'),
          ),
        );
      });
      expect(find.text('desktop widget'), findsOneWidget);
      expect(find.text('mobile widget'), findsNothing);
    });

    testWidgets('tablet falls back to desktop when tablet slot is null', (tester) async {
      await pumpAtSize(tester, const Size(900, 600), (ctx) {
        return MaterialApp(
          home: ResponsiveLayout(
            mobile: const Text('mobile widget'),
            desktop: const Text('desktop widget'),
          ),
        );
      });
      expect(find.text('desktop widget'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // OrientationLayout
  // ═══════════════════════════════════════════════════════════════════════

  group('OrientationLayout', () {
    testWidgets('shows portrait widget in portrait mode', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return MaterialApp(
          home: OrientationLayout(
            portrait: const Text('portrait'),
            landscape: const Text('landscape'),
          ),
        );
      });
      expect(find.text('portrait'), findsOneWidget);
      expect(find.text('landscape'), findsNothing);
    });

    testWidgets('shows landscape widget in landscape mode', (tester) async {
      await pumpAtSize(tester, const Size(800, 400), (ctx) {
        return MaterialApp(
          home: OrientationLayout(
            portrait: const Text('portrait'),
            landscape: const Text('landscape'),
          ),
        );
      });
      expect(find.text('landscape'), findsOneWidget);
      expect(find.text('portrait'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ShowOnBreakpoint
  // ═══════════════════════════════════════════════════════════════════════

  group('ShowOnBreakpoint with ScreenSize', () {
    testWidgets('shows child when screen size matches showAt', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [ScreenSize.mobile],
            child: const Text('visible on mobile'),
          ),
        );
      });
      expect(find.text('visible on mobile'), findsOneWidget);
    });

    testWidgets('hides child when screen size not in showAt', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [ScreenSize.desktop],
            child: const Text('visible on desktop'),
          ),
        );
      });
      expect(find.text('visible on desktop'), findsNothing);
    });

    testWidgets('hides child when screen size matches hideOn (takes precedence)', (tester) async {
      await pumpAtSize(tester, const Size(400, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [ScreenSize.mobile, ScreenSize.tablet, ScreenSize.desktop],
            hideOn: [ScreenSize.mobile],
            child: const Text('hidden on mobile'),
          ),
        );
      });
      expect(find.text('hidden on mobile'), findsNothing);
    });
  });

  group('ShowOnBreakpoint with BreakpointRange', () {
    testWidgets('shows child on xs breakpoint', (tester) async {
      await pumpAtSize(tester, const Size(500, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [BreakpointRange.xs],
            child: const Text('visible at xs'),
          ),
        );
      });
      expect(find.text('visible at xs'), findsOneWidget);
    });

    testWidgets('shows child on sm breakpoint', (tester) async {
      await pumpAtSize(tester, const Size(700, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [BreakpointRange.sm],
            child: const Text('visible at sm'),
          ),
        );
      });
      expect(find.text('visible at sm'), findsOneWidget);
    });

    testWidgets('hides child when breakpoint not in showAt', (tester) async {
      await pumpAtSize(tester, const Size(700, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [BreakpointRange.lg],
            child: const Text('visible at lg'),
          ),
        );
      });
      expect(find.text('visible at lg'), findsNothing);
    });

    testWidgets('hideOn takes precedence over showAt with BreakpointRange', (tester) async {
      await pumpAtSize(tester, const Size(1100, 800), (ctx) {
        return MaterialApp(
          home: ShowOnBreakpoint(
            showAt: [BreakpointRange.lg, BreakpointRange.xl],
            hideOn: [BreakpointRange.lg],
            child: const Text('hidden at lg'),
          ),
        );
      });
      expect(find.text('hidden at lg'), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // breakpointOf
  // ═══════════════════════════════════════════════════════════════════════

  group('breakpointOf', () {
    testWidgets('returns xs at narrow width', (tester) async {
      await pumpAtSize(tester, const Size(500, 800), (ctx) {
        return Text(ResponsiveLayout.breakpointOf(ctx).name);
      });
      expect(find.text('xs'), findsOneWidget);
    });

    testWidgets('returns lg at wide width', (tester) async {
      await pumpAtSize(tester, const Size(1100, 800), (ctx) {
        return Text(ResponsiveLayout.breakpointOf(ctx).name);
      });
      expect(find.text('lg'), findsOneWidget);
    });

    testWidgets('returns twoXl at very wide width', (tester) async {
      await pumpAtSize(tester, const Size(1600, 900), (ctx) {
        return Text(ResponsiveLayout.breakpointOf(ctx).name);
      });
      expect(find.text('twoXl'), findsOneWidget);
    });
  });
}

// ─── Test helper ───────────────────────────────────────────────────────────

/// Pumps a widget that uses a Builder to access context at a given [size].
Future<void> pumpAtSize(
  WidgetTester tester,
  Size size,
  Widget Function(BuildContext context) builder,
) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: Builder(
          builder: (context) => builder(context),
        ),
      ),
    ),
  );
}
