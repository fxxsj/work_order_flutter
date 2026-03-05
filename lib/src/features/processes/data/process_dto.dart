import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/processes/domain/process.dart';

class ProcessDto {
  ProcessDto({
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

  factory ProcessDto.fromJson(Map<String, dynamic> json) {
    return ProcessDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: toStringOrNull(json['description']),
      standardDuration: json['standard_duration'] == null
          ? null
          : double.tryParse(json['standard_duration'].toString()),
      sortOrder: toInt(json['sort_order']),
      isActive: json['is_active'] == null ? true : json['is_active'] == true,
    );
  }

  factory ProcessDto.fromEntity(Process entity) {
    return ProcessDto(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      standardDuration: entity.standardDuration,
      sortOrder: entity.sortOrder,
      isActive: entity.isActive,
    );
  }

  Process toEntity() {
    return Process(
      id: id,
      code: code,
      name: name,
      description: description,
      standardDuration: standardDuration,
      sortOrder: sortOrder,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code.trim(),
      'name': name.trim(),
      'description': description?.trim(),
      'standard_duration': standardDuration ?? 0,
      'sort_order': sortOrder ?? 0,
      'is_active': isActive,
    };
  }
}

class ProcessPageDto {
  const ProcessPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ProcessDto> items;
  final int total;
  final int page;
  final int pageSize;
}
