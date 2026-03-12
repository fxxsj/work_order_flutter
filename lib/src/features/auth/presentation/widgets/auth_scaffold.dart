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
                  scheme.primary.withValues(alpha: 0.12), colors.background),
              colors.background,
              Color.alphaBlend(
                  semantic.warning.withValues(alpha: 0.08), colors.background),
            ],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
                top: -120,
                left: -80,
                child: _GlowOrb(size: 280, color: Color(0xFFE6B84C))),
            Positioned(
              top: 72,
              right: -56,
              child: _GlowOrb(
                size: 220,
                color: scheme.primary.withValues(alpha: 0.24),
              ),
            ),
            Positioned(
              bottom: -96,
              right: 32,
              child: _GlowOrb(
                size: 260,
                color: semantic.info.withValues(alpha: 0.16),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: _StaggeredEntrance(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 720;
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.alphaBlend(
                                colors.surface.withValues(alpha: 0.92),
                                colors.background,
                              ),
                              borderRadius:
                                  BorderRadius.circular(compact ? 28 : 36),
                              border: Border.all(
                                color:
                                    colors.borderColor.withValues(alpha: 0.75),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: semantic.shadowStrong
                                      .withValues(alpha: 0.12),
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
                scheme.primary.withValues(alpha: 0.25), colors.sidebar),
            Color.alphaBlend(const Color(0xFF0F4C5C).withValues(alpha: 0.16),
                colors.surface),
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
              fontFamily: 'BowlbyDisplay',
              height: 0.92,
              fontSize: compact ? 36 : 46,
              letterSpacing: 0.2,
              color: const Color(0xFF162033),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              heroTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                height: 1.35,
                color: const Color(0xFF334155),
              ),
            ),
          ),
          SizedBox(height: compact ? 16 : 24),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: semantic.success.withValues(alpha: 0.5),
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
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 18),
          form,
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
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
              color.withValues(alpha: 0.0),
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
