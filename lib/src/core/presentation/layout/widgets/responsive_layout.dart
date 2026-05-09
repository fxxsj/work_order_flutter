import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';

/// Screen size categories matching the app's responsive design.
///
/// Used by [ResponsiveLayout] to conditionally render content.
///
/// The 3-tier hierarchy (mobile / tablet / desktop) maps to:
///
/// | Tier | Width | Typical devices |
/// |-------|-------|----------------|
/// | [mobile] | < 768px | phones |
/// | [tablet] | 768px - 1024px | tablets, small laptops |
/// | [desktop] | >= 1024px | desktops, large laptops |
enum ScreenSize {
  /// Mobile devices (width < 768px)
  mobile,

  /// Tablet devices (768px <= width < 1024px)
  tablet,

  /// Desktop devices (width >= 1024px)
  desktop,
}

/// Fine-grained breakpoint tiers for precise responsive control.
///
/// Use [BreakpointRange] helpers for targeted conditionals, or
/// [ResponsiveLayout.isXs]/[ResponsiveLayout.is2xl] etc. for inline checks.
///
/// | Tier | Width | Maps to ScreenSize |
/// |-------|-------|---------------------|
/// | [xs] | < 640px | mobile |
/// | [sm] | 640px - 768px | mobile |
/// | [md] | 768px - 1024px | tablet |
/// | [lg] | 1024px - 1280px | desktop |
/// | [xl] | 1280px - 1536px | desktop |
/// | [twoXl] | >= 1536px | desktop |
enum BreakpointRange {
  xs,
  sm,
  md,
  lg,
  xl,
  twoXl,
}

/// A responsive layout widget that adapts content based on screen size.
///
/// Provides two usage patterns:
/// 1. **Builder pattern**: Pass a [builder] function that receives the current [ScreenSize]
/// 2. **Slot pattern**: Pass widgets for specific screen sizes ([mobile], [tablet], [desktop])
///
/// Example using builder:
/// ```dart
/// ResponsiveLayout(
///   builder: (context, screenSize) {
///     if (screenSize == ScreenSize.mobile) {
///       return MobileLayout();
///     }
///     return DesktopLayout();
///   },
/// )
/// ```
///
/// Example using slots:
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileWidget(),
///   desktop: DesktopWidget(),
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
  }) : assert(
          builder != null || mobile != null || tablet != null || desktop != null,
          'At least one of builder, mobile, tablet, or desktop must be provided',
        );

  /// Builder function that receives the current screen size and returns a widget.
  /// Use this for complex responsive layouts with custom logic.
  final Widget Function(BuildContext context, ScreenSize screenSize)? builder;

  /// Widget to display on mobile devices (width < 768px).
  final Widget? mobile;

  /// Widget to display on tablet devices (768px <= width < 1024px).
  final Widget? tablet;

  /// Widget to display on desktop devices (width >= 1024px).
  final Widget? desktop;

  // ─── ScreenSize (3-tier) ────────────────────────────────────────────────

  /// Returns the [ScreenSize] for the given width.
  static ScreenSize getScreenSize(double width) {
    if (width < Breakpoints.md) return ScreenSize.mobile;
    if (width < Breakpoints.lg) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  /// Returns the current [ScreenSize] from the given [BuildContext].
  static ScreenSize of(BuildContext context) {
    return getScreenSize(MediaQuery.sizeOf(context).width);
  }

  /// Returns true if the current screen size matches [size].
  static bool isSize(BuildContext context, ScreenSize size) {
    return of(context) == size;
  }

  /// Returns true if the current screen is mobile (< 768px).
  static bool isMobile(BuildContext context) => isSize(context, ScreenSize.mobile);

  /// Returns true if the current screen is tablet (768px - 1024px).
  static bool isTablet(BuildContext context) => isSize(context, ScreenSize.tablet);

  /// Returns true if the current screen is desktop (>= 1024px).
  static bool isDesktop(BuildContext context) => isSize(context, ScreenSize.desktop);

  // ─── BreakpointRange (6-tier) ───────────────────────────────────────────

  /// Returns the [BreakpointRange] for the given width.
  static BreakpointRange getBreakpoint(double width) {
    if (width < Breakpoints.sm) return BreakpointRange.xs;
    if (width < Breakpoints.md) return BreakpointRange.sm;
    if (width < Breakpoints.lg) return BreakpointRange.md;
    if (width < Breakpoints.xl) return BreakpointRange.lg;
    if (width < Breakpoints.twoXl) return BreakpointRange.xl;
    return BreakpointRange.twoXl;
  }

  /// Returns the current [BreakpointRange] from the given [BuildContext].
  static BreakpointRange breakpointOf(BuildContext context) {
    return getBreakpoint(MediaQuery.sizeOf(context).width);
  }

  /// Returns true if the current breakpoint matches [bp].
  static bool isBreakpoint(BuildContext context, BreakpointRange bp) {
    return breakpointOf(context) == bp;
  }

  // ─── 6-tier static helpers ─────────────────────────────────────────────

  /// True when width < 640px
  static bool isXs(BuildContext context) => isBreakpoint(context, BreakpointRange.xs);

  /// True when 640px <= width < 768px
  static bool isSm(BuildContext context) => isBreakpoint(context, BreakpointRange.sm);

  /// True when 768px <= width < 1024px
  static bool isMd(BuildContext context) => isBreakpoint(context, BreakpointRange.md);

  /// True when 1024px <= width < 1280px
  static bool isLg(BuildContext context) => isBreakpoint(context, BreakpointRange.lg);

  /// True when 1280px <= width < 1536px
  static bool isXl(BuildContext context) => isBreakpoint(context, BreakpointRange.xl);

  /// True when width >= 1536px
  static bool is2xl(BuildContext context) => isBreakpoint(context, BreakpointRange.twoXl);

  // ─── Compound helpers ───────────────────────────────────────────────────

  /// True when screen is narrow (mobile or small tablet portrait): width < 768px
  static bool isNarrow(BuildContext context) => width(context) < Breakpoints.md;

  /// True when screen is compact (xs or sm): width < 768px
  static bool isCompact(BuildContext context) => width(context) < Breakpoints.md;

  /// True when screen is medium (md): 768px <= width < 1024px
  static bool isMedium(BuildContext context) {
    final w = width(context);
    return w >= Breakpoints.md && w < Breakpoints.lg;
  }

  /// True when screen is wide (lg or larger): width >= 1024px
  static bool isWide(BuildContext context) => width(context) >= Breakpoints.lg;

  /// Convenience: current width from context
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  @override
  Widget build(BuildContext context) {
    final screenSize = of(context);

    if (builder != null) {
      return builder!(context, screenSize);
    }

    return switch (screenSize) {
      ScreenSize.mobile => mobile!,
      ScreenSize.tablet => tablet ?? desktop ?? mobile!,
      ScreenSize.desktop => desktop ?? tablet ?? mobile!,
    };
  }
}

