import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/common/api_exception.dart';
import 'package:go_router/go_router.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/animated_button.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_mode_toggle.dart';
import 'package:work_order_app/src/features/auth/application/auth_controller.dart';
import 'package:work_order_app/src/features/auth/application/auth_view_model.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/core/utils/role_labels.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _updatingProfile = false;
  bool _changingPassword = false;
  int _activeTab = 0;

  Map<String, dynamic> _currentUser = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUser();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final user = await context.read<AuthViewModel>().loadCurrentUser();
      if (mounted && user.isNotEmpty) {
        _setUser(user);
      }
    } catch (_) {
      // ignore fetch errors for now
    }
  }

  void _setUser(Map<String, dynamic> user) {
    setState(() {
      _currentUser = user;
    });
    _emailController.text = user['email']?.toString() ?? '';
    _firstNameController.text = user['first_name']?.toString() ?? '';
    _lastNameController.text = user['last_name']?.toString() ?? '';
  }

  String _username() {
    return (_currentUser['username'] ?? _currentUser['userName'] ?? '')
        .toString();
  }

  List<String> _roleCodes() {
    final roleCodes = _currentUser['role_codes'];
    if (roleCodes is List) {
      return roleCodes.map((e) => e.toString()).toList();
    }
    return [];
  }

  List<String> _departments() {
    final departments = _currentUser['departments'];
    if (departments is List) {
      return departments.map((e) => e.toString()).toList();
    }
    return [];
  }

  int _permissionCount() {
    final permissions = _currentUser['permissions'];
    if (permissions is List) {
      return permissions.length;
    }
    return 0;
  }

  bool _isSuperUser() {
    final value = _currentUser['is_superuser'];
    return value == true;
  }

  Future<void> _handleUpdateProfile() async {
    final form = _profileFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() {
      _updatingProfile = true;
    });
    try {
      final merged = await context.read<AuthViewModel>().updateProfile(
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          );
      _setUser(merged);
      final message = '个人信息更新成功';
      ToastUtil.showSuccess(message);
    } on ApiException catch (err) {
      ToastUtil.showError(err.message.isNotEmpty ? err.message : '个人信息更新失败');
    } finally {
      if (mounted) {
        setState(() {
          _updatingProfile = false;
        });
      }
    }
  }

  Future<void> _handleChangePassword() async {
    final form = _passwordFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() {
      _changingPassword = true;
    });
    try {
      await context.read<AuthViewModel>().changePassword(
            oldPassword: _oldPasswordController.text,
            newPassword: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
      final message = '密码修改成功，请重新登录';
      ToastUtil.showSuccess(message);
      _resetPasswordForm();
      await Future<void>.delayed(const Duration(seconds: 2));
      await context.read<AuthController>().handleLogout();
      if (!mounted) return;
      context.go('/login');
    } on ApiException catch (err) {
      ToastUtil.showError(err.message.isNotEmpty ? err.message : '密码修改失败');
    } finally {
      if (mounted) {
        setState(() {
          _changingPassword = false;
        });
      }
    }
  }

  void _resetProfileForm() {
    _emailController.text = _currentUser['email']?.toString() ?? '';
    _firstNameController.text = _currentUser['first_name']?.toString() ?? '';
    _lastNameController.text = _currentUser['last_name']?.toString() ?? '';
    ToastUtil.showSuccess('已恢复为原始信息');
  }

  void _resetPasswordForm() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.cardColor;
    final borderColor = theme.dividerColor;

    return Card(
      elevation: 0,
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(LayoutTokens.gapLg + LayoutTokens.gapXs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('个人信息',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: LayoutTokens.gapLg),
            PageModeToggle<int>(
              value: _activeTab,
              options: const [
                PageModeOption(value: 0, label: '基本信息'),
                PageModeOption(value: 1, label: '修改密码'),
              ],
              onChanged: (value) => setState(() => _activeTab = value),
            ),
            SizedBox(height: LayoutTokens.gapLg),
            IndexedStack(
              index: _activeTab,
              children: [
                _buildProfileForm(context),
                _buildPasswordForm(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Form(
      key: _profileFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CrudFieldConfig.text(
            label: '用户名',
            initialValue: _username(),
            enabled: false,
          ).build(context),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.email(
            label: '邮箱',
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
              if (!emailRegex.hasMatch(value)) {
                return '请输入正确的邮箱地址';
              }
              return null;
            },
          ).build(context),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.text(label: '姓', controller: _lastNameController)
              .build(context),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.text(label: '名', controller: _firstNameController)
              .build(context),
          SizedBox(height: LayoutTokens.gapMd),
          Wrap(
            spacing: 8,
            children: [
              ..._roleCodes().map((code) => Chip(label: Text(RoleLabels.label(code)))),
              if (_isSuperUser()) const Chip(label: Text('超级管理员')),
            ],
          ),
          SizedBox(height: LayoutTokens.gapMd),
          Text(
            '所属部门：${_departments().isEmpty ? '未配置' : _departments().join('、')}',
          ),
          SizedBox(height: LayoutTokens.gapSm),
          Text(
            _isSuperUser()
                ? '权限范围：超级管理员，默认可见全部菜单'
                : '权限范围：已同步 ${_permissionCount()} 项权限，侧边栏会按当前账号能力收敛显示',
          ),
          SizedBox(height: LayoutTokens.gapLg),
          Row(
            children: [
              AnimatedButton(
                onPressed: _handleUpdateProfile,
                loading: _updatingProfile,
                child: const Text('保存修改'),
              ),
              SizedBox(width: LayoutTokens.gapMd),
              TextButton(onPressed: _resetProfileForm, child: const Text('重置')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(BuildContext context) {
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CrudFieldConfig.text(
            label: '旧密码',
            controller: _oldPasswordController,
            obscureText: true,
            validator: (value) =>
                value == null || value.isEmpty ? '请输入旧密码' : null,
          ).build(context),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.text(
            label: '新密码',
            controller: _newPasswordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入新密码';
              if (value.length < 6) return '密码长度至少为6位';
              return null;
            },
          ).build(context),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.text(
            label: '确认密码',
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return '请再次输入新密码';
              if (value != _newPasswordController.text) return '两次输入的密码不一致';
              return null;
            },
          ).build(context),
          SizedBox(height: LayoutTokens.gapLg),
          AnimatedButton(
            onPressed: _handleChangePassword,
            loading: _changingPassword,
            child: const Text('修改密码'),
          ),
        ],
      ),
    );
  }
}
