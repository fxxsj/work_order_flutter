import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/customer/domain/salesperson.dart';

/// 业务员数据传输对象。
class SalespersonDto {
  SalespersonDto({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  /// 从 API JSON 创建 DTO。
  factory SalespersonDto.fromJson(Map<String, dynamic> json) {
    final id = toInt(json['id']) ?? 0;
    final username = json['username']?.toString() ?? '';
    final firstName = json['first_name']?.toString() ?? '';
    final lastName = json['last_name']?.toString() ?? '';
    final name = _firstNonEmpty([json['name']?.toString() ?? '', username, '$lastName$firstName']);
    return SalespersonDto(id: id, name: name.isEmpty ? '用户$id' : name);
  }

  /// 转换为领域实体。
  Salesperson toEntity() {
    return Salesperson(id: id, name: name);
  }
}

String _firstNonEmpty(List<String> values) {
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return '';
}
