import 'package:work_order_app/src/core/utils/parse_utils.dart';

/// 部门领域模型。
class Department {
  const Department({
    required this.id,
    required this.code,
    required this.name,
    this.parentId,
    this.parentName,
    this.childrenCount,
    this.processNames = const [],
    this.sortOrder,
    this.isActive = true,
    this.createdAt,
    this.level,
    this.processIds = const [],
  });

  final int id;
  final String code;
  final String name;
  final int? parentId;
  final String? parentName;
  final int? childrenCount;
  final List<String> processNames;
  final int? sortOrder;
  final bool isActive;
  final DateTime? createdAt;
  final int? level;
  final List<int> processIds;

  Department copyWith({
    int? id,
    String? code,
    String? name,
    int? parentId,
    String? parentName,
    int? childrenCount,
    List<String>? processNames,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
    int? level,
    List<int>? processIds,
  }) {
    return Department(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      childrenCount: childrenCount ?? this.childrenCount,
      processNames: processNames ?? this.processNames,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      level: level ?? this.level,
      processIds: processIds ?? this.processIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'parentId': parentId,
      'parentName': parentName,
      'childrenCount': childrenCount,
      'processNames': processNames,
      'sortOrder': sortOrder,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'level': level,
      'processIds': processIds,
    };
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      parentId: toInt(json['parentId']),
      parentName: toStringOrNull(json['parentName']),
      childrenCount: toInt(json['childrenCount']),
      processNames: (json['processNames'] is List)
          ? List<String>.from(json['processNames'].whereType<String>())
          : const [],
      sortOrder: toInt(json['sortOrder']),
      isActive: json['isActive'] == null ? true : json['isActive'] == true,
      createdAt: toDateTime(json['createdAt']),
      level: toInt(json['level']),
      processIds: (json['processIds'] is List)
          ? json['processIds']
              .where((value) => value != null)
              .map((value) => toInt(value) ?? 0)
              .where((value) => value > 0)
              .toList()
          : const [],
    );
  }
}

/// 工序选项。
class ProcessOption {
  const ProcessOption({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  final int id;
  final String name;
  final bool isActive;
}
