import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/common/theme_ext.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
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
            CrudFieldConfig.text(
              label: '账号',
              controller: userNameController,
              textInputAction: TextInputAction.next,
              hintText: '请输入用户名或工号',
              prefixIcon: const Icon(Icons.person_outline),
              onFieldSubmitted: (_) => focusNodePassword.requestFocus(),
              validator: FormValidators.required('请输入账号'),
            ).build(context),
            SizedBox(height: LayoutTokens.gapLg),
            CrudFieldConfig.text(
              label: '密码',
              controller: passwordController,
              obscureText: _obscurePassword,
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
              onFieldSubmitted: (_) {
                if (!_isLoading) {
                  _login();
                }
              },
              validator: FormValidators.required('请输入密码'),
            ).build(context),
            SizedBox(height: LayoutTokens.gapLg + LayoutTokens.gapXs),
            SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                onPressed: _login,
                loading: _isLoading,
                width: double.infinity,
                size: AnimatedButtonSize.large,
                child: const Text('登录'),
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
            icon: Icon(
              Icons.help_outline,
              size: LayoutTokens.iconMd,
              color: colors.subtleText,
            ),
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
