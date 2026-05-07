import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.form,
    required this.footer,
    this.heroTitle = '工单系统',
  });

  final String title;
  final String heroTitle;
  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final semantic = theme.extension<AppSemanticColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.alphaBlend(
                  scheme.primary.withValues(alpha: OpacityTokens.mild), colors.background),
              colors.background,
              Color.alphaBlend(
                  semantic.warning.withValues(alpha: OpacityTokens.weak), colors.background),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -80,
              child: _GlowOrb(
                size: 280,
                color: semantic.warning.withValues(alpha: OpacityTokens.scrim),
              ),
            ),
            Positioned(
              top: 72,
              right: -56,
              child: _GlowOrb(
                size: 220,
                color: scheme.primary.withValues(alpha: OpacityTokens.distinct),
              ),
            ),
            Positioned(
              bottom: -96,
              right: 32,
              child: _GlowOrb(
                size: 260,
                color: semantic.info.withValues(alpha: OpacityTokens.medium),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: LayoutTokens.gapLg + LayoutTokens.gapXs,
                    vertical: LayoutTokens.gapXl,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: LayoutTokens.dialogWidthXl,
                    ),
                    child: _StaggeredEntrance(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 720;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.alphaBlend(
                                colors.surface.withValues(alpha: OpacityTokens.intense),
                                colors.background,
                              ),
                              borderRadius:
                                  BorderRadius.circular(compact ? 28 : 36),
                              border: Border.all(
                                color:
                                    colors.borderColor.withValues(alpha: OpacityTokens.intense),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: semantic.shadowStrong
                                      .withValues(alpha: OpacityTokens.mild),
                                  blurRadius: 48,
                                  offset: const Offset(0, 22),
                                ),
                              ],
                            ),
                            child: compact
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _HeroPanel(
                                        heroTitle: heroTitle,
                                        compact: true,
                                      ),
                                      _FormPanel(
                                        title: title,
                                        form: form,
                                        footer: footer,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: _HeroPanel(
                                          heroTitle: heroTitle,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 11,
                                        child: _FormPanel(
                                          title: title,
                                          form: form,
                                          footer: footer,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.heroTitle,
    this.compact = false,
  });

  final String heroTitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final semantic = theme.extension<AppSemanticColors>()!;

    return Container(
      padding: EdgeInsets.fromLTRB(
        compact ? 24 : 32,
        compact ? 24 : 32,
        compact ? 24 : 24,
        compact ? 24 : 32,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(36),
          topRight: Radius.circular(compact ? 36 : 0),
          bottomLeft: Radius.circular(compact ? 0 : 36),
          bottomRight: Radius.circular(compact ? 0 : 0),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.alphaBlend(
                scheme.primary.withValues(alpha: OpacityTokens.distinct), colors.sidebar),
            Color.alphaBlend(
              scheme.secondary.withValues(alpha: OpacityTokens.medium),
              colors.surface,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: compact ? 8 : 20),
          Text(
            '新西彩',
            style: theme.textTheme.displaySmall?.copyWith(
              height: 0.92,
              color: colors.sidebarText,
            ),
          ),
          SizedBox(height: LayoutTokens.gapSm),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: LayoutTokens.sidebarWidth,
            ),
            child: Text(
              heroTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                height: 1.35,
                color: colors.subtleText,
              ),
            ),
          ),
          SizedBox(
            height: compact ? LayoutTokens.gapLg : LayoutTokens.gapXl,
          ),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: semantic.success.withValues(alpha: OpacityTokens.heavy),
              borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({
    required this.title,
    required this.form,
    required this.footer,
  });

  final String title;
  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        LayoutTokens.gapXl + LayoutTokens.gapXs,
        LayoutTokens.gapXl + LayoutTokens.gapXxs,
        LayoutTokens.gapXl + LayoutTokens.gapXs,
        LayoutTokens.gapXl + LayoutTokens.gapXs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: LayoutTokens.gapMd + LayoutTokens.gapXxs),
          form,
          SizedBox(height: LayoutTokens.gapLg),
          const Divider(height: 1),
          SizedBox(height: LayoutTokens.gapLg),
          footer,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
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
    );
  }
}

class _StaggeredEntrance extends StatefulWidget {
  const _StaggeredEntrance({required this.child});

  final Widget child;

  @override
  State<_StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<_StaggeredEntrance> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 560);

    return AnimatedSlide(
      duration: duration,
      curve: Curves.easeOutCubic,
      offset: _visible ? Offset.zero : const Offset(0, 0.04),
      child: AnimatedOpacity(
        duration: duration,
        curve: Curves.easeOutCubic,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
