import 'package:flutter/material.dart';
import 'package:work_order_app/constants/breakpoints.dart';

class BreakpointsUtil {
  const BreakpointsUtil._();

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isXs(BuildContext context) => width(context) < Breakpoints.sm;
  static bool isSm(BuildContext context) => width(context) >= Breakpoints.sm && width(context) < Breakpoints.md;
  static bool isMd(BuildContext context) => width(context) >= Breakpoints.md && width(context) < Breakpoints.lg;
  static bool isLg(BuildContext context) => width(context) >= Breakpoints.lg && width(context) < Breakpoints.xl;
  static bool isXl(BuildContext context) => width(context) >= Breakpoints.xl && width(context) < Breakpoints.twoXl;
  static bool is2xl(BuildContext context) => width(context) >= Breakpoints.twoXl;

  static bool isMobile(BuildContext context) => width(context) < Breakpoints.md;
  static bool isTablet(BuildContext context) => width(context) >= Breakpoints.md && width(context) < Breakpoints.lg;
  static bool isDesktop(BuildContext context) => width(context) >= Breakpoints.lg;
}
