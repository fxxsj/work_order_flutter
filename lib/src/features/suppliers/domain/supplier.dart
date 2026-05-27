// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'supplier.freezed.dart';
part 'supplier.g.dart';

@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String name,
    @JsonKey(fromJson: _stringOrNullFromJson) String? code,
    @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)
    String? contactPerson,
    @JsonKey(fromJson: _stringOrNullFromJson) String? phone,
    @JsonKey(fromJson: _stringOrNullFromJson) String? email,
    @JsonKey(fromJson: _stringOrNullFromJson) String? address,
    @JsonKey(fromJson: _stringOrNullFromJson) String? status,
    @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
    String? statusDisplay,
    @JsonKey(name: 'material_count', fromJson: _intOrNullFromJson)
    int? materialCount,
    @JsonKey(fromJson: _stringOrNullFromJson) String? notes,
    @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
    DateTime? updatedAt,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

int? _intOrNullFromJson(Object? value) => toInt(value);

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _stringOrNullFromJson(Object? value) => toStringOrNull(value);

DateTime? _dateTimeOrNullFromJson(Object? value) => toDateTime(value);

String? _dateTimeOrNullToJson(DateTime? value) => value?.toIso8601String();
