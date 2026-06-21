import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier_repository.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_edit_page.dart';

Future<Supplier?> showQuickSupplierCreateDialog({
  required BuildContext context,
  required SupplierRepository supplierRepository,
}) async {
  final viewModel = SupplierViewModel(supplierRepository);
  await viewModel.initialize();
  final beforeIds = viewModel.suppliers.map((item) => item.id).toSet();

  final saved = await showSupplierEditDrawer(context, viewModel: viewModel);
  if (!saved) {
    return null;
  }

  for (final supplier in viewModel.suppliers) {
    if (!beforeIds.contains(supplier.id)) {
      return supplier;
    }
  }
  return null;
}
