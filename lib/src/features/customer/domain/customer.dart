import 'package:work_order_app/src/core/utils/parse_utils.dart';

/// Sentinel object used by [Customer.copyWith] to distinguish
/// "not provided" from an explicit `null` value.
const _sentinel = Object();

/// 客户领域模型。
class Customer {
  /// 创建一个客户实体。
  const Customer({
    required this.id,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.salespersonId,
    this.salespersonName,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final int? salespersonId;
  final String? salespersonName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// 复制当前客户对象并更新指定字段。
  /// 使用 sentinel 模式，可以显式传入 null 来清空可空字段。
  Customer copyWith({
    int? id,
    String? name,
    Object? contactPerson = _sentinel,
    Object? phone = _sentinel,
    Object? email = _sentinel,
    Object? address = _sentinel,
    Object? notes = _sentinel,
    Object? salespersonId = _sentinel,
    Object? salespersonName = _sentinel,
    Object? createdAt = _sentinel,
    Object? updatedAt = _sentinel,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: identical(contactPerson, _sentinel)
          ? this.contactPerson
          : contactPerson as String?,
      phone: identical(phone, _sentinel) ? this.phone : phone as String?,
      email: identical(email, _sentinel) ? this.email : email as String?,
      address:
          identical(address, _sentinel) ? this.address : address as String?,
      notes: identical(notes, _sentinel) ? this.notes : notes as String?,
      salespersonId: identical(salespersonId, _sentinel)
          ? this.salespersonId
          : salespersonId as int?,
      salespersonName: identical(salespersonName, _sentinel)
          ? this.salespersonName
          : salespersonName as String?,
      createdAt: identical(createdAt, _sentinel)
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: identical(updatedAt, _sentinel)
          ? this.updatedAt
          : updatedAt as DateTime?,
    );
  }

  /// 序列化为 Map，便于调试或持久化。
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactPerson': contactPerson,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'salespersonId': salespersonId,
      'salespersonName': salespersonName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 从 Map 反序列化为 Customer。
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      contactPerson: toStringOrNull(json['contactPerson']),
      phone: toStringOrNull(json['phone']),
      email: toStringOrNull(json['email']),
      address: toStringOrNull(json['address']),
      notes: toStringOrNull(json['notes']),
      salespersonId: toInt(json['salespersonId']),
      salespersonName: toStringOrNull(json['salespersonName']),
      createdAt: toDateTime(json['createdAt']),
      updatedAt: toDateTime(json['updatedAt']),
    );
  }
}

/// 客户列表分页结果。
class CustomerPage {
  /// 创建一个分页结果。
  const CustomerPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Customer> items;
  final int total;
  final int page;
  final int pageSize;

  /// 是否还有下一页。
  bool get hasNext => items.length + (page - 1) * pageSize < total;

  /// 是否有上一页。
  bool get hasPrev => page > 1;
}

