import 'package:flutter/material.dart';
import 'package:work_order_app/api/auth_api.dart';
import 'package:work_order_app/common/api_exception.dart';
import 'package:work_order_app/constants/constant.dart';
import 'package:work_order_app/router/app_router.dart';
import 'package:work_order_app/utils/store_util.dart';
import 'package:work_order_app/utils/toast_util.dart';
import 'package:work_order_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/controllers/auth_controller.dart';

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
    _loadUser();
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
    final cached = StoreUtil.read(Constant.KEY_CURRENT_USER_INFO);
    if (cached is Map) {
      _setUser(Map<String, dynamic>.from(cached));
    }
    if (_currentUser.isEmpty) {
      await _fetchUserFromApi();
    }
  }

  Future<void> _fetchUserFromApi() async {
    try {
      final result = await AuthApi.getCurrentUser();
      if (result.data is Map) {
        final map = Map<String, dynamic>.from(result.data as Map);
        _setUser(map);
        StoreUtil.write(Constant.KEY_CURRENT_USER_INFO, map);
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
    return (_currentUser['username'] ?? _currentUser['userName'] ?? '').toString();
  }

  List<String> _groups() {
    final groups = _currentUser['groups'];
    if (groups is List) {
      return groups.map((e) => e.toString()).toList();
    }
    return [];
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
      final payload = {
        'email': _emailController.text.trim(),
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
      };
      final result = await AuthApi.updateProfile(payload);
      final data = result.data is Map ? Map<String, dynamic>.from(result.data as Map) : <String, dynamic>{};
      final merged = {..._currentUser, ...data};
      _setUser(merged);
      StoreUtil.write(Constant.KEY_CURRENT_USER_INFO, merged);
      final message = (result.message?.trim().isNotEmpty ?? false)
          ? result.message!.trim()
          : '个人信息更新成功';
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
      final payload = {
        'old_password': _oldPasswordController.text,
        'new_password': _newPasswordController.text,
        'confirm_password': _confirmPasswordController.text,
      };
      final result = await AuthApi.changePassword(payload);
      final message = (result.message?.trim().isNotEmpty ?? false)
          ? result.message!.trim()
          : '密码修改成功，请重新登录';
      ToastUtil.showSuccess(message);
      _resetPasswordForm();
      await Future<void>.delayed(const Duration(seconds: 2));
      Utils.logout(context.read<AuthController>());
      appRouter.go('/login');
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
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('个人信息', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('基本信息'),
                  selected: _activeTab == 0,
                  onSelected: (_) => setState(() => _activeTab = 0),
                ),
                ChoiceChip(
                  label: const Text('修改密码'),
                  selected: _activeTab == 1,
                  onSelected: (_) => setState(() => _activeTab = 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
    final theme = Theme.of(context);
    return Form(
      key: _profileFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: _username(),
            enabled: false,
            decoration: const InputDecoration(labelText: '用户名'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: '邮箱'),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final emailRegex = RegExp(r'^\S+@\S+\.\S+$');
              if (!emailRegex.hasMatch(value)) {
                return '请输入正确的邮箱地址';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: '姓'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: '名'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ..._groups().map((role) => Chip(label: Text(role))),
              if (_isSuperUser()) const Chip(label: Text('超级管理员')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _updatingProfile ? null : _handleUpdateProfile,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _updatingProfile
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                        ),
                      )
                    : const Text('保存修改'),
              ),
              const SizedBox(width: 12),
              TextButton(onPressed: _resetProfileForm, child: const Text('重置')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordForm(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _oldPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: '旧密码'),
            validator: (value) => value == null || value.isEmpty ? '请输入旧密码' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: '新密码'),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入新密码';
              if (value.length < 6) return '密码长度至少为6位';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: '确认密码'),
            validator: (value) {
              if (value == null || value.isEmpty) return '请再次输入新密码';
              if (value != _newPasswordController.text) return '两次输入的密码不一致';
              return null;
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _changingPassword ? null : _handleChangePassword,
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: _changingPassword
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.onPrimary),
                    ),
                  )
                : const Text('修改密码'),
          ),
        ],
      ),
    );
  }

}
