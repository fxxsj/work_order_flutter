import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';
import 'package:work_order_app/src/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FocusNode focusNodeUserName = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final User user = User();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    passwordController.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final savedUsername =
          context.read<AuthViewModel>().readRememberedUsername();
      userNameController.text = savedUsername ?? '';
      if (userNameController.text.isNotEmpty) {
        focusNodePassword.requestFocus();
      } else {
        focusNodeUserName.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    focusNodeUserName.dispose();
    focusNodePassword.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return AuthScaffold(
      title: '登录',
      heroTitle: '订单工作台',
      form: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              focusNode: focusNodeUserName,
              controller: userNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '账号',
                hintText: '请输入用户名或工号',
                prefixIcon: Icon(Icons.person_outline),
              ),
              onFieldSubmitted: (_) => focusNodePassword.requestFocus(),
              validator: (v) => (v == null || v.isEmpty) ? '请输入账号' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: focusNodePassword,
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: '密码',
                hintText: '请输入登录密码',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              onFieldSubmitted: (_) {
                if (!_isLoading) {
                  _login();
                }
              },
              validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _login,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(LayoutTokens.radiusLg),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Text('登录'),
              ),
            ),
          ],
        ),
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('还没有账号？',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colors.subtleText)),
              TextButton(
                onPressed: _register,
                child: const Text('注册'),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            icon: Icon(Icons.help_outline, size: 18, color: colors.subtleText),
            label: Text(
              '忘记密码请联系管理员',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colors.subtleText),
            ),
          ),
        ],
      ),
    );
  }

  void _register() {
    context.go('/register');
  }

  Future<void> _login() async {
    final form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    user.userName = userNameController.text;
    user.password = passwordController.text;
    try {
      await context.read<AuthViewModel>().login(
            username: user.userName ?? '',
            password: user.password ?? '',
            rememberUsername: true,
          );
      if (!mounted) return;
      context.go('/');
    } on ApiException catch (err) {
      ToastUtil.showError(err.message.isNotEmpty ? err.message : '请检查账号密码');
      focusNodePassword.requestFocus();
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
