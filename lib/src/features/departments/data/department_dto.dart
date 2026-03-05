import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/departments/domain/department.dart';

class DepartmentDto {
  DepartmentDto({
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

  factory DepartmentDto.fromJson(Map<String, dynamic> json) {
    final parent = json['parent'];
    final parentId = parent is Map ? toInt(parent['id']) : toInt(parent);
    final parentName = json['parent_name']?.toString() ?? (parent is Map ? parent['name']?.toString() : null);

    final processNames = <String>[];
    final processIds = <int>[];

    final processNamesRaw = json['process_names'];
    if (processNamesRaw is List) {
      processNames.addAll(processNamesRaw.map((item) => item.toString()));
    }

    final processesRaw = json['processes'];
    if (processesRaw is List) {
      for (final item in processesRaw) {
        if (item is Map) {
          final id = toInt(item['id']);
          if (id != null) processIds.add(id);
          final name = item['name']?.toString();
          if (name != null && name.trim().isNotEmpty) {
            processNames.add(name.trim());
          }
        } else {
          final id = toInt(item);
          if (id != null) processIds.add(id);
        }
      }
    }

    return DepartmentDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      parentId: parentId,
      parentName: parentName,
      childrenCount: toInt(json['children_count']),
      processNames: processNames,
      sortOrder: toInt(json['sort_order']),
      isActive: json['is_active'] == null ? true : json['is_active'] == true,
      createdAt: toDateTime(json['created_at']),
      level: toInt(json['level']),
      processIds: processIds,
    );
  }

  factory DepartmentDto.fromEntity(Department entity) {
    return DepartmentDto(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      parentId: entity.parentId,
      parentName: entity.parentName,
      childrenCount: entity.childrenCount,
      processNames: entity.processNames,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      level: entity.level,
      processIds: entity.processIds,
    );
  }

  Department toEntity() {
    return Department(
      id: id,
      code: code,
      name: name,
      parentId: parentId,
      parentName: parentName,
      childrenCount: childrenCount,
      processNames: processNames,
      sortOrder: sortOrder,
      isActive: isActive,
      createdAt: createdAt,
      level: level,
      processIds: processIds,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code.trim(),
      'name': name.trim(),
      'parent': parentId,
      'sort_order': sortOrder ?? 0,
      'is_active': isActive,
      'processes': processIds,
    };
  }
}

class DepartmentPageDto {
  const DepartmentPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<DepartmentDto> items;
  final int total;
  final int page;
  final int pageSize;
}

class ProcessOptionDto {
  const ProcessOptionDto({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  final int id;
  final String name;
  final bool isActive;

  factory ProcessOptionDto.fromJson(Map<String, dynamic> json) {
    return ProcessOptionDto(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      isActive: json['is_active'] == null ? true : json['is_active'] == true,
    );
  }

  ProcessOption toEntity() => ProcessOption(id: id, name: name, isActive: isActive);
}
