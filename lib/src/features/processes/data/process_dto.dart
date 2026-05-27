import 'package:work_order_app/src/features/processes/domain/process.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

class ProcessDto {
  ProcessDto({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.standardDuration,
    this.sortOrder,
    this.isActive = true,
    this.isBuiltin = false,
    this.taskGenerationRule = 'general',
    this.requiresArtwork = false,
    this.requiresDie = false,
    this.requiresFoilingPlate = false,
    this.requiresEmbossingPlate = false,
    this.artworkRequired = true,
    this.dieRequired = true,
    this.foilingPlateRequired = true,
    this.embossingPlateRequired = true,
    this.isParallel = false,
    this.createdAt,
  });

  final int id;
  final String code;
  final String name;
  final String? description;
  final int? standardDuration;
  final int? sortOrder;
  final bool isActive;
  final bool isBuiltin;
  final String taskGenerationRule;
  final bool requiresArtwork;
  final bool requiresDie;
  final bool requiresFoilingPlate;
  final bool requiresEmbossingPlate;
  final bool artworkRequired;
  final bool dieRequired;
  final bool foilingPlateRequired;
  final bool embossingPlateRequired;
  final bool isParallel;
  final DateTime? createdAt;

  factory ProcessDto.fromJson(Map<String, dynamic> json) {
    return ProcessDto(
      id: toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: toStringOrNull(json['description']),
      standardDuration: toInt(json['standard_duration']),
      sortOrder: toInt(json['sort_order']),
      isActive: json['is_active'] == null ? true : json['is_active'] == true,
      isBuiltin: json['is_builtin'] == true,
      taskGenerationRule: json['task_generation_rule']?.toString() ?? 'general',
      requiresArtwork: json['requires_artwork'] == true,
      requiresDie: json['requires_die'] == true,
      requiresFoilingPlate: json['requires_foiling_plate'] == true,
      requiresEmbossingPlate: json['requires_embossing_plate'] == true,
      artworkRequired: json['artwork_required'] == null
          ? true
          : json['artwork_required'] == true,
      dieRequired: json['die_required'] == null
          ? true
          : json['die_required'] == true,
      foilingPlateRequired: json['foiling_plate_required'] == null
          ? true
          : json['foiling_plate_required'] == true,
      embossingPlateRequired: json['embossing_plate_required'] == null
          ? true
          : json['embossing_plate_required'] == true,
      isParallel: json['is_parallel'] == true,
      createdAt: toDateTime(json['created_at']),
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
      isBuiltin: entity.isBuiltin,
      taskGenerationRule: entity.taskGenerationRule,
      requiresArtwork: entity.requiresArtwork,
      requiresDie: entity.requiresDie,
      requiresFoilingPlate: entity.requiresFoilingPlate,
      requiresEmbossingPlate: entity.requiresEmbossingPlate,
      artworkRequired: entity.artworkRequired,
      dieRequired: entity.dieRequired,
      foilingPlateRequired: entity.foilingPlateRequired,
      embossingPlateRequired: entity.embossingPlateRequired,
      isParallel: entity.isParallel,
      createdAt: entity.createdAt,
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
      isBuiltin: isBuiltin,
      taskGenerationRule: taskGenerationRule,
      requiresArtwork: requiresArtwork,
      requiresDie: requiresDie,
      requiresFoilingPlate: requiresFoilingPlate,
      requiresEmbossingPlate: requiresEmbossingPlate,
      artworkRequired: artworkRequired,
      dieRequired: dieRequired,
      foilingPlateRequired: foilingPlateRequired,
      embossingPlateRequired: embossingPlateRequired,
      isParallel: isParallel,
      createdAt: createdAt,
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
      'is_builtin': isBuiltin,
      'task_generation_rule': taskGenerationRule,
      'requires_artwork': requiresArtwork,
      'requires_die': requiresDie,
      'requires_foiling_plate': requiresFoilingPlate,
      'requires_embossing_plate': requiresEmbossingPlate,
      'artwork_required': artworkRequired,
      'die_required': dieRequired,
      'foiling_plate_required': foilingPlateRequired,
      'embossing_plate_required': embossingPlateRequired,
      'is_parallel': isParallel,
    };
  }
}

extension ProcessMapper on Process {
  ProcessDto toDto() {
    return ProcessDto(
      id: id,
      code: code,
      name: name,
      description: description,
      standardDuration: standardDuration,
      sortOrder: sortOrder,
      isActive: isActive,
      isBuiltin: isBuiltin,
      taskGenerationRule: taskGenerationRule,
      requiresArtwork: requiresArtwork,
      requiresDie: requiresDie,
      requiresFoilingPlate: requiresFoilingPlate,
      requiresEmbossingPlate: requiresEmbossingPlate,
      artworkRequired: artworkRequired,
      dieRequired: dieRequired,
      foilingPlateRequired: foilingPlateRequired,
      embossingPlateRequired: embossingPlateRequired,
      isParallel: isParallel,
      createdAt: createdAt,
    );
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
