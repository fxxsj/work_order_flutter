import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_detail_page.dart';
import 'package:work_order_app/src/core/utils/extensions/datetime_extensions.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({
    super.key,
    required this.customer,
  });

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return CrudDetailPage<Customer>(
      config: CrudDetailConfig<Customer>(
        title: customer.name,
        subtitle: '客户详情',
        item: customer,
        sectionsBuilder: (context, isMobile, item) => [
          CrudDetailSection(
            title: '基本信息',
            column: 0,
            items: [
              CrudDetailItem(label: '客户名称', value: item.name),
              CrudDetailItem(label: '业务员', value: item.salespersonName),
            ],
          ),
          CrudDetailSection(
            title: '联系信息',
            column: 0,
            items: [
              CrudDetailItem(label: '联系人', value: item.contactPerson),
              CrudDetailItem(label: '联系电话', value: item.phone),
              CrudDetailItem(label: '邮箱', value: item.email),
              CrudDetailItem(label: '地址', value: item.address),
            ],
          ),
          CrudDetailSection(
            title: '补充信息',
            column: isMobile ? 0 : 1,
            items: [
              CrudDetailItem(label: '备注', value: item.notes),
            ],
          ),
          CrudDetailSection(
            title: '系统信息',
            column: isMobile ? 0 : 1,
            items: [
              CrudDetailItem(label: '创建时间', value: item.createdAt.toYMDHM),
              CrudDetailItem(label: '更新时间', value: item.updatedAt.toYMDHM),
            ],
          ),
        ],
      ),
    );
  }
}
