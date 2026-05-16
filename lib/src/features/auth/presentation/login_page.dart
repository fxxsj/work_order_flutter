import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/app_metadata.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/animation_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';

/// 现代化登录页面
///
/// 采用毛玻璃卡片 + 装饰性渐变背景，支持暗色/亮色主题自适应。
/// 响应式布局：移动端单列通栏，平板/桌面端居中卡片（maxWidth: 480dp）。
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: AnimationTokens.slow,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final savedUsername =
          context.read<AuthViewModel>().readRememberedUsername();
      _usernameController.text = savedUsername ?? '';
      if (_usernameController.text.isNotEmpty) {
        _passwordFocus.requestFocus();
      } else {
        _usernameFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;
    final semantic = theme.extension<AppSemanticColors>()!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 装饰性背景渐变
          _buildDecorativeBackground(theme, scheme, colors, semantic),

          // 装饰性光晕球
          _buildGlowOrbs(scheme, semantic),

          // 主内容
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: LayoutTokens.gapLg,
                  vertical: LayoutTokens.gapXl,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 600;
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildLoginCard(
                        context,
                        theme,
                        scheme,
                        colors,
                        semantic,
                        isWide,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeBackground(
    ThemeData theme,
    ColorScheme scheme,
    AppColors colors,
    AppSemanticColors semantic,
  ) {
    return Container(
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
    );
  }

  Widget _buildGlowOrbs(ColorScheme scheme, AppSemanticColors semantic) {
    return Stack(
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
      ],
    );
  }

  Widget _buildLoginCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme scheme,
    AppColors colors,
    AppSemanticColors semantic,
    bool isWide,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 480,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            colors.surface.withValues(alpha: OpacityTokens.intense),
            colors.background,
          ),
          borderRadius: BorderRadius.circular(isWide ? 36 : 28),
          border: Border.all(
            color: colors.borderColor.withValues(alpha: OpacityTokens.intense),
          ),
          boxShadow: [
            BoxShadow(
              color: semantic.shadowStrong.withValues(alpha: OpacityTokens.mild),
              blurRadius: 48,
              offset: const Offset(0, 22),
            ),
          ],
        ),
        child: isWide ? _buildWideLayout(theme, scheme, colors, semantic) : _buildCompactLayout(theme, scheme, colors, semantic),
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme, ColorScheme scheme, AppColors colors, AppSemanticColors semantic) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: _HeroPanel(compact: false),
        ),
        Expanded(
          flex: 11,
          child: _FormSection(
            formKey: _formKey,
            usernameController: _usernameController,
            passwordController: _passwordController,
            usernameFocus: _usernameFocus,
            passwordFocus: _passwordFocus,
            isLoading: _isLoading,
            obscurePassword: _obscurePassword,
            onPasswordVisibilityToggle: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            onUsernameSubmit: () => _passwordFocus.requestFocus(),
            onPasswordSubmit: _login,
            onRegister: () => context.go('/register'),
            onForgotPassword: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(ThemeData theme, ColorScheme scheme, AppColors colors, AppSemanticColors semantic) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeroPanel(compact: true),
        _FormSection(
          formKey: _formKey,
          usernameController: _usernameController,
          passwordController: _passwordController,
          usernameFocus: _usernameFocus,
          passwordFocus: _passwordFocus,
          isLoading: _isLoading,
          obscurePassword: _obscurePassword,
          onPasswordVisibilityToggle: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          onUsernameSubmit: () => _passwordFocus.requestFocus(),
          onPasswordSubmit: _login,
          onRegister: () => context.go('/register'),
          onForgotPassword: () {},
        ),
      ],
    );
  }

  Future<void> _login() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      await context.read<AuthViewModel>().login(
        username: _usernameController.text,
        password: _passwordController.text,
        rememberUsername: true,
      );
      if (!mounted) return;
      context.go('/');
    } on ApiException catch (err) {
      ToastUtil.showError(err.message.isNotEmpty ? err.message : '请检查账号密码');
      _passwordFocus.requestFocus();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = theme.extension<AppColors>()!;

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
              scheme.primary.withValues(alpha: OpacityTokens.distinct),
              colors.sidebar,
            ),
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
            AppMetadata.displayName.contains('订单管理')
                ? AppMetadata.displayName.split('订单管理').first.trim()
                : AppMetadata.displayName,
            style: theme.textTheme.displaySmall?.copyWith(
              height: 0.92,
              color: colors.sidebarText,
            ),
          ),
          const SizedBox(height: LayoutTokens.gapSm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: LayoutTokens.sidebarWidth),
            child: Text(
              '订单工作台',
              style: theme.textTheme.titleMedium?.copyWith(
                height: 1.35,
                color: colors.subtleText,
              ),
            ),
          ),
          SizedBox(height: compact ? LayoutTokens.gapLg : LayoutTokens.gapXl),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: theme.extension<AppSemanticColors>()!.success
                  .withValues(alpha: OpacityTokens.heavy),
              borderRadius: BorderRadius.circular(LayoutTokens.radiusPill),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.usernameFocus,
    required this.passwordFocus,
    required this.isLoading,
    required this.obscurePassword,
    required this.onPasswordVisibilityToggle,
    required this.onUsernameSubmit,
    required this.onPasswordSubmit,
    required this.onRegister,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode usernameFocus;
  final FocusNode passwordFocus;
  final bool isLoading;
  final bool obscurePassword;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onUsernameSubmit;
  final VoidCallback onPasswordSubmit;
  final VoidCallback onRegister;
  final VoidCallback onForgotPassword;

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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '登录',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: LayoutTokens.gapMd + LayoutTokens.gapXxs),
            _LoginUsernameField(
              controller: usernameController,
              focusNode: usernameFocus,
              onSubmitted: onUsernameSubmit,
            ),
            SizedBox(height: LayoutTokens.gapLg),
            _LoginPasswordField(
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: obscurePassword,
              onVisibilityToggle: onPasswordVisibilityToggle,
              onSubmitted: onPasswordSubmit,
            ),
            SizedBox(height: LayoutTokens.gapLg + LayoutTokens.gapXs),
            _LoginSubmitButton(
              isLoading: isLoading,
              onPressed: onPasswordSubmit,
            ),
            SizedBox(height: LayoutTokens.gapLg),
            const Divider(height: 1),
            SizedBox(height: LayoutTokens.gapLg),
            _LoginFooterLinks(
              onRegister: onRegister,
              onForgotPassword: onForgotPassword,
            ),
          ],
        ),
      ),
    );
  }
}

