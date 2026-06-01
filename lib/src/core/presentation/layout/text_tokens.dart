import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'opacity_tokens.dart';

/// 文本样式令牌系统
///
/// 预定义的文本样式，确保排版一致性
class TextTokens {
  const TextTokens._();

  // ==================== 字体大小 ====================

  static const double fontSizeDisplayLarge = 57;
  static const double fontSizeDisplayMedium = 45;
  static const double fontSizeDisplaySmall = 36;

  static const double fontSizeHeadlineLarge = 32;
  static const double fontSizeHeadlineMedium = 28;
  static const double fontSizeHeadlineSmall = 24;

  static const double fontSizeTitleLarge = 22;
  static const double fontSizeTitleMedium = 16;
  static const double fontSizeTitleSmall = 14;

  static const double fontSizeLabelLarge = 14;
  static const double fontSizeLabelMedium = 12;
  static const double fontSizeLabelSmall = 11;

  static const double fontSizeBodyLarge = 16;
  static const double fontSizeBodyMedium = 14;
  static const double fontSizeBodySmall = 13;

  // ==================== 行高 - 更宽松，阅读更舒适 ====================

  static const double lineHeightTight = 1.25;
  static const double lineHeightSnug = 1.375;
  static const double lineHeightNormal = 1.625;
  static const double lineHeightRelaxed = 1.75;

  // ==================== 字重 ====================

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // ==================== 字母间距 ====================

  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;

  // ==================== 预定义样式 ====================

  /// Display 样式
  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!.copyWith(
        fontSize: fontSizeDisplayLarge,
        fontWeight: semiBold,
        height: lineHeightTight,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!.copyWith(
        fontSize: fontSizeDisplayMedium,
        fontWeight: semiBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingTight,
      );

  static TextStyle displaySmall(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!.copyWith(
        fontSize: fontSizeDisplaySmall,
        fontWeight: semiBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingNormal,
      );

  /// Headline 样式
  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!.copyWith(
        fontSize: fontSizeHeadlineLarge,
        fontWeight: semiBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!.copyWith(
        fontSize: fontSizeHeadlineMedium,
        fontWeight: semiBold,
        height: lineHeightSnug,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle headlineSmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(
        fontSize: fontSizeHeadlineSmall,
        fontWeight: semiBold,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  /// Title 样式
  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(
        fontSize: fontSizeTitleLarge,
        fontWeight: semiBold,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!.copyWith(
        fontSize: fontSizeTitleMedium,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall!.copyWith(
        fontSize: fontSizeTitleSmall,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  /// Body 样式
  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: fontSizeBodyLarge,
        fontWeight: regular,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: fontSizeBodyMedium,
        fontWeight: regular,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(
        fontSize: fontSizeBodySmall,
        fontWeight: regular,
        height: lineHeightRelaxed,
        letterSpacing: letterSpacingNormal,
      );

  /// Label 样式
  static TextStyle labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!.copyWith(
        fontSize: fontSizeLabelLarge,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!.copyWith(
        fontSize: fontSizeLabelMedium,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  static TextStyle labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall!.copyWith(
        fontSize: fontSizeLabelSmall,
        fontWeight: medium,
        height: lineHeightNormal,
        letterSpacing: letterSpacingNormal,
      );

  // ==================== 语义化样式 ====================

  /// 主要文本样式
  static TextStyle primary(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSizeBodyMedium,
      fontWeight: medium,
      color: theme.colorScheme.onSurface,
      height: lineHeightNormal,
    );
  }

  /// 次要文本样式
  static TextStyle secondary(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    return TextStyle(
      fontSize: fontSizeBodySmall,
      fontWeight: regular,
      color: colors?.subtleText ?? theme.colorScheme.onSurfaceVariant,
      height: lineHeightNormal,
    );
  }

  /// 禁用文本样式
  static TextStyle disabled(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSizeBodyMedium,
      fontWeight: regular,
      color: theme.colorScheme.onSurface.withValues(
        alpha: OpacityTokens.disabled,
      ),
      height: lineHeightNormal,
    );
  }

  /// 错误文本样式
  static TextStyle error(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.extension<AppSemanticColors>();
    return TextStyle(
      fontSize: fontSizeBodyMedium,
      fontWeight: regular,
      color: semantic?.danger ?? theme.colorScheme.error,
      height: lineHeightNormal,
    );
  }

  /// 链接文本样式
  static TextStyle link(BuildContext context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSizeBodyMedium,
      fontWeight: medium,
      color: theme.colorScheme.primary,
      height: lineHeightNormal,
      decoration: TextDecoration.underline,
    );
  }

  /// 代码文本样式
  static const code = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: 0,
  );
}

/// 文本样式扩展
extension TextStyleExtension on TextStyle {
  /// 应用颜色
  TextStyle withColor(Color color) => copyWith(color: color);

  /// 应用字体大小
  TextStyle withFontSize(double size) => copyWith(fontSize: size);

  /// 应用字重
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// 应用行高
  TextStyle withHeight(double height) => copyWith(height: height);

  /// 应用不透明度
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));

  /// 变为斜体
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// 添加下划线
  TextStyle get underline =>
      copyWith(decoration: TextDecoration.underline, decorationColor: color);

  /// 添加删除线
  TextStyle get strikethrough =>
      copyWith(decoration: TextDecoration.lineThrough, decorationColor: color);

  /// 添加边框（描边）
  TextStyle withOutline(
    BuildContext context, {
    Color? color,
    double? strokeWidth,
  }) {
    final outlineColor = color ?? Theme.of(context).colorScheme.surface;
    final outlineOffset = strokeWidth ?? 1.0;
    return copyWith(
      shadows: [
        Shadow(
          color: outlineColor,
          offset: Offset(0, -outlineOffset),
          blurRadius: 0,
        ),
        Shadow(
          color: outlineColor,
          offset: Offset(0, outlineOffset),
          blurRadius: 0,
        ),
        Shadow(
          color: outlineColor,
          offset: Offset(-outlineOffset, 0),
          blurRadius: 0,
        ),
        Shadow(
          color: outlineColor,
          offset: Offset(outlineOffset, 0),
          blurRadius: 0,
        ),
      ],
    );
  }
}

/// 文本构建器
class TextBuilder {
  const TextBuilder({
    this.data = '',
    this.style,
    this.strutStyle,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  /// 创建大标题
  TextBuilder displayLarge(BuildContext context) {
    return copyWith(style: TextTokens.displayLarge(context));
  }

  /// 创建中标题
  TextBuilder headlineMedium(BuildContext context) {
    return copyWith(style: TextTokens.headlineMedium(context));
  }

  /// 创建标题
  TextBuilder titleMedium(BuildContext context) {
    return copyWith(style: TextTokens.titleMedium(context));
  }

  /// 创建正文
  TextBuilder bodyMedium(BuildContext context) {
    return copyWith(style: TextTokens.bodyMedium(context));
  }

  /// 创建次要文本
  TextBuilder secondary(BuildContext context) {
    return copyWith(style: TextTokens.secondary(context));
  }

  TextBuilder copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return TextBuilder(
      data: data ?? this.data,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
    );
  }

  /// 构建文本组件
  Text build() {
    return Text(
      data,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
