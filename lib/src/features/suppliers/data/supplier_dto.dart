import 'package:work_order_app/src/features/suppliers/domain/supplier.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

/// 供应商数据传输对象。
class SupplierDto {
  SupplierDto({
    required this.id,
    required this.name,
    this.code,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.status,
    this.statusDisplay,
    this.materialCount,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? code;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? status;
  final String? statusDisplay;
  final int? materialCount;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory SupplierDto.fromJson(Map<String, dynamic> json) {
    return SupplierDto(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      code: toStringOrNull(json['code']),
      contactPerson: toStringOrNull(json['contact_person']),
      phone: toStringOrNull(json['phone']),
      email: toStringOrNull(json['email']),
      address: toStringOrNull(json['address']),
      status: toStringOrNull(json['status']),
      statusDisplay: toStringOrNull(json['status_display']),
      materialCount: toInt(json['material_count']),
      notes: toStringOrNull(json['notes']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  factory SupplierDto.fromEntity(Supplier entity) {
    return SupplierDto(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      contactPerson: entity.contactPerson,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      status: entity.status,
      statusDisplay: entity.statusDisplay,
      materialCount: entity.materialCount,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Supplier toEntity() {
    return Supplier(
      id: id,
      name: name,
      code: code,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      address: address,
      status: status,
      statusDisplay: statusDisplay,
      materialCount: materialCount,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'code': code?.trim(),
      'name': name.trim(),
      'contact_person': contactPerson?.trim(),
      'phone': phone?.trim(),
      'email': email?.trim(),
      'address': address?.trim(),
      'status': status?.trim(),
      'notes': notes?.trim(),
    };
  }
}

class SupplierPageDto {
  const SupplierPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<SupplierDto> items;
  final int total;
  final int page;
  final int pageSize;
}