/// A responsive layout that shows different widgets in portrait vs landscape mode.
///
/// Useful for features that need to adapt based on device orientation.
class OrientationLayout extends StatelessWidget {
  const OrientationLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  /// Widget to display in portrait mode.
  final Widget portrait;

  /// Widget to display in landscape mode.
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return orientation == Orientation.portrait ? portrait : landscape;
  }
}

/// A responsive layout that shows/hides content based on breakpoint.
///
/// Useful for conditionally showing content like sidebars or secondary info.
///
/// Accepts either [ScreenSize] (3-tier) or [BreakpointRange] (6-tier).
///
/// Example:
/// ```dart
/// // Show only on desktop
/// ShowOnBreakpoint(
///   showAt: [ScreenSize.desktop],
///   child: Sidebar(),
/// )
///
/// // Show on tablet and desktop
/// ShowOnBreakpoint(
///   showAt: [ScreenSize.tablet, ScreenSize.desktop],
///   child: Navigation(),
/// )
///
/// // Show only on small screens
/// ShowOnBreakpoint(
///   showAt: [BreakpointRange.xs, BreakpointRange.sm],
///   child: CompactMenu(),
/// )
/// ```
class ShowOnBreakpoint extends StatelessWidget {
  const ShowOnBreakpoint({
    super.key,
    required this.child,
    required this.showAt,
    this.hideOn = const [],
  });

  /// The content to conditionally show/hide.
  final Widget child;

  /// Breakpoint(s) at which [child] should be shown.
  /// Accepts both [ScreenSize] and [BreakpointRange] values.
  final List<Object> showAt;

  /// Breakpoint(s) at which [child] should be hidden (takes precedence).
  /// Accepts both [ScreenSize] and [BreakpointRange] values.
  final List<Object> hideOn;

  bool _matches(Object breakpoint, double width) {
    if (breakpoint is ScreenSize) {
      return ResponsiveLayout.getScreenSize(width) == breakpoint;
    }
    if (breakpoint is BreakpointRange) {
      return ResponsiveLayout.getBreakpoint(width) == breakpoint;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = ResponsiveLayout.width(context);
    for (final bp in hideOn) {
      if (_matches(bp, width)) return const SizedBox.shrink();
    }
    for (final bp in showAt) {
      if (_matches(bp, width)) return child;
    }
    return const SizedBox.shrink();
  }
}
