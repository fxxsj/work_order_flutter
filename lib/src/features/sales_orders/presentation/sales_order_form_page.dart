import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:work_order_app/src/core/network/api_client.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_date_picker.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/detail_section_card.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/list_page_scaffold.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/page_header_bar.dart';
import 'package:work_order_app/src/core/presentation/providers/feature_entry.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/responsive_layout.dart';
import 'package:work_order_app/src/core/utils/permission_util.dart';
import 'package:work_order_app/src/core/utils/toast_util.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/widgets/quick_customer_create_dialog.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/widgets/quick_product_create_dialog.dart';
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
    return FeatureEntry<
      SalesOrderApiService,
      SalesOrderRepository,
      SalesOrderViewModel
    >(
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
  final TextEditingController _contractNumberController =
      TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController(
    text: '0',
  );
  final TextEditingController _discountAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _depositAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _paidAmountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _paymentDateController = TextEditingController();

  DateTime? _orderDate;
  DateTime? _deliveryDate;
  DateTime? _paymentDate;
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
  SalesOrderDetail? _detail;

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
    _contractNumberController.dispose();
    _shippingAddressController.dispose();
    _notesController.dispose();
    _taxRateController.dispose();
    _discountAmountController.dispose();
    _depositAmountController.dispose();
    _paidAmountController.dispose();
    _paymentDateController.dispose();
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
      final customerFuture = customerApi.fetchCustomers(page: 1, pageSize: 50);
      final productFuture = productApi.fetchProducts(
        pageSize: 50,
        isActive: true,
      );
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
    _detail = detail;
    _customerId = detail.customerId;
    _status = detail.status ?? _status;
    _paymentStatus = detail.paymentStatus ?? _paymentStatus;
    _orderDate = detail.orderDate;
    _deliveryDate = detail.deliveryDate;
    _orderDateController.text = _formatDate(_orderDate);
    _deliveryDateController.text = _formatDate(_deliveryDate);
    _contactPersonController.text = detail.contactPerson ?? '';
    _contactPhoneController.text = detail.contactPhone ?? '';
    _contractNumberController.text = detail.contractNumber ?? '';
    _shippingAddressController.text = detail.shippingAddress ?? '';
    _notesController.text = detail.notes ?? '';
    if (detail.taxRate != null) {
      _taxRateController.text = detail.taxRate!.toStringAsFixed(2);
    }
    if (detail.discountAmount != null) {
      _discountAmountController.text = detail.discountAmount!.toStringAsFixed(
        2,
      );
    }
    if (detail.depositAmount != null) {
      _depositAmountController.text = detail.depositAmount!.toStringAsFixed(2);
    }
    if (detail.paidAmount != null) {
      _paidAmountController.text = detail.paidAmount!.toStringAsFixed(2);
    }
    if (detail.paymentDate != null) {
      _paymentDate = detail.paymentDate;
      _paymentDateController.text = _formatDate(_paymentDate);
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
      _contactPersonController.text,
      _autoFilledContactPerson,
    )) {
      _contactPersonController.text = contactPerson;
    }
    if (_shouldOverwriteAutoField(
      _contactPhoneController.text,
      _autoFilledContactPhone,
    )) {
      _contactPhoneController.text = contactPhone;
    }
    if (_shouldOverwriteAutoField(
      _shippingAddressController.text,
      _autoFilledShippingAddress,
    )) {
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
    final customer = _customers.cast<Customer?>().firstWhere(
      (item) => item?.id == customerId,
      orElse: () => null,
    );
    if (customer == null) return;
    _applyCustomerContactInfo(customer);
  }

  Future<void> _handleCreateCustomer() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_customer')) {
      ToastUtil.showError('当前账号无权新增客户');
      return;
    }

    final created = await showQuickCustomerCreateDialog(
      context: context,
      customerApi: CustomerApiService(context.read<ApiClient>()),
    );
    if (created == null || !mounted) {
      return;
    }

    setState(() {
      _customers = List<Customer>.from(_customers)
        ..removeWhere((item) => item.id == created.id)
        ..add(created)
        ..sort((left, right) => left.name.compareTo(right.name));
      _customerId = created.id;
      _applyCustomerContactInfo(created);
    });
    ToastUtil.showSuccess('客户已新增');
  }

  Future<ProductOption?> _handleCreateProduct() async {
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has('workorder.add_product')) {
      ToastUtil.showError('当前账号无权新增产品');
      return null;
    }

    final created = await showQuickProductCreateDialog(
      context: context,
      productApi: ProductApiService(context.read<ApiClient>()),
    );
    if (created == null || !mounted) {
      return null;
    }

    final option = ProductOption(
      id: created.id,
      name: created.name,
      code: created.code,
      specification: created.specification,
      unit: created.unit,
      unitPrice: created.unitPrice,
    );
    setState(() {
      _products = List<ProductOption>.from(_products)
        ..removeWhere((item) => item.id == option.id)
        ..add(option)
        ..sort(
          (left, right) => left.displayLabel.compareTo(right.displayLabel),
        );
    });
    ToastUtil.showSuccess('产品已新增');
    return option;
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _formatAmount(double? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(2);
  }

  Future<void> _pickDate({
    required bool isOrderDate,
    bool isPaymentDate = false,
  }) async {
    DateTime initial;
    if (isOrderDate) {
      initial = _orderDate ?? DateTime.now();
    } else if (isPaymentDate) {
      initial = _paymentDate ?? DateTime.now();
    } else {
      initial = _deliveryDate ?? DateTime.now();
    }
    final picked = await showAppDatePicker(
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
      } else if (isPaymentDate) {
        _paymentDate = picked;
        _paymentDateController.text = _formatDate(picked);
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
      'order_date': orderDate.isEmpty ? null : orderDate,
      'delivery_date': deliveryDate.isEmpty ? null : deliveryDate,
      'contract_number': _contractNumberController.text.trim(),
      'tax_rate': double.tryParse(_taxRateController.text.trim()) ?? 0,
      'discount_amount':
          double.tryParse(_discountAmountController.text.trim()) ?? 0,
      'deposit_amount':
          double.tryParse(_depositAmountController.text.trim()) ?? 0,
      'paid_amount': double.tryParse(_paidAmountController.text.trim()) ?? 0,
      if (_paymentDate != null) 'payment_date': _formatDate(_paymentDate),
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
    final permissions = PermissionUtil.snapshot(context);
    if (!permissions.has(requiredPermission)) {
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
    if (_orderDate != null &&
        _deliveryDate != null &&
        _deliveryDate!.isBefore(_orderDate!)) {
      ToastUtil.showError('交货日期不能早于订单日期');
      return;
    }
    if (_itemDrafts.every((draft) => draft.productId == null)) {
      ToastUtil.showError('请至少填写一条订单明细');
      return;
    }
    final validDrafts = _itemDrafts
        .where((draft) => draft.productId != null)
        .toList();
    if (validDrafts.any((draft) => draft.quantityValue <= 0)) {
      ToastUtil.showError('产品数量必须大于 0');
      return;
    }
    if (validDrafts.any((draft) => draft.unitPriceValue < 0)) {
      ToastUtil.showError('产品单价不能小于 0');
      return;
    }
    if (validDrafts.any(
      (draft) => draft.taxRateValue < 0 || draft.taxRateValue > 100,
    )) {
      ToastUtil.showError('明细税率必须在 0-100 之间');
      return;
    }
    if (validDrafts.any((draft) => draft.discountAmountValue < 0)) {
      ToastUtil.showError('明细折扣不能小于 0');
      return;
    }
    final taxRate = double.tryParse(_taxRateController.text.trim()) ?? 0;
    if (taxRate < 0 || taxRate > 100) {
      ToastUtil.showError('税率必须在 0-100 之间');
      return;
    }
    if (_discountAmountValue < 0 ||
        _depositAmountValue < 0 ||
        _paidAmountValue < 0) {
      ToastUtil.showError('金额不能小于 0');
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

  double get _orderTaxRateValue =>
      double.tryParse(_taxRateController.text.trim()) ?? 0;

  double _lineSubtotal(_ItemDraft draft) {
    final base = draft.quantityValue * draft.unitPriceValue;
    final discounted = base - draft.discountAmountValue;
    return discounted < 0 ? 0 : discounted;
  }

  double _lineTaxAmount(_ItemDraft draft) {
    return _lineSubtotal(draft) * (draft.taxRateValue / 100);
  }

  double get _itemsSubtotalValue {
    return _itemDrafts
        .where((draft) => draft.productId != null)
        .fold(0, (sum, draft) => sum + _lineSubtotal(draft));
  }

  double get _itemsTaxAmountValue {
    return _itemDrafts
        .where((draft) => draft.productId != null)
        .fold(0, (sum, draft) => sum + _lineTaxAmount(draft));
  }

  double get _itemsTotalValue => _itemsSubtotalValue + _itemsTaxAmountValue;

  int get _itemsCountValue =>
      _itemDrafts.where((draft) => draft.productId != null).length;

  int get _totalQuantityValue => _itemDrafts
      .where((draft) => draft.productId != null)
      .fold(0, (sum, draft) => sum + draft.quantityValue);

  double get _discountAmountValue =>
      double.tryParse(_discountAmountController.text.trim()) ?? 0;

  double get _depositAmountValue =>
      double.tryParse(_depositAmountController.text.trim()) ?? 0;

  double get _paidAmountValue =>
      double.tryParse(_paidAmountController.text.trim()) ?? 0;

  double get _orderLevelTaxAmount {
    final taxable = _itemsSubtotalValue - _discountAmountValue;
    return taxable <= 0 ? 0 : taxable * (_orderTaxRateValue / 100);
  }

  double get _grandTotalValue {
    final base = _itemsSubtotalValue - _discountAmountValue;
    final taxed = base <= 0 ? 0.0 : base + _orderLevelTaxAmount;
    return taxed;
  }

  double get _unpaidAmountValue {
    final value = _grandTotalValue - _depositAmountValue - _paidAmountValue;
    return value < 0 ? 0 : value;
  }

  Widget _buildContextSection(double fieldWidth) {
    final customerOptions = _customers
        .map((item) => AppDropdownOption<int>(value: item.id, label: item.name))
        .toList();
    customerOptions.add(
      AppDropdownOption<int>(
        value: -1,
        label: '新增客户',
        icon: Icons.add,
        onSelected: () {
          _handleCreateCustomer();
        },
      ),
    );

    return _buildSection(
      '客户信息',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: AppSelect<int>(
                  value: _customerId,
                  decoration: const InputDecoration(labelText: '客户'),
                  options: customerOptions,
                  selectHintText: _customers.isEmpty ? '新增客户' : '请选择',
                  minOptionsForSearch: 1,
                  onChanged: _handleCustomerChanged,
                  validator: (value) => value == null ? '请选择客户' : null,
                ),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '下单日期',
                  controller: _orderDateController,
                  readOnly: true,
                  onTap: () => _pickDate(isOrderDate: true),
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '交货日期',
                  controller: _deliveryDateController,
                  readOnly: true,
                  onTap: () => _pickDate(isOrderDate: false),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? '请选择交货日期' : null,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '合同号',
                  controller: _contractNumberController,
                ).build(context),
              ),
            ],
          ),
          SpacingTokens.vMd,
          if (widget.mode == SalesOrderFormMode.edit)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: CrudFieldConfig.text(
                    label: '订单号',
                    initialValue:
                        _detail?.orderNumber.trim().isNotEmpty ?? false
                        ? _detail!.orderNumber
                        : '保存后生成',
                    enabled: false,
                  ).build(context),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: CrudFieldConfig.text(
                    label: '状态',
                    initialValue: _statusLabel(_status),
                    enabled: false,
                  ).build(context),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: CrudFieldConfig.text(
                    label: '付款状态',
                    initialValue: _paymentStatusLabel(_paymentStatus),
                    enabled: false,
                  ).build(context),
                ),
              ],
            ),
          SpacingTokens.vMd,
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '联系人',
                  hintText: widget.mode == SalesOrderFormMode.create
                      ? '（自动从客户档案带出）'
                      : null,
                  controller: _contactPersonController,
                  enabled: widget.mode == SalesOrderFormMode.edit,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '联系电话',
                  hintText: widget.mode == SalesOrderFormMode.create
                      ? '（自动从客户档案带出）'
                      : null,
                  controller: _contactPhoneController,
                  enabled: widget.mode == SalesOrderFormMode.edit,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '送货地址',
                  hintText: widget.mode == SalesOrderFormMode.create
                      ? '（自动从客户档案带出）'
                      : null,
                  controller: _shippingAddressController,
                  enabled: widget.mode == SalesOrderFormMode.edit,
                ).build(context),
              ),
            ],
          ),
          SpacingTokens.vMd,
          CrudFieldConfig.textarea(
            label: '备注',
            controller: _notesController,
            maxLines: 3,
          ).build(context),
          if (_customers.isEmpty) ...[
            SpacingTokens.vSm,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _handleCreateCustomer,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新增客户'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection(bool isDesktop) {
    return _buildSection(
      '订单明细',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PageActionButton.outlined(
                onPressed: () => setState(
                  () => _itemDrafts.add(
                    _ItemDraft(initialTaxRate: _orderTaxRateValue),
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: '新增明细',
              ),
              _InlineBadge(label: '明细行数', value: _itemsCountValue.toString()),
              _InlineBadge(label: '总数量', value: _totalQuantityValue.toString()),
              _InlineBadge(
                label: '小计',
                value: _formatAmount(_itemsSubtotalValue),
              ),
              _InlineBadge(
                label: '税额合计',
                value: _formatAmount(_itemsTaxAmountValue),
              ),
              _InlineBadge(label: '合计', value: _formatAmount(_itemsTotalValue)),
            ],
          ),
          SpacingTokens.vMd,
          for (int index = 0; index < _itemDrafts.length; index++)
            _ItemRow(
              key: ValueKey(
                'sales-order-item-$index-${_itemDrafts[index].productId ?? 0}',
              ),
              draft: _itemDrafts[index],
              products: _products,
              isDesktop: isDesktop,
              onCreateProduct: _handleCreateProduct,
              onChanged: () => setState(() {}),
              onRemove: _itemDrafts.length > 1
                  ? () => setState(() {
                      final draft = _itemDrafts.removeAt(index);
                      draft.dispose();
                    })
                  : null,
            ),
        ],
      ),
    );
  }

  String _statusLabel(String value) {
    switch (value) {
      case 'draft':
        return '草稿';
      case 'submitted':
        return '已提交';
      case 'approved':
        return '已审核';
      case 'rejected':
        return '已拒绝';
      case 'in_production':
        return '生产中';
      case 'completed':
        return '已完成';
      case 'cancelled':
        return '已取消';
      default:
        return value;
    }
  }

  String _paymentStatusLabel(String value) {
    switch (value) {
      case 'unpaid':
        return '未付款';
      case 'partial':
        return '部分付款';
      case 'paid':
        return '已付款';
      default:
        return value;
    }
  }

  Widget _buildSettlementSection(double fieldWidth) {
    return _buildSection(
      '金额与结算',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.number(
                  label: '整单税率 (%)',
                  controller: _taxRateController,
                  decimal: true,
                  onChanged: (_) => setState(() {}),
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.number(
                  label: '整单折扣金额',
                  controller: _discountAmountController,
                  decimal: true,
                  onChanged: (_) => setState(() {}),
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '小计',
                  initialValue: _formatAmount(_itemsSubtotalValue),
                  enabled: false,
                  readOnly: true,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '整单税额',
                  initialValue: _formatAmount(_orderLevelTaxAmount),
                  enabled: false,
                  readOnly: true,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '总金额',
                  initialValue: _formatAmount(_grandTotalValue),
                  enabled: false,
                  readOnly: true,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '未付金额',
                  initialValue: _formatAmount(_unpaidAmountValue),
                  enabled: false,
                  readOnly: true,
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.number(
                  label: '定金',
                  controller: _depositAmountController,
                  decimal: true,
                  onChanged: (_) => setState(() {}),
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.number(
                  label: '已付金额',
                  controller: _paidAmountController,
                  decimal: true,
                  onChanged: (_) => setState(() {}),
                ).build(context),
              ),
              SizedBox(
                width: fieldWidth,
                child: CrudFieldConfig.text(
                  label: '付款日期',
                  controller: _paymentDateController,
                  readOnly: true,
                  onTap: () =>
                      _pickDate(isOrderDate: false, isPaymentDate: true),
                ).build(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTraceabilitySection() {
    final detail = _detail;
    if (detail == null) return const SizedBox.shrink();
    return _buildSection(
      '订单跟进',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ReadOnlyMetric(
                label: '实际交货日期',
                value: _formatDate(detail.actualDeliveryDate).isEmpty
                    ? '-'
                    : _formatDate(detail.actualDeliveryDate),
              ),
              _ReadOnlyMetric(
                label: '收款次数',
                value: (detail.paymentCount ?? 0).toString(),
              ),
              _ReadOnlyMetric(
                label: '待收计划数',
                value: (detail.pendingPaymentPlanCount ?? 0).toString(),
              ),
              _ReadOnlyMetric(
                label: '待收计划金额',
                value: _formatAmount(detail.pendingPaymentPlanAmount),
              ),
            ],
          ),
          SpacingTokens.vMd,
          _TraceabilityGroup(
            label: '关联施工单',
            numbers: detail.workOrderSummaries.isNotEmpty
                ? detail.workOrderSummaries.map((item) => item.number).toList()
                : detail.workOrderNumbers,
          ),
          SpacingTokens.vSm,
          _TraceabilityGroup(
            label: '关联发货单',
            numbers: detail.deliveryOrderSummaries.isNotEmpty
                ? detail.deliveryOrderSummaries
                      .map((item) => item.number)
                      .toList()
                : detail.deliveryOrderNumbers,
          ),
          SpacingTokens.vSm,
          _TraceabilityGroup(
            label: '关联发票',
            numbers: detail.invoiceSummaries.isNotEmpty
                ? detail.invoiceSummaries.map((item) => item.number).toList()
                : detail.invoiceNumbers,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final permissions = PermissionUtil.snapshot(context);
    final canSubmit = permissions.has(
      widget.mode == SalesOrderFormMode.create
          ? 'workorder.add_salesorder'
          : 'workorder.change_salesorder',
    );
    final isDesktop = ResponsiveLayout.isDesktop(context);
    final isTablet = ResponsiveLayout.isTablet(context);
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
                  _buildContextSection(fieldWidth),
                  const SizedBox(height: _sectionSpacing),
                  _buildItemsSection(isDesktop),
                  const SizedBox(height: _sectionSpacing),
                  _buildSettlementSection(fieldWidth),
                  if (widget.mode == SalesOrderFormMode.edit) ...[
                    const SizedBox(height: _sectionSpacing),
                    _buildTraceabilitySection(),
                  ],
                ],
              ),
            ),
    );
  }
}

class _ItemDraft {
  _ItemDraft({double initialTaxRate = 0})
    : quantityController = TextEditingController(text: '1'),
      unitController = TextEditingController(text: '件'),
      unitPriceController = TextEditingController(text: '0'),
      taxRateController = TextEditingController(
        text: initialTaxRate.toStringAsFixed(2),
      ),
      discountAmountController = TextEditingController(text: '0'),
      notesController = TextEditingController();

  _ItemDraft.fromDetail(SalesOrderItem item, double? orderTaxRate)
    : productId = item.productId,
      quantityController = TextEditingController(
        text: item.quantity?.toString() ?? '1',
      ),
      unitController = TextEditingController(text: item.unit ?? '件'),
      unitPriceController = TextEditingController(
        text: item.unitPrice?.toStringAsFixed(2) ?? '0',
      ),
      taxRateController = TextEditingController(
        text: (item.taxRate ?? orderTaxRate ?? 0).toStringAsFixed(2),
      ),
      discountAmountController = TextEditingController(
        text: item.discountAmount?.toStringAsFixed(2) ?? '0',
      ),
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
    super.key,
    required this.draft,
    required this.products,
    required this.onCreateProduct,
    required this.onChanged,
    required this.isDesktop,
    this.onRemove,
  });

  final _ItemDraft draft;
  final List<ProductOption> products;
  final Future<ProductOption?> Function() onCreateProduct;
  final VoidCallback onChanged;
  final bool isDesktop;
  final VoidCallback? onRemove;

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  ProductOption? get _selectedProduct {
    final productId = widget.draft.productId;
    if (productId == null) {
      return null;
    }
    return widget.products.cast<ProductOption?>().firstWhere(
      (item) => item?.id == productId,
      orElse: () => null,
    );
  }

  void _applyProductDefaults(ProductOption product) {
    widget.draft.unitController.text =
        (product.unit?.trim().isNotEmpty ?? false) ? product.unit!.trim() : '件';
    widget.draft.unitPriceController.text = (product.unitPrice ?? 0)
        .toStringAsFixed(2);
    widget.onChanged();
  }

  void _handleProductChanged(int? value) {
    setState(() => widget.draft.productId = value);
    widget.onChanged();
    if (value == null) {
      return;
    }
    final product = widget.products.cast<ProductOption?>().firstWhere(
      (item) => item?.id == value,
      orElse: () => null,
    );
    if (product == null) {
      return;
    }
    _applyProductDefaults(product);
  }

  Future<void> _handleCreateProduct() async {
    final created = await widget.onCreateProduct();
    if (created == null || !mounted) {
      return;
    }
    setState(() => widget.draft.productId = created.id);
    _applyProductDefaults(created);
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = _selectedProduct;
    final lineSubtotal =
        widget.draft.quantityValue * widget.draft.unitPriceValue;
    final lineDiscounted = lineSubtotal - widget.draft.discountAmountValue;
    final safeSubtotal = lineDiscounted < 0 ? 0 : lineDiscounted;
    final lineTax = safeSubtotal * (widget.draft.taxRateValue / 100);
    final lineTotal = safeSubtotal + lineTax;
    final productOptions = widget.products
        .map(
          (item) =>
              AppDropdownOption<int>(value: item.id, label: item.displayLabel),
        )
        .toList();
    productOptions.add(
      AppDropdownOption<int>(
        value: -1,
        label: '新增产品',
        icon: Icons.add,
        onSelected: _handleCreateProduct,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DetailSurfaceCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 第一行：产品/规格/单位/单价/数量/税率/折扣 + 删除按钮撑满整行
            Row(
              children: [
                if (widget.products.isEmpty)
                  TextButton.icon(
                    onPressed: _handleCreateProduct,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('新增产品'),
                  ),
                if (widget.isDesktop)
                  Expanded(
                    child: AppSelect<int>(
                      value: widget.draft.productId,
                      decoration: const InputDecoration(labelText: '产品'),
                      options: productOptions,
                      selectHintText: widget.products.isEmpty ? '新增产品' : '请选择',
                      minOptionsForSearch: 1,
                      onChanged: _handleProductChanged,
                      validator: (value) => value == null ? '请选择产品' : null,
                    ),
                  ),
                if (widget.isDesktop) const SizedBox(width: 12),
                SizedBox(
                  width: 220,
                  child: CrudFieldConfig.text(
                    label: '规格',
                    initialValue: selectedProduct?.specification ?? '',
                    enabled: false,
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: CrudFieldConfig.text(
                    label: '单位',
                    controller: widget.draft.unitController,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: CrudFieldConfig.number(
                    label: '单价',
                    controller: widget.draft.unitPriceController,
                    decimal: true,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: CrudFieldConfig.number(
                    label: '数量',
                    controller: widget.draft.quantityController,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: CrudFieldConfig.number(
                    label: '税率',
                    controller: widget.draft.taxRateController,
                    decimal: true,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: CrudFieldConfig.number(
                    label: '折扣',
                    controller: widget.draft.discountAmountController,
                    decimal: true,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: '移除',
                  ),
              ],
            ),
            // 移动端产品下拉单独一行
            if (!widget.isDesktop)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AppSelect<int>(
                  value: widget.draft.productId,
                  decoration: const InputDecoration(labelText: '产品'),
                  options: productOptions,
                  selectHintText: widget.products.isEmpty ? '新增产品' : '请选择',
                  minOptionsForSearch: 1,
                  onChanged: _handleProductChanged,
                  validator: (value) => value == null ? '请选择产品' : null,
                ),
              ),
            // 第二行：折后金额/税额/合计/备注撑满整行
            SpacingTokens.vMd,
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: CrudFieldConfig.text(
                    label: '折后金额',
                    initialValue: safeSubtotal.toStringAsFixed(2),
                    enabled: false,
                    readOnly: true,
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: CrudFieldConfig.text(
                    label: '税额',
                    initialValue: lineTax.toStringAsFixed(2),
                    enabled: false,
                    readOnly: true,
                  ).build(context),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: CrudFieldConfig.text(
                    label: '合计',
                    initialValue: lineTotal.toStringAsFixed(2),
                    enabled: false,
                    readOnly: true,
                  ).build(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CrudFieldConfig.text(
                    label: '备注',
                    controller: widget.draft.notesController,
                    onChanged: (_) => widget.onChanged(),
                  ).build(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyMetric extends StatelessWidget {
  const _ReadOnlyMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140),
      child: DetailSurfaceCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            SpacingTokens.vXs,
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineBadge extends StatelessWidget {
  const _InlineBadge({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: OpacityTokens.heavy,
        ),
        borderRadius: BorderRadius.circular(LayoutTokens.radiusMd),
      ),
      child: Text(
        '$label：$value',
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TraceabilityGroup extends StatelessWidget {
  const _TraceabilityGroup({required this.label, required this.numbers});

  final String label;
  final List<String> numbers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        SpacingTokens.vXxs,
        if (numbers.isEmpty)
          Text('-', style: theme.textTheme.bodyMedium)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: numbers
                .map(
                  (number) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: OpacityTokens.heavy),
                      borderRadius: BorderRadius.circular(
                        LayoutTokens.radiusPill,
                      ),
                    ),
                    child: Text(number, style: theme.textTheme.bodySmall),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
