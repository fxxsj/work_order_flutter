import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

/// 客户编辑页，支持新增与编辑。
class CustomerEditPage extends StatefulWidget {
  const CustomerEditPage({super.key, this.customer});

  final Customer? customer;

  @override
  State<CustomerEditPage> createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> {
  final _formKey = GlobalKey<FormState>();
  static const double _padding = 16;
  static const double _sectionSpacing = 16;
  static const double _actionSpacing = 24;
  static const double _loadingIndicatorSize = 14;
  static const double _submitIndicatorSize = 20;
  static const double _indicatorStrokeWidth = 2;
  static const double _inlineSpacing = 8;

  static const String _createTitle = '新增客户';
  static const String _editTitle = '编辑客户';
  static const String _nameLabel = '客户名称';
  static const String _contactLabel = '联系人';
  static const String _phoneLabel = '联系电话';
  static const String _emailLabel = '邮箱';
  static const String _salespersonLabel = '业务员';
  static const String _addressLabel = '地址';
  static const String _notesLabel = '备注';
  static const String _noSalespersonText = '不指定';
  static const String _loadingSalespersonsText = '正在加载业务员列表...';
  static const String _submitCreateText = '创建客户';
  static const String _submitUpdateText = '保存修改';
  static const String _submitErrorText = '操作失败: ';
  static const String _nameRequiredText = '请输入客户名称';
  static const String _nameLengthText = '客户名称至少需要2个字符';
  static const String _phoneInvalidText = '电话号码格式不正确';
  static const String _emailInvalidText = '请输入正确的邮箱地址';

  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  int? _salespersonId;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _nameController = TextEditingController(text: customer?.name ?? '');
    _contactController = TextEditingController(text: customer?.contactPerson ?? '');
    _phoneController = TextEditingController(text: customer?.phone ?? '');
    _emailController = TextEditingController(text: customer?.email ?? '');
    _addressController = TextEditingController(text: customer?.address ?? '');
    _notesController = TextEditingController(text: customer?.notes ?? '');
    _salespersonId = customer?.salespersonId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(CustomerViewModel viewModel) async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);

    String? salespersonName;
    if (_salespersonId != null) {
      for (final item in viewModel.salespersons) {
        if (item.id == _salespersonId) {
          salespersonName = item.name;
          break;
        }
      }
    }

    final payload = Customer(
      id: widget.customer?.id ?? 0,
      name: _nameController.text.trim(),
      contactPerson: _contactController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      salespersonId: _salespersonId,
      salespersonName: salespersonName,
      createdAt: widget.customer?.createdAt,
      updatedAt: widget.customer?.updatedAt,
    );

    try {
      if (widget.customer == null) {
        await viewModel.createCustomer(payload);
      } else {
        await viewModel.updateCustomer(payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$_submitErrorText$err')),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CustomerViewModel>();
    final salespersons = viewModel.salespersons;
    final salespersonsError = viewModel.salespersonsError;
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(_padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: _inlineSpacing),
                  Text(
                    widget.customer == null ? _createTitle : _editTitle,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: _nameLabel,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return _nameRequiredText;
                  }
                  if (text.length < 2) {
                    return _nameLengthText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: _contactLabel,
                  border: OutlineInputBorder(),
                ),
                validator: (_) => null,
              ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: _phoneLabel,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return null;
                  }
                  final phoneRegex = RegExp(r'^[\d\-+() ]+$');
                  if (!phoneRegex.hasMatch(text)) {
                    return _phoneInvalidText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: _emailLabel,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return null;
                  }
                  final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                  if (!emailRegex.hasMatch(text)) {
                    return _emailInvalidText;
                  }
                  return null;
                },
              ),
              const SizedBox(height: _sectionSpacing),
              DropdownButtonFormField<int?>(
                value: _salespersonId,
                decoration: const InputDecoration(
                  labelText: _salespersonLabel,
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text(_noSalespersonText),
                  ),
                  ...salespersons.map(
                    (item) => DropdownMenuItem<int?>(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _salespersonId = value;
                  });
                },
                validator: (_) => null,
              ),
              if (viewModel.loadingSalespersons)
                const Padding(
                  padding: EdgeInsets.only(top: _sectionSpacing),
                  child: Row(
                    children: [
                      SizedBox(
                        width: _loadingIndicatorSize,
                        height: _loadingIndicatorSize,
                        child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                      ),
                      SizedBox(width: _inlineSpacing),
                      Text(_loadingSalespersonsText),
                    ],
                  ),
                )
              else if (salespersonsError != null && salespersonsError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: _sectionSpacing),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          salespersonsError,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                        ),
                      ),
                      TextButton(
                        onPressed: viewModel.loadSalespersons,
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: _addressLabel,
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (_) => null,
              ),
              const SizedBox(height: _sectionSpacing),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: _notesLabel,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (_) => null,
              ),
              const SizedBox(height: _actionSpacing),
              FilledButton(
                onPressed: _submitting ? null : () => _handleSubmit(viewModel),
                child: _submitting
                    ? const SizedBox(
                        height: _submitIndicatorSize,
                        width: _submitIndicatorSize,
                        child: CircularProgressIndicator(strokeWidth: _indicatorStrokeWidth),
                      )
                    : Text(widget.customer == null ? _submitCreateText : _submitUpdateText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
