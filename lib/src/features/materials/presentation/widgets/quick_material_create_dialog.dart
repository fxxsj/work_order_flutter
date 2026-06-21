import 'package:flutter/material.dart';
import 'package:work_order_app/src/features/materials/application/material_view_model.dart';
import 'package:work_order_app/src/features/materials/domain/material.dart';
import 'package:work_order_app/src/features/materials/domain/material_repository.dart';
import 'package:work_order_app/src/features/materials/presentation/material_edit_page.dart';

Future<MaterialItem?> showQuickMaterialCreateDialog({
  required BuildContext context,
  required MaterialRepository materialRepository,
}) async {
  final viewModel = MaterialViewModel(materialRepository);
  await viewModel.initialize();
  final beforeIds = viewModel.materials.map((item) => item.id).toSet();

  final saved = await showMaterialEditDrawer(context, viewModel: viewModel);
  if (!saved) {
    return null;
  }

  for (final material in viewModel.materials) {
    if (!beforeIds.contains(material.id)) {
      return material;
    }
  }
  return null;
}
