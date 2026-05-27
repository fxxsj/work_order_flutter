import 'package:work_order_app/src/features/audit_logs/domain/audit_log.dart';

class AuditLogDto {
  const AuditLogDto({
    required this.id,
    this.actionType,
    this.username,
    this.contentTypeName,
    this.objectId,
    this.objectRepr,
    this.changedFields = const [],
    this.ipAddress,
    this.requestMethod,
    this.requestPath,
    this.createdAt,
  });

  final String id;
  final String? actionType;
  final String? username;
  final String? contentTypeName;
  final String? objectId;
  final String? objectRepr;
  final List<String> changedFields;
  final String? ipAddress;
  final String? requestMethod;
  final String? requestPath;
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
      objectId: objectId,
      objectRepr: objectRepr,
      changedFields: changedFields,
      ipAddress: ipAddress,
      requestMethod: requestMethod,
      requestPath: requestPath,
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
      objectId: objectId,
      objectRepr: objectRepr,
      changedFields: changedFields,
      ipAddress: ipAddress,
      requestMethod: requestMethod,
      requestPath: requestPath,
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
