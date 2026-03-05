import 'package:work_order_app/src/core/utils/parse_utils.dart';

/// 工序领域模型。
class Process {
  const Process({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.standardDuration,
    this.sortOrder,
    this.isActive = true,
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final double? standardDuration;
  final int? sortOrder;
  final bool isActive;

  Process copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    double? standardDuration,
    int? sortOrder,
    bool? isActive,
  }) {
    return Process(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      standardDuration: standardDuration ?? this.standardDuration,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'standardDuration': standardDuration,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
  }

  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: toStringOrNull(json['description']),
      standardDuration: json['standardDuration'] == null
          ? null
          : double.tryParse(json['standardDuration'].toString()),
      sortOrder: toInt(json['sortOrder']),
      isActive: json['isActive'] == null ? true : json['isActive'] == true,
    );
  }
}
