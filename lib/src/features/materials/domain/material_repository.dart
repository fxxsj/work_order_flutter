import 'package:work_order_app/src/features/materials/data/material_dto.dart';

abstract class MaterialRepository {
  Future<MaterialPageDto> getMaterials({
    int page = 1,
    int pageSize = 20,
    String? search,
  });
}
