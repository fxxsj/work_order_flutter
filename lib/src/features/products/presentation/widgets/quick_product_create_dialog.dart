import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/products/application/product_view_model.dart';
import 'package:work_order_app/src/features/products/data/product_api_service.dart';
import 'package:work_order_app/src/features/products/data/product_repository_impl.dart';
import 'package:work_order_app/src/features/products/domain/product.dart';
import 'package:work_order_app/src/features/products/presentation/product_edit_page.dart';

Future<Product?> showQuickProductCreateDialog({
  required BuildContext context,
  required ProductApiService productApi,
}) async {
  final viewModel = ProductViewModel(ProductRepositoryImpl(productApi));
  await viewModel.initialize();
  final beforeIds = viewModel.products.map((item) => item.id).toSet();

  final saved = await showProductEditDrawer(
    context,
    viewModel: viewModel,
  );
  if (!saved) {
    return null;
  }

  for (final product in viewModel.products) {
    if (!beforeIds.contains(product.id)) {
      return product;
    }
  }
  return null;
}
