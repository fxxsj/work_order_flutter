// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_cost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductionCost _$ProductionCostFromJson(Map<String, dynamic> json) {
  return _ProductionCost.fromJson(json);
}

/// @nodoc
mixin _$ProductionCost {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'total_cost',
      readValue: _readTotalCost,
      fromJson: _doubleOrNullFromJson)
  double? get totalCost => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'calculated_at',
      readValue: _readCalculatedAt,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get calculatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductionCost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductionCost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductionCostCopyWith<ProductionCost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductionCostCopyWith<$Res> {
  factory $ProductionCostCopyWith(
          ProductionCost value, $Res Function(ProductionCost) then) =
      _$ProductionCostCopyWithImpl<$Res, ProductionCost>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(
          name: 'total_cost',
          readValue: _readTotalCost,
          fromJson: _doubleOrNullFromJson)
      double? totalCost,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(
          name: 'calculated_at',
          readValue: _readCalculatedAt,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? calculatedAt});
}

/// @nodoc
class _$ProductionCostCopyWithImpl<$Res, $Val extends ProductionCost>
    implements $ProductionCostCopyWith<$Res> {
  _$ProductionCostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductionCost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workOrderNumber = freezed,
    Object? totalCost = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? calculatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      calculatedAt: freezed == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductionCostImplCopyWith<$Res>
    implements $ProductionCostCopyWith<$Res> {
  factory _$$ProductionCostImplCopyWith(_$ProductionCostImpl value,
          $Res Function(_$ProductionCostImpl) then) =
      __$$ProductionCostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(
          name: 'total_cost',
          readValue: _readTotalCost,
          fromJson: _doubleOrNullFromJson)
      double? totalCost,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(
          name: 'calculated_at',
          readValue: _readCalculatedAt,
          fromJson: _dateTimeOrNullFromJson)
      DateTime? calculatedAt});
}

/// @nodoc
class __$$ProductionCostImplCopyWithImpl<$Res>
    extends _$ProductionCostCopyWithImpl<$Res, _$ProductionCostImpl>
    implements _$$ProductionCostImplCopyWith<$Res> {
  __$$ProductionCostImplCopyWithImpl(
      _$ProductionCostImpl _value, $Res Function(_$ProductionCostImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductionCost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workOrderNumber = freezed,
    Object? totalCost = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? calculatedAt = freezed,
  }) {
    return _then(_$ProductionCostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      totalCost: freezed == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      calculatedAt: freezed == calculatedAt
          ? _value.calculatedAt
          : calculatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductionCostImpl implements _ProductionCost {
  const _$ProductionCostImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(
          name: 'total_cost',
          readValue: _readTotalCost,
          fromJson: _doubleOrNullFromJson)
      this.totalCost,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(
          name: 'calculated_at',
          readValue: _readCalculatedAt,
          fromJson: _dateTimeOrNullFromJson)
      this.calculatedAt});

  factory _$ProductionCostImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductionCostImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(
      name: 'total_cost',
      readValue: _readTotalCost,
      fromJson: _doubleOrNullFromJson)
  final double? totalCost;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(
      name: 'calculated_at',
      readValue: _readCalculatedAt,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? calculatedAt;

  @override
  String toString() {
    return 'ProductionCost(id: $id, workOrderNumber: $workOrderNumber, totalCost: $totalCost, status: $status, statusDisplay: $statusDisplay, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductionCostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.calculatedAt, calculatedAt) ||
                other.calculatedAt == calculatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, workOrderNumber, totalCost,
      status, statusDisplay, calculatedAt);

  /// Create a copy of ProductionCost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductionCostImplCopyWith<_$ProductionCostImpl> get copyWith =>
      __$$ProductionCostImplCopyWithImpl<_$ProductionCostImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductionCostImplToJson(
      this,
    );
  }
}

abstract class _ProductionCost implements ProductionCost {
  const factory _ProductionCost(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(
          name: 'work_order_number',
          readValue: _readWorkOrderNumber,
          fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(
          name: 'total_cost',
          readValue: _readTotalCost,
          fromJson: _doubleOrNullFromJson)
      final double? totalCost,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(
          name: 'calculated_at',
          readValue: _readCalculatedAt,
          fromJson: _dateTimeOrNullFromJson)
      final DateTime? calculatedAt}) = _$ProductionCostImpl;

  factory _ProductionCost.fromJson(Map<String, dynamic> json) =
      _$ProductionCostImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(
      name: 'work_order_number',
      readValue: _readWorkOrderNumber,
      fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(
      name: 'total_cost',
      readValue: _readTotalCost,
      fromJson: _doubleOrNullFromJson)
  double? get totalCost;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(
      name: 'calculated_at',
      readValue: _readCalculatedAt,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get calculatedAt;

  /// Create a copy of ProductionCost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductionCostImplCopyWith<_$ProductionCostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
