import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/suppliers/application/supplier_view_model.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_api_service.dart';
import 'package:work_order_app/src/features/suppliers/data/supplier_repository_impl.dart';
import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/features/suppliers/presentation/supplier_edit_page.dart';

Future<Supplier?> showQuickSupplierCreateDialog({
  required BuildContext context,
  required SupplierApiService supplierApi,
}) async {
  final viewModel = SupplierViewModel(SupplierRepositoryImpl(supplierApi));
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
