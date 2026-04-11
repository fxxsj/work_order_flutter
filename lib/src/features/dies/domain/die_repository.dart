import 'package:dio/dio.dart';
import 'package:work_order_app/src/core/core.dart';
import 'package:work_order_app/src/features/dies/domain/die.dart';

abstract class DieRepository {
  Future<PageData<Die>> getDies({
    required int page,
    required int pageSize,
    String? search,
  });

  Future<void> createDie(Die die);

  Future<void> updateDie(Die die);

  Future<void> deleteDie(int id);

  Future<void> confirmDie(int id);

  Future<DieImage> uploadDieImage(int dieId, MultipartFile imageFile, {int sortOrder = 0, String? description});

  Future<void> deleteDieImage(int dieId, int imageId);
}
