import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/app_metadata.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

/// 登录/注册页面通用卡片组件
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.title,
    required this.children,
    this.footer,
    this.formKey,
  });

  final String title;
  final Widget children;
  final Widget? footer;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final semantic = theme.extension<AppSemanticColors>()!;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Container(
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            colors.surface.withValues(alpha: OpacityTokens.intense),
            colors.background,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: colors.borderColor.withValues(alpha: OpacityTokens.intense),
          ),
          boxShadow: [
            BoxShadow(
              color: semantic.shadowStrong.withValues(
                alpha: OpacityTokens.mild,
              ),
              blurRadius: 48,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SpacingTokens.xl + SpacingTokens.xs,
            SpacingTokens.xl + SpacingTokens.xxs,
            SpacingTokens.xl + SpacingTokens.xs,
            SpacingTokens.xl + SpacingTokens.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _BrandHeader(theme: theme, colors: colors),
              SizedBox(height: SpacingTokens.lg),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: SpacingTokens.md + SpacingTokens.xxs),
              if (formKey != null)
                Form(key: formKey, child: children)
              else
                children,
              if (footer != null) ...[
                SizedBox(height: SpacingTokens.lg),
                const Divider(height: 1),
                SizedBox(height: SpacingTokens.lg),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.theme, required this.colors});

  final ThemeData theme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppMetadata.displayName,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colors.sidebarText,
      ),
    );
  }
}

/// 装饰性背景组件
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final semantic = theme.extension<AppSemanticColors>()!;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(
                  scheme.primary.withValues(alpha: OpacityTokens.mild),
                  colors.background,
                ),
                colors.background,
                Color.alphaBlend(
                  semantic.warning.withValues(alpha: OpacityTokens.weak),
                  colors.background,
                ),
              ],
            ),
          ),
        ),
        _GlowOrb(
          top: -120,
          left: -80,
          size: 280,
          color: semantic.warning.withValues(alpha: OpacityTokens.scrim),
        ),
        _GlowOrb(
          top: 72,
          right: -56,
          size: 220,
          color: scheme.primary.withValues(alpha: OpacityTokens.distinct),
        ),
        _GlowOrb(
          bottom: -96,
          right: 32,
          size: 260,
          color: semantic.info.withValues(alpha: OpacityTokens.medium),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color,
                color.withValues(alpha: OpacityTokens.invisible),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
