import 'package:flutter/material.dart';

/// 圆角设计令牌
///
/// 统一所有圆角值，禁止在业务代码中硬编码 BorderRadius.circular() 数字。
///
/// 使用示例：
/// ```dart
/// // 替代 BorderRadius.circular(12)
/// RadiusTokens.md  // BorderRadius.circular(12)
///
/// // 替代 BorderRadius.circular(9999)（胶囊形）
/// RadiusTokens.pill
/// ```
class RadiusTokens {
  const RadiusTokens._();

  /// shadcn 风格统一圆角规范
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double pill = 9999;

  /// 预构建的 BorderRadius 实例（避免每次重建）
  static const BorderRadius bXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius bSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius bMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius bLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius bXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius bPill = BorderRadius.all(Radius.circular(pill));

  /// 顶部圆角（用于对话框底部弹窗等场景）
  static const BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static const BorderRadius topXl = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
