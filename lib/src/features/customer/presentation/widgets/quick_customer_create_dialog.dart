import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/customer/application/customer_view_model.dart';
import 'package:work_order_app/src/features/customer/data/customer_api_service.dart';
import 'package:work_order_app/src/features/customer/data/customer_repository_impl.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';
import 'package:work_order_app/src/features/customer/presentation/customer_edit_page.dart';

Future<Customer?> showQuickCustomerCreateDialog({
  required BuildContext context,
  required CustomerApiService customerApi,
}) async {
  final viewModel = CustomerViewModel(CustomerRepositoryImpl(customerApi));
  await viewModel.initialize();
  final beforeIds = viewModel.customers.map((item) => item.id).toSet();

  final saved = await showCustomerEditDrawer(
    context,
    viewModel: viewModel,
  );
  if (!saved) {
    return null;
  }

  for (final customer in viewModel.customers) {
    if (!beforeIds.contains(customer.id)) {
      return customer;
    }
  }
  return null;
}
