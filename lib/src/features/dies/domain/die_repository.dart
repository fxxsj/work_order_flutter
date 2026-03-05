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
}
