import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/presentation/widgets/auth_card.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const AuthBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: LayoutTokens.gapLg,
                  vertical: LayoutTokens.gapXl,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: AuthCard(
                    title: '登录',
                    formKey: _formKey,
                    footer: _LoginFooterLinks(
                      onRegister: () => context.go('/register'),
                      onForgotPassword: () {},
                    ),
                    children: Column(
                      children: [
                        _LoginUsernameField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          onSubmitted: () => _passwordFocus.requestFocus(),
                        ),
                        SizedBox(height: LayoutTokens.gapLg),
                        _LoginPasswordField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          onVisibilityToggle: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                          onSubmitted: _login,
                        ),
                        SizedBox(height: LayoutTokens.gapLg + LayoutTokens.gapXs),
                        _LoginSubmitButton(
                          isLoading: _isLoading,
                          onPressed: _login,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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