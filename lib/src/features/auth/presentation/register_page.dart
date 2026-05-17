import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';
import 'package:work_order_app/src/features/auth/presentation/widgets/auth_card.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

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
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
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
                    title: '注册',
                    formKey: _formKey,
                    footer: _RegisterFooterLinks(
                      onLogin: () => context.go('/login'),
                    ),
                    children: Column(
                      children: [
                        _RegisterUsernameField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          onSubmitted: () => _passwordFocus.requestFocus(),
                        ),
                        SizedBox(height: LayoutTokens.gapLg),
                        _RegisterPasswordField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          onVisibilityToggle: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                          onSubmitted: () => _confirmFocus.requestFocus(),
                        ),
                        SizedBox(height: LayoutTokens.gapLg),
                        _RegisterConfirmField(
                          controller: _confirmController,
                          focusNode: _confirmFocus,
                          obscureText: _obscureConfirm,
                          onVisibilityToggle: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                          onSubmitted: _register,
                          passwordController: _passwordController,
                        ),
                        SizedBox(height: LayoutTokens.gapLg + LayoutTokens.gapXs),
                        _RegisterSubmitButton(
                          isLoading: _isLoading,
                          onPressed: _register,
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

  Future<void> _register() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final user = User();
    user.userName = _usernameController.text;
    user.password = _passwordController.text;

    try {
      await context.read<AuthViewModel>().register(user);
      if (!mounted) return;
      ToastUtil.showSuccess('账号已创建，请登录');
      context.go('/login');
    } on ApiException catch (err) {
      ToastUtil.showError(
        err.message.isNotEmpty ? err.message : '注册失败，请检查输入信息',
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _RegisterUsernameField extends StatelessWidget {
  const _RegisterUsernameField({
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
        hintText: '建议使用姓名拼音或工号',
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

class _RegisterPasswordField extends StatelessWidget {
  const _RegisterPasswordField({
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '设置登录密码',
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

class _RegisterConfirmField extends StatelessWidget {
  const _RegisterConfirmField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onVisibilityToggle,
    required this.onSubmitted,
    required this.passwordController,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onVisibilityToggle;
  final VoidCallback onSubmitted;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: '确认密码',
        hintText: '再次输入密码',
        prefixIcon: const Icon(Icons.verified_user_outlined),
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
      validator: FormValidators.compose<String>([
        FormValidators.required('请再次输入密码'),
        FormValidators.sameAs(
          () => passwordController.text,
          message: '两次密码不一致',
        ),
      ]),
    );
  }
}

class _RegisterSubmitButton extends StatelessWidget {
  const _RegisterSubmitButton({
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
        child: const Text('注册'),
      ),
    );
  }
}

class _RegisterFooterLinks extends StatelessWidget {
  const _RegisterFooterLinks({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '已有账号？',
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: onLogin,
          child: const Text('返回登录'),
        ),
      ],
    );
  }
}