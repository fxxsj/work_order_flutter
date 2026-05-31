import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/constants/breakpoints.dart';
import 'package:work_order_app/src/core/presentation/layout/layout_tokens.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/app_select.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_form_field.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/workorders/domain/work_order_sales_order_candidate.dart';
import 'package:work_order_app/src/features/workorders/presentation/work_order_form_page.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_card.dart';
import 'package:work_order_app/src/features/workorders/presentation/widgets/sections/work_order_form_dropdowns.dart';

/// Basic information section for work order form.
class WorkOrderBasicInfoSection extends StatelessWidget {
  const WorkOrderBasicInfoSection({
    super.key,
    required this.mode,
    required this.salesOrderId,
    required this.salesOrders,
    required this.customerId,
    required this.customers,
    required this.status,
    required this.priority,
    required this.orderDateController,
    required this.deliveryDateController,
    required this.productionQuantityController,
    required this.defectiveQuantityController,
    required this.actualDeliveryDateController,
    required this.notesController,
    required this.onSalesOrderChanged,
    required this.onCustomerChanged,
    this.onCreateCustomer,
    this.onSearchCustomer,
    required this.onStatusChanged,
    required this.onPriorityChanged,
    required this.onPickOrderDate,
    required this.onPickDeliveryDate,
    required this.onPickActualDeliveryDate,
  });

  final WorkOrderFormMode mode;
  final int? salesOrderId;
  final List<WorkOrderSalesOrderCandidate> salesOrders;
  final int? customerId;
  final List<Customer> customers;
  final String status;
  final String priority;
  final TextEditingController orderDateController;
  final TextEditingController deliveryDateController;
  final TextEditingController productionQuantityController;
  final TextEditingController defectiveQuantityController;
  final TextEditingController actualDeliveryDateController;
  final TextEditingController notesController;
  final ValueChanged<int?> onSalesOrderChanged;
  final ValueChanged<int?> onCustomerChanged;
  final VoidCallback? onCreateCustomer;
  /// 客户远程搜索回调
  final Future<List<AppDropdownOption<int>>> Function(String query)? onSearchCustomer;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPriorityChanged;
  final VoidCallback onPickOrderDate;
  final VoidCallback onPickDeliveryDate;
  final VoidCallback onPickActualDeliveryDate;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFormSectionCard(
      title: '基本信息',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final fieldSpacing = LayoutTokens.gapLg;
              final fieldWidth = maxWidth < Breakpoints.sm
                  ? maxWidth
                  : (maxWidth - fieldSpacing) / 2;
              return Wrap(
                spacing: fieldSpacing,
                runSpacing: LayoutTokens.gapMd,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: SalesOrderDropdown(
                      salesOrderId: salesOrderId,
                      salesOrders: salesOrders,
                      onChanged: onSalesOrderChanged,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CustomerDropdown(
                      customerId: customerId,
                      customers: customers,
                      onChanged: onCustomerChanged,
                      onCreateCustomer: onCreateCustomer,
                      onSearch: onSearchCustomer,
                    ),
                  ),
                  if (mode == WorkOrderFormMode.edit)
                    SizedBox(
                      width: fieldWidth,
                      child: AppSelect<String>(
                        value: status,
                        options: const [
                          AppDropdownOption(value: 'pending', label: '待开始'),
                          AppDropdownOption(value: 'in_progress', label: '进行中'),
                          AppDropdownOption(value: 'paused', label: '已暂停'),
                          AppDropdownOption(value: 'completed', label: '已完成'),
                          AppDropdownOption(value: 'cancelled', label: '已取消'),
                        ],
                        decoration: const InputDecoration(labelText: '状态'),
                        onChanged: (value) => onStatusChanged(value),
                      ),
                    ),
                  SizedBox(
                    width: fieldWidth,
                    child: AppSelect<String>(
                      value: priority,
                      options: const [
                        AppDropdownOption(value: 'low', label: '低'),
                        AppDropdownOption(value: 'normal', label: '普通'),
                        AppDropdownOption(value: 'high', label: '高'),
                        AppDropdownOption(value: 'urgent', label: '紧急'),
                      ],
                      decoration: const InputDecoration(labelText: '优先级'),
                      onChanged: (value) => onPriorityChanged(value),
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.text(
                      label: '下单日期',
                      controller: orderDateController,
                      readOnly: true,
                      onTap: onPickOrderDate,
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.text(
                      label: '交货日期',
                      controller: deliveryDateController,
                      readOnly: true,
                      onTap: onPickDeliveryDate,
                      validator: (value) =>
                          (value == null || value.isEmpty) ? '请选择交货日期' : null,
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.number(
                      label: '生产数量',
                      controller: productionQuantityController,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed <= 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ).build(context),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: CrudFieldConfig.number(
                      label: '预损数量',
                      controller: defectiveQuantityController,
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final parsed = int.tryParse(text);
                        if (parsed == null || parsed < 0) {
                          return '请输入有效数量';
                        }
                        return null;
                      },
                    ).build(context),
                  ),
                  if (mode == WorkOrderFormMode.edit)
                    SizedBox(
                      width: fieldWidth,
                      child: CrudFieldConfig.text(
                        label: '实际交货日期',
                        controller: actualDeliveryDateController,
                        readOnly: true,
                        onTap: onPickActualDeliveryDate,
                      ).build(context),
                    ),
                ],
              );
            },
          ),
          SizedBox(height: LayoutTokens.gapMd),
          CrudFieldConfig.textarea(
            label: '备注',
            controller: notesController,
            maxLines: 3,
          ).build(context),
        ],
      ),
    );
  }
}
