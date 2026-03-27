// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

/// 客户领域模型。
@freezed
class Customer with _$Customer {
  /// 创建一个客户实体。
  const factory Customer({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? contactPerson,
    @JsonKey(fromJson: _stringOrNullFromJson) String? phone,
    @JsonKey(fromJson: _stringOrNullFromJson) String? email,
    @JsonKey(fromJson: _stringOrNullFromJson) String? address,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(fromJson: _intOrNullFromJson) int? salespersonId,
    @JsonKey(fromJson: _stringOrNullFromJson) String? salespersonName,
    @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
    DateTime? updatedAt,
  }) = _Customer;

  /// 从 Map 反序列化为 Customer。
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

String? _dateTimeOrNullToJson(DateTime? value) => value?.toIso8601String();

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
