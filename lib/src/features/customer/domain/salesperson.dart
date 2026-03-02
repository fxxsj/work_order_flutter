import 'package:work_order_app/src/core/utils/parse_utils.dart';

/// 业务员领域模型。
class Salesperson {
  /// 创建一个业务员对象。
  const Salesperson({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  /// 复制并更新业务员信息。
  Salesperson copyWith({
    int? id,
    String? name,
  }) {
    return Salesperson(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  /// 序列化为 Map。
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// 从 Map 反序列化。
  factory Salesperson.fromJson(Map<String, dynamic> json) {
    return Salesperson(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }
}
