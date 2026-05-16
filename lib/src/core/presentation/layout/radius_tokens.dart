import 'package:flutter/material.dart';

/// 圆角设计令牌
///
/// 统一所有圆角值，禁止在业务代码中硬编码 BorderRadius.circular() 数字。
/// 基于 Linear 设计系统规范。
///
/// 使用示例：
/// ```dart
/// // 替代 BorderRadius.circular(8)
/// RadiusTokens.md  // BorderRadius.circular(8)
///
/// // 替代 BorderRadius.circular(9999)（胶囊形）
/// RadiusTokens.pill
/// ```
class RadiusTokens {
  const RadiusTokens._();

  /// Linear 圆角规范
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double pill = 9999;
  static const double full = 9999;

  /// 预构建的 BorderRadius 实例（避免每次重建）
  static const BorderRadius bXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius bSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius bMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius bLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius bXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius bXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius bPill = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius bFull = BorderRadius.all(Radius.circular(full));

  /// 顶部圆角（用于对话框底部弹窗等场景）
  static const BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius topXl = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
  static const BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}