import 'package:flutter/material.dart';
import 'package:work_order_app/src/core/presentation/layout/widgets/crud_detail_page.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({
    super.key,
    required this.supplier,
  });

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return CrudDetailPage<Supplier>(
      config: CrudDetailConfig<Supplier>(
        title: supplier.name,
        subtitle: '供应商详情',
        item: supplier,
        sectionsBuilder: (context, isMobile, item) => [
          CrudDetailSection(
            title: '基本信息',
            column: 0,
            items: [
              CrudDetailItem(label: '供应商名称', value: item.name),
              CrudDetailItem(label: '供应商编码', value: item.code),
              CrudDetailItem(
                label: '状态',
                value: item.statusDisplay ?? item.status,
              ),
              CrudDetailItem(
                label: '供应物料数',
                value: item.materialCount?.toString(),
              ),
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
        ],
      ),
    );
  }
}
