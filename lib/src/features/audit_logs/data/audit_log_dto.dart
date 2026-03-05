import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';

class AuditLogDto {
  const AuditLogDto({
    required this.id,
    this.actionType,
    this.username,
    this.contentTypeName,
    this.objectRepr,
    this.changedFields,
    this.ipAddress,
    this.createdAt,
  });

  final int id;
  final String? actionType;
  final String? username;
  final String? contentTypeName;
  final String? objectRepr;
  final String? changedFields;
  final String? ipAddress;
  final DateTime? createdAt;

  factory AuditLogDto.fromJson(Map<String, dynamic> json) {
    return AuditLog.fromJson(json).toDto();
  }

  AuditLog toEntity() {
    return AuditLog(
      id: id,
      actionType: actionType,
      username: username,
      contentTypeName: contentTypeName,
      objectRepr: objectRepr,
      changedFields: changedFields,
      ipAddress: ipAddress,
      createdAt: createdAt,
    );
  }
}

extension AuditLogMapper on AuditLog {
  AuditLogDto toDto() {
    return AuditLogDto(
      id: id,
      actionType: actionType,
      username: username,
      contentTypeName: contentTypeName,
      objectRepr: objectRepr,
      changedFields: changedFields,
      ipAddress: ipAddress,
      createdAt: createdAt,
    );
  }
}

class AuditLogPageDto {
  const AuditLogPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<AuditLogDto> items;
  final int total;
  final int page;
  final int pageSize;
}
