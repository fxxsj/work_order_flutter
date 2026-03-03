import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';
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

  @override
  void initState() {
    super.initState();
    passwordController.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final savedUsername = context.read<AuthViewModel>().readRememberedUsername();
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
    final background = colors.background;
    final surface = colors.surface;
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              color: surface,
              elevation: 10,
              shadowColor: Colors.black.withOpacity(0.15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '新西彩订单管理',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '请输入账号与密码登录',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            focusNode: focusNodeUserName,
                            controller: userNameController,
                            decoration: const InputDecoration(
                              labelText: '账号',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            onFieldSubmitted: (_) => focusNodePassword.requestFocus(),
                            validator: (v) => (v == null || v.isEmpty) ? '请输入账号' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            focusNode: focusNodePassword,
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '密码',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            onFieldSubmitted: (_) {
                              if (!_isLoading) {
                                _login();
                              }
                            },
                            validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _isLoading ? null : _login,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('登录'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _register,
                          child: Text('注册账号', style: TextStyle(color: primary)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('忘记密码'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