/// 用户名输入框
class _LoginUsernameField extends StatelessWidget {
  const _LoginUsernameField({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: '账号',
        hintText: '请输入用户名或工号',
        prefixIcon: const Icon(Icons.person_outline),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1,
          ),
        ),
      ),
      onFieldSubmitted: (_) => onSubmitted(),
      validator: FormValidators.required('请输入账号'),
    );
  }
}

/// 密码输入框
class _LoginPasswordField extends StatelessWidget {
  const _LoginPasswordField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onVisibilityToggle,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '请输入登录密码',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: onVisibilityToggle,
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(LayoutTokens.radiusSm),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1,
          ),
        ),
      ),
      onFieldSubmitted: (_) => onSubmitted(),
      validator: FormValidators.required('请输入密码'),
    );
  }
}

/// 登录提交按钮
class _LoginSubmitButton extends StatelessWidget {
  const _LoginSubmitButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedButton(
        onPressed: isLoading ? null : onPressed,
        loading: isLoading,
        width: double.infinity,
        size: AnimatedButtonSize.large,
        child: const Text('登录'),
      ),
    );
  }
}

/// 登录页底部链接
class _LoginFooterLinks extends StatelessWidget {
  const _LoginFooterLinks({
    required this.onRegister,
    required this.onForgotPassword,
  });

  final VoidCallback onRegister;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '还没有账号？',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.subtleText,
              ),
            ),
            TextButton(
              onPressed: onRegister,
              child: const Text('注册'),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          icon: Icon(
            Icons.help_outline,
            size: LayoutTokens.iconMd,
            color: colors.subtleText,
          ),
          label: Text(
            '忘记密码请联系管理员',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.subtleText,
            ),
          ),
        ),
      ],
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