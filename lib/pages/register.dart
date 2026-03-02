import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:work_order_app/api/user_api.dart';
import 'package:work_order_app/common/api_exception.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/models/user.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/utils/toast_util.dart';

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
    final colors = theme.extension<AppColors>()!;
    final background = colors.background;
    final surface = colors.surface;

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
                      '创建新账号',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '快速接入工单协作网络',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                              labelText: '账号',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? '请输入账号' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '密码',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? '请输入密码' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: confirmController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: '确认密码',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            validator: (v) => v == passwordController.text ? null : '两次密码不一致',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _register,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('注册'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _login,
                      child: const Text('已有账号，去登录'),
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

  void _login() {
    context.go('/login');
  }

  Future<void> _register() async {
    final form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    user.userName = userNameController.text;
    user.password = passwordController.text;

    Map<String, dynamic> map = user.toMap();
    map['file'] = null;
    FormData formData = FormData.fromMap(map);

    try {
      final userApi = context.read<UserApi>();
      await userApi.register(formData);
      _login();
      ToastUtil.showSuccess('账号已创建，请登录');
    } on ApiException catch (err) {
      ToastUtil.showError(err.message.isNotEmpty ? err.message : '注册失败，请检查输入信息');
    }
  }
}
