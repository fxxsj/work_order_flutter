// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:work_order_app/src/core/utils/parse_utils.dart';

part 'salesperson.freezed.dart';
part 'salesperson.g.dart';

/// 业务员领域模型。
@freezed
class Salesperson with _$Salesperson {
  /// 创建一个业务员对象。
  const factory Salesperson({
    @JsonKey(fromJson: _intFromJson) required int id,
    @JsonKey(fromJson: _stringFromJson) required String name,
  }) = _Salesperson;

  /// 从 Map 反序列化。
  factory Salesperson.fromJson(Map<String, dynamic> json) =>
      _$SalespersonFromJson(json);
}

int _intFromJson(Object? value) => toInt(value) ?? 0;

String _stringFromJson(Object? value) => value?.toString() ?? '';
