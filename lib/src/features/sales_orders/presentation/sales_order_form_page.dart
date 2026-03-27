import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/searchable_dropdown.dart';
import 'package:work_order_app/src/core/utils/breakpoints_util.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/sales_orders/application/sales_order_view_model.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_api_service.dart';
import 'package:work_order_app/src/features/sales_orders/data/sales_order_repository_impl.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_detail.dart';
import 'package:work_order_app/src/features/sales_orders/domain/sales_order_repository.dart';
import 'package:work_order_app/src/features/workorders/data/work_order_flow_api_service.dart';

enum SalesOrderFormMode { create, edit }

class SalesOrderFormEntry extends StatelessWidget {
  const SalesOrderFormEntry({super.key, required this.mode, this.orderId});

  final SalesOrderFormMode mode;
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return FeatureEntry<SalesOrderApiService, SalesOrderRepository,
        SalesOrderViewModel>(
      createService: (context) =>
          SalesOrderApiService(context.read<ApiClient>()),
      createRepository: (context) => SalesOrderRepositoryImpl(
        context.read<SalesOrderApiService>(),
        WorkOrderFlowApiService(context.read<ApiClient>()),
      ),
      createViewModel: (context) =>
          SalesOrderViewModel(context.read<SalesOrderRepository>()),
      child: SalesOrderFormPage(mode: mode, orderId: orderId),
    );
  }
}

class SalesOrderFormPage extends StatefulWidget {
  const SalesOrderFormPage({super.key, required this.mode, this.orderId});

  final SalesOrderFormMode mode;
  final int? orderId;

  @override
  State<SalesOrderFormPage> createState() => _SalesOrderFormPageState();
}

