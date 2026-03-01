import 'package:flutter/material.dart';
import 'package:work_order_app/api/auth_api.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/common/theme_ext.dart';
import 'package:work_order_app/models/api_response.dart';
import 'package:work_order_app/models/user.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:get/get.dart';

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
    final savedUsername = StoreUtil.read(Constant.KEY_REMEMBER_USERNAME);
    userNameController.text = savedUsername ?? '';
    passwordController.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (userNameController.text.isNotEmpty) {
          focusNodePassword.requestFocus();
        } else {
          focusNodeUserName.requestFocus();
        }
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
    appRouter.go('/register');
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
      final ApiResponse responseBodyApi = await AuthApi.login({
        'username': user.userName,
        'password': user.password,
      });
      if (!responseBodyApi.success) {
        Get.snackbar('登录失败', responseBodyApi.message ?? '请检查账号密码', snackPosition: SnackPosition.BOTTOM);
        focusNodePassword.requestFocus();
        return;
      }
      final responseData = responseBodyApi.data;
      final responseMap = responseData is Map ? Map<String, dynamic>.from(responseData) : <String, dynamic>{};
      String? token;
      final directToken = responseMap['token'] ??
          responseMap['access'] ??
          responseMap['access_token'] ??
          responseMap['auth_token'];
      if (directToken != null) {
        token = directToken.toString();
      } else if (responseMap['data'] is Map) {
        final inner = Map<String, dynamic>.from(responseMap['data'] as Map);
        final innerToken = inner['token'] ?? inner['access'] ?? inner['access_token'] ?? inner['auth_token'];
        if (innerToken != null) {
          token = innerToken.toString();
        }
      }
      if (token == null || token.toString().isEmpty) {
        Get.snackbar('登录失败', '请检查账号密码', snackPosition: SnackPosition.BOTTOM);
        focusNodePassword.requestFocus();
        return;
      }
      responseMap['token'] = token;
      _loginSuccess(responseMap);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loginSuccess(Map<String, dynamic> responseData) {
    StoreUtil.write(Constant.KEY_TOKEN, responseData['token']);
    StoreUtil.write(Constant.KEY_REMEMBER_USERNAME, userNameController.text);
    var userInfo = Map<String, dynamic>.from(responseData);
    if (responseData.containsKey('username')) {
      userInfo['userName'] = responseData['username'];
    }
    if (responseData.containsKey('full_name')) {
      userInfo['name'] = responseData['full_name'];
    }
    StoreUtil.write(Constant.KEY_CURRENT_USER_INFO, userInfo);
    StoreUtil.init();

    appRouter.go('/');
  }
}
