import 'package:work_order_app/src/core/utils/parse_utils.dart';
import 'package:work_order_app/src/features/customer/domain/customer.dart';

/// 客户数据传输对象。
class CustomerDto {
  CustomerDto({
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

  /// 从 API JSON 创建 DTO。
  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      contactPerson: toStringOrNull(json['contact_person']),
      phone: toStringOrNull(json['phone']),
      email: toStringOrNull(json['email']),
      address: toStringOrNull(json['address']),
      notes: toStringOrNull(json['notes']),
      salespersonId: toInt(json['salesperson']),
      salespersonName: toStringOrNull(json['salesperson_name']),
      createdAt: toDateTime(json['created_at']),
      updatedAt: toDateTime(json['updated_at']),
    );
  }

  /// 从领域实体创建 DTO。
  factory CustomerDto.fromEntity(Customer entity) {
    return CustomerDto(
      id: entity.id,
      name: entity.name,
      contactPerson: entity.contactPerson,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      notes: entity.notes,
      salespersonId: entity.salespersonId,
      salespersonName: entity.salespersonName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// 转换为领域实体。
  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      contactPerson: contactPerson,
      phone: phone,
      email: email,
      address: address,
      notes: notes,
      salespersonId: salespersonId,
      salespersonName: salespersonName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 转换为 API 提交 payload。
  Map<String, dynamic> toPayload() {
    return {
      'name': name.trim(),
      'contact_person': contactPerson?.trim(),
      'phone': phone?.trim(),
      'email': email?.trim(),
      'address': address?.trim(),
      'notes': notes?.trim(),
      'salesperson': salespersonId,
    };
  }
}

/// 客户分页数据传输对象。
class CustomerPageDto {
  const CustomerPageDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<CustomerDto> items;
  final int total;
  final int page;
  final int pageSize;

  /// 转换为领域实体。
  CustomerPage toEntity() {
    return CustomerPage(
      items: items.map((item) => item.toEntity()).toList(),
      total: total,
      page: page,
      pageSize: pageSize,
    );
  }
}
