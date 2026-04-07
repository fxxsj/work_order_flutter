import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/utils/validators.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/features/auth/domain/user.dart';
import 'package:work_order_app/src/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final User user = User();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userNameController.text = user.userName ?? '';
    passwordController.text = user.password ?? '';
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuthScaffold(
      title: '注册',
      heroTitle: '账号开通',
      form: Form(
        key: formKey,
        child: Column(
          children: [
            CrudFormField.text(
              label: '账号',
              controller: userNameController,
              textInputAction: TextInputAction.next,
              hintText: '建议使用姓名拼音或工号',
              prefixIcon: const Icon(Icons.person_outline),
              validator: FormValidators.required('请输入账号'),
            ).build(context),
            SizedBox(height: LayoutTokens.gapLg),
            CrudFormField.text(
              label: '密码',
              controller: passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              hintText: '设置登录密码',
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
              validator: FormValidators.required('请输入密码'),
            ).build(context),
            SizedBox(height: LayoutTokens.gapLg),
            CrudFormField.text(
              label: '确认密码',
              controller: confirmController,
              obscureText: _obscureConfirm,
              hintText: '再次输入密码',
              prefixIcon: const Icon(Icons.verified_user_outlined),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
              validator: FormValidators.compose<String>([
                FormValidators.required('请再次输入密码'),
                FormValidators.sameAs(
                  () => passwordController.text,
                  message: '两次密码不一致',
                ),
              ]),
            ).build(context),
            SizedBox(height: LayoutTokens.gapLg + LayoutTokens.gapXs),
            SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                onPressed: _register,
                loading: _isLoading,
                width: double.infinity,
                size: AnimatedButtonSize.large,
                child: const Text('注册'),
              ),
            ),
          ],
        ),
      ),
      footer: Row(
        children: [
          Text('已有账号？', style: theme.textTheme.bodyMedium),
          TextButton(
            onPressed: _login,
            child: const Text('返回登录'),
          ),
        ],
      ),
    );
  }

  void _login() {
    context.go('/login');
  }

  Future<void> _register() async {
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
      await context.read<AuthViewModel>().register(user);
      if (!mounted) return;
      _login();
      ToastUtil.showSuccess('账号已创建，请登录');
    } on ApiException catch (err) {
      ToastUtil.showError(
          err.message.isNotEmpty ? err.message : '注册失败，请检查输入信息');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