class _SalesOrderFormPageState extends State<SalesOrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  static const double _spacing = 12;
  static const double _sectionSpacing = 16;

  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _taxRateController =
      TextEditingController(text: '0');
  final TextEditingController _discountAmountController =
      TextEditingController(text: '0');
  final TextEditingController _depositAmountController =
      TextEditingController(text: '0');
  final TextEditingController _paidAmountController =
      TextEditingController(text: '0');

  DateTime? _orderDate;
  DateTime? _deliveryDate;
  int? _customerId;
  String _status = 'draft';
  String _paymentStatus = 'unpaid';

  int? _autoFilledCustomerId;
  String _autoFilledContactPerson = '';
  String _autoFilledContactPhone = '';
  String _autoFilledShippingAddress = '';

  List<Customer> _customers = [];
  List<ProductOption> _products = [];
  final List<_ItemDraft> _itemDrafts = [];

  bool _loadingOptions = false;
  bool _loadingDetail = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _orderDate = DateTime.now();
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
    _loadOptions();
    if (widget.mode == SalesOrderFormMode.edit && widget.orderId != null) {
      _loadDetail(widget.orderId!);
    } else {
      _itemDrafts.add(_ItemDraft());
    }
  }

  @override
  void dispose() {
    _orderDateController.dispose();
    _deliveryDateController.dispose();
    _contactPersonController.dispose();
    _contactPhoneController.dispose();
    _shippingAddressController.dispose();
    _notesController.dispose();
    _taxRateController.dispose();
    _discountAmountController.dispose();
    _depositAmountController.dispose();
    _paidAmountController.dispose();
    for (final draft in _itemDrafts) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() => _loadingOptions = true);
    final apiClient = context.read<ApiClient>();
    final customerApi = CustomerApiService(apiClient);
    final productApi = ProductApiService(apiClient);
    try {
      final customerFuture = customerApi.fetchCustomers(page: 1, pageSize: 200);
      final productFuture =
          productApi.fetchProducts(pageSize: 200, isActive: true);
      final customerPage = await customerFuture;
      final productOptions = await productFuture;
      setState(() {
        _customers = customerPage.items.map((item) => item.toEntity()).toList();
        _products = productOptions;
      });
    } catch (err) {
      ToastUtil.showError('加载基础数据失败: $err');
    } finally {
      if (mounted) setState(() => _loadingOptions = false);
    }
  }

  Future<void> _loadDetail(int id) async {
    setState(() => _loadingDetail = true);
    try {
      final viewModel = context.read<SalesOrderViewModel>();
      final detail = await viewModel.fetchDetail(id);
      _applyDetail(detail);
    } catch (err) {
      ToastUtil.showError('加载客户订单失败: $err');
    } finally {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  void _applyDetail(SalesOrderDetail detail) {
    _customerId = detail.customerId;
    _status = detail.status ?? _status;
    _paymentStatus = detail.paymentStatus ?? _paymentStatus;
    _orderDate = detail.orderDate;
    _deliveryDate = detail.deliveryDate;
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
    _contactPersonController.text = detail.contactPerson ?? '';
    _contactPhoneController.text = detail.contactPhone ?? '';
    _shippingAddressController.text = detail.shippingAddress ?? '';
    _notesController.text = detail.notes ?? '';
    if (detail.taxRate != null) {
      _taxRateController.text = detail.taxRate!.toStringAsFixed(2);
    }
    if (detail.discountAmount != null) {
      _discountAmountController.text =
          detail.discountAmount!.toStringAsFixed(2);
    }
    if (detail.depositAmount != null) {
      _depositAmountController.text = detail.depositAmount!.toStringAsFixed(2);
    }
    if (detail.paidAmount != null) {
      _paidAmountController.text = detail.paidAmount!.toStringAsFixed(2);
    }

    _itemDrafts.clear();
    for (final item in detail.items) {
      _itemDrafts.add(_ItemDraft.fromDetail(item, detail.taxRate));
    }
    if (_itemDrafts.isEmpty) {
      _itemDrafts.add(_ItemDraft());
    }
    _autoFilledCustomerId = _customerId;
    _autoFilledContactPerson = _contactPersonController.text.trim();
    _autoFilledContactPhone = _contactPhoneController.text.trim();
    _autoFilledShippingAddress = _shippingAddressController.text.trim();
    setState(() {});
  }

  bool _shouldOverwriteAutoField(String currentValue, String lastAutoValue) {
    final trimmed = currentValue.trim();
    if (trimmed.isEmpty) {
      return true;
    }
    if (_autoFilledCustomerId != null && trimmed == lastAutoValue) {
      return true;
    }
    return false;
  }

  void _applyCustomerContactInfo(Customer customer) {
    final contactPerson = customer.contactPerson?.trim() ?? '';
    final contactPhone = customer.phone?.trim() ?? '';
    final shippingAddress = customer.address?.trim() ?? '';

    if (_shouldOverwriteAutoField(
        _contactPersonController.text, _autoFilledContactPerson)) {
      _contactPersonController.text = contactPerson;
    }
    if (_shouldOverwriteAutoField(
        _contactPhoneController.text, _autoFilledContactPhone)) {
      _contactPhoneController.text = contactPhone;
    }
    if (_shouldOverwriteAutoField(
        _shippingAddressController.text, _autoFilledShippingAddress)) {
      _shippingAddressController.text = shippingAddress;
    }

    _autoFilledCustomerId = customer.id;
    _autoFilledContactPerson = contactPerson;
    _autoFilledContactPhone = contactPhone;
    _autoFilledShippingAddress = shippingAddress;
  }

  void _handleCustomerChanged(int? customerId) {
    setState(() => _customerId = customerId);
    if (customerId == null) return;
    if (widget.mode != SalesOrderFormMode.create &&
        _autoFilledCustomerId == null) {
      return;
    }
    final customer = _customers
        .cast<Customer?>()
        .firstWhere((item) => item?.id == customerId, orElse: () => null);
    if (customer == null) return;
    _applyCustomerContactInfo(customer);
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<void> _pickDate({required bool isOrderDate}) async {
    final initial = isOrderDate
        ? (_orderDate ?? DateTime.now())
        : (_deliveryDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isOrderDate) {
        _orderDate = picked;
        _orderDateController.text = _formatDate(picked);
      } else {
        _deliveryDate = picked;
        _deliveryDateController.text = _formatDate(picked);
      }
    });
  }

  Map<String, dynamic> _buildPayload() {
    final orderDate = _formatDate(_orderDate);
    final deliveryDate = _formatDate(_deliveryDate);
    final items = _itemDrafts
        .where((draft) => draft.productId != null)
        .map(
          (draft) => {
            'product': draft.productId,
            'quantity': draft.quantityValue,
            'unit': draft.unitValue,
            'unit_price': draft.unitPriceValue,
            'tax_rate': draft.taxRateValue,
            'discount_amount': draft.discountAmountValue,
            'notes': draft.notesValue,
          },
        )
        .toList();

    return {
      'customer': _customerId,
      'status': _status,
      'payment_status': _paymentStatus,
      'order_date': orderDate.isEmpty ? null : orderDate,
      'delivery_date': deliveryDate.isEmpty ? null : deliveryDate,
      'tax_rate': double.tryParse(_taxRateController.text.trim()) ?? 0,
      'discount_amount':
          double.tryParse(_discountAmountController.text.trim()) ?? 0,
      'deposit_amount':
          double.tryParse(_depositAmountController.text.trim()) ?? 0,
      'paid_amount': double.tryParse(_paidAmountController.text.trim()) ?? 0,
      'contact_person': _contactPersonController.text.trim(),
      'contact_phone': _contactPhoneController.text.trim(),
      'shipping_address': _shippingAddressController.text.trim(),
      'notes': _notesController.text.trim(),
      'items': items,
    };
  }

  Future<void> _handleSubmit() async {
    final requiredPermission = widget.mode == SalesOrderFormMode.create
        ? 'workorder.add_salesorder'
        : 'workorder.change_salesorder';
    if (!PermissionUtil.hasPermission(context, requiredPermission)) {
      ToastUtil.showError('当前账号无权执行该操作');
      return;
    }
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    if (_customerId == null) {
      ToastUtil.showError('请选择客户');
      return;
    }
    if (_deliveryDate == null) {
      ToastUtil.showError('请选择交货日期');
      return;
    }
    if (_itemDrafts.every((draft) => draft.productId == null)) {
      ToastUtil.showError('请至少填写一条订单明细');
      return;
    }

    setState(() => _submitting = true);
    final payload = _buildPayload();
    try {
      final viewModel = context.read<SalesOrderViewModel>();
      if (widget.mode == SalesOrderFormMode.create) {
        await viewModel.createSalesOrder(payload);
      } else if (widget.orderId != null) {
        await viewModel.updateSalesOrder(widget.orderId!, payload);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (err) {
      ToastUtil.showError('保存失败: $err');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _buildSection(String title, Widget child) {
    return DetailSectionCard(title: title, child: child);
  }

  Widget _buildBasicSection(double fieldWidth) {
    return _buildSection(
      '基本信息',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchableDropdownFormField<int>(
            initialValue: _customerId,
            decoration: const InputDecoration(labelText: '客户'),
            items: _customers
                .map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(item.name),
                  ),
                )
                .toList(),
            onChanged: _handleCustomerChanged,
            validator: (value) => value == null ? '请选择客户' : null,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: SearchableDropdownFormField<String>(
                  initialValue: _status,
                  decoration: const InputDecoration(labelText: '状态'),
                  items: const [
                    DropdownMenuItem(value: 'draft', child: Text('草稿')),
                    DropdownMenuItem(value: 'submitted', child: Text('已提交')),
                    DropdownMenuItem(value: 'approved', child: Text('已审核')),
                    DropdownMenuItem(value: 'rejected', child: Text('已拒绝')),
                    DropdownMenuItem(
                        value: 'in_production', child: Text('生产中')),
                    DropdownMenuItem(value: 'completed', child: Text('已完成')),
                    DropdownMenuItem(value: 'cancelled', child: Text('已取消')),
                  ],
                  onChanged: (value) =>
                      setState(() => _status = value ?? 'draft'),
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: SearchableDropdownFormField<String>(
                  initialValue: _paymentStatus,
                  decoration: const InputDecoration(labelText: '付款状态'),
                  items: const [
                    DropdownMenuItem(value: 'unpaid', child: Text('未付款')),
                    DropdownMenuItem(value: 'partial', child: Text('部分付款')),
                    DropdownMenuItem(value: 'paid', child: Text('已付款')),
                  ],
                  onChanged: (value) =>
                      setState(() => _paymentStatus = value ?? 'unpaid'),
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: '下单日期'),
                  controller: _orderDateController,
                  onTap: () => _pickDate(isOrderDate: true),
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: '交货日期'),
                  controller: _deliveryDateController,
                  onTap: () => _pickDate(isOrderDate: false),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? '请选择交货日期' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _taxRateController,
                  decoration: const InputDecoration(labelText: '税率 (%)'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _discountAmountController,
                  decoration: const InputDecoration(labelText: '折扣金额'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _depositAmountController,
                  decoration: const InputDecoration(labelText: '定金'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _paidAmountController,
                  decoration: const InputDecoration(labelText: '已付金额'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return _buildSection(
      '订单明细',
      Column(
        children: [
          for (int index = 0; index < _itemDrafts.length; index++)
            _ItemRow(
              draft: _itemDrafts[index],
              products: _products,
              onRemove: _itemDrafts.length > 1
                  ? () => setState(() => _itemDrafts.removeAt(index))
                  : null,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() => _itemDrafts.add(_ItemDraft())),
              icon: const Icon(Icons.add),
              label: const Text('新增明细'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      '联系与备注',
      Column(
        children: [
          TextFormField(
            controller: _contactPersonController,
            decoration: const InputDecoration(labelText: '联系人'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contactPhoneController,
            decoration: const InputDecoration(labelText: '联系电话'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _shippingAddressController,
            decoration: const InputDecoration(labelText: '送货地址'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: '备注'),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = PermissionUtil.hasPermission(
      context,
      widget.mode == SalesOrderFormMode.create
          ? 'workorder.add_salesorder'
          : 'workorder.change_salesorder',
    );
    final isDesktop = BreakpointsUtil.isDesktop(context);
    final isTablet = BreakpointsUtil.isTablet(context);
    final fieldWidth = isDesktop ? 260.0 : (isTablet ? 220.0 : double.infinity);
    return ListPageScaffold(
      spacing: _spacing,
      header: PageHeaderBar(
        breadcrumb: null,
        useSurface: false,
        showDivider: false,
        padding: EdgeInsets.zero,
        actions: Wrap(
          spacing: _spacing,
          runSpacing: 8,
          children: [
            PageActionButton.outlined(
              onPressed: _submitting ? null : () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: '返回',
            ),
            PageActionButton.filled(
              onPressed: _submitting || !canSubmit ? null : _handleSubmit,
              icon: const Icon(Icons.save, size: 16),
              label: _submitting ? '保存中' : '保存',
            ),
          ],
        ),
      ),
      body: _loadingOptions || _loadingDetail
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildBasicSection(fieldWidth)),
                        const SizedBox(width: _sectionSpacing),
                        Expanded(child: _buildContactSection()),
                      ],
                    )
                  else ...[
                    _buildBasicSection(fieldWidth),
                    const SizedBox(height: _sectionSpacing),
                  ],
                  _buildItemsSection(),
                  if (!isDesktop) ...[
                    const SizedBox(height: _sectionSpacing),
                    _buildContactSection(),
                  ],
                ],
              ),
            ),
    );
  }
}

class _ItemDraft {
  _ItemDraft()
      : quantityController = TextEditingController(text: '1'),
        unitController = TextEditingController(text: '件'),
        unitPriceController = TextEditingController(text: '0'),
        taxRateController = TextEditingController(text: '0'),
        discountAmountController = TextEditingController(text: '0'),
        notesController = TextEditingController();

  _ItemDraft.fromDetail(SalesOrderItem item, double? orderTaxRate)
      : productId = item.productId,
        quantityController =
            TextEditingController(text: item.quantity?.toString() ?? '1'),
        unitController = TextEditingController(text: item.unit ?? '件'),
        unitPriceController = TextEditingController(
            text: item.unitPrice?.toStringAsFixed(2) ?? '0'),
        taxRateController = TextEditingController(
            text: (item.taxRate ?? orderTaxRate ?? 0).toStringAsFixed(2)),
        discountAmountController = TextEditingController(
            text: item.discountAmount?.toStringAsFixed(2) ?? '0'),
        notesController = TextEditingController(text: item.notes ?? '');

  int? productId;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController unitPriceController;
  final TextEditingController taxRateController;
  final TextEditingController discountAmountController;
  final TextEditingController notesController;

  int get quantityValue => int.tryParse(quantityController.text.trim()) ?? 1;
  String get unitValue =>
      unitController.text.trim().isEmpty ? '件' : unitController.text.trim();
  double get unitPriceValue =>
      double.tryParse(unitPriceController.text.trim()) ?? 0;
  double get taxRateValue =>
      double.tryParse(taxRateController.text.trim()) ?? 0;
  double get discountAmountValue =>
      double.tryParse(discountAmountController.text.trim()) ?? 0;
  String get notesValue => notesController.text.trim();

  void dispose() {
    quantityController.dispose();
    unitController.dispose();
    unitPriceController.dispose();
    taxRateController.dispose();
    discountAmountController.dispose();
    notesController.dispose();
  }
}

class _ItemRow extends StatefulWidget {
  const _ItemRow({
    required this.draft,
    required this.products,
    this.onRemove,
  });

  final _ItemDraft draft;
  final List<ProductOption> products;
  final VoidCallback? onRemove;

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: SearchableDropdownFormField<int>(
              initialValue: widget.draft.productId,
              decoration: const InputDecoration(labelText: '产品'),
              isExpanded: true,
              items: widget.products
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.displayLabel,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => widget.draft.productId = value),
              validator: (value) => value == null ? '请选择产品' : null,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: widget.draft.quantityController,
              decoration: const InputDecoration(labelText: '数量'),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 120,
            child: TextFormField(
              controller: widget.draft.unitController,
              decoration: const InputDecoration(labelText: '单位'),
            ),
          ),
          SizedBox(
            width: 140,
            child: TextFormField(
              controller: widget.draft.unitPriceController,
              decoration: const InputDecoration(labelText: '单价'),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 140,
            child: TextFormField(
              controller: widget.draft.taxRateController,
              decoration: const InputDecoration(labelText: '税率'),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 140,
            child: TextFormField(
              controller: widget.draft.discountAmountController,
              decoration: const InputDecoration(labelText: '折扣'),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 220,
            child: TextFormField(
              controller: widget.draft.notesController,
              decoration: const InputDecoration(labelText: '备注'),
            ),
          ),
          if (widget.onRemove != null)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.remove_circle_outline),
              tooltip: '移除',
            ),
        ],
      ),
    );
  }
}
