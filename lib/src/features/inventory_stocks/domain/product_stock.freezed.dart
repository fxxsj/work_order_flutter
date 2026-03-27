// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_stock.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductStock _$ProductStockFromJson(Map<String, dynamic> json) {
  return _ProductStock.fromJson(json);
}

/// @nodoc
mixin _$ProductStock {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  String? get productCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  String? get batchNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
  double? get reservedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
  double? get availableQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
  int? get minStockLevel => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get productionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
  double? get unitCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
  double? get totalValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
  bool? get isLowStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
  int? get daysUntilExpiry => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ProductStock to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductStockCopyWith<ProductStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductStockCopyWith<$Res> {
  factory $ProductStockCopyWith(
          ProductStock value, $Res Function(ProductStock) then) =
      _$ProductStockCopyWithImpl<$Res, ProductStock>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
      String? batchNo,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
      double? reservedQuantity,
      @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
      double? availableQuantity,
      @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
      int? minStockLevel,
      @JsonKey(fromJson: _stringOrNullFromJson) String? location,
      @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? productionDate,
      @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
      double? unitCost,
      @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
      double? totalValue,
      @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
      bool? isLowStock,
      @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? expiryDate,
      @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
      int? daysUntilExpiry,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class _$ProductStockCopyWithImpl<$Res, $Val extends ProductStock>
    implements $ProductStockCopyWith<$Res> {
  _$ProductStockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? customerName = freezed,
    Object? batchNo = freezed,
    Object? workOrderNumber = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? quantity = freezed,
    Object? reservedQuantity = freezed,
    Object? availableQuantity = freezed,
    Object? minStockLevel = freezed,
    Object? location = freezed,
    Object? productionDate = freezed,
    Object? unitCost = freezed,
    Object? totalValue = freezed,
    Object? isLowStock = freezed,
    Object? expiryDate = freezed,
    Object? daysUntilExpiry = freezed,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      reservedQuantity: freezed == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      minStockLevel: freezed == minStockLevel
          ? _value.minStockLevel
          : minStockLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      productionDate: freezed == productionDate
          ? _value.productionDate
          : productionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unitCost: freezed == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      isLowStock: freezed == isLowStock
          ? _value.isLowStock
          : isLowStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysUntilExpiry: freezed == daysUntilExpiry
          ? _value.daysUntilExpiry
          : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductStockImplCopyWith<$Res>
    implements $ProductStockCopyWith<$Res> {
  factory _$$ProductStockImplCopyWith(
          _$ProductStockImpl value, $Res Function(_$ProductStockImpl) then) =
      __$$ProductStockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      String? productCode,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
      String? batchNo,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(fromJson: _doubleOrNullFromJson) double? quantity,
      @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
      double? reservedQuantity,
      @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
      double? availableQuantity,
      @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
      int? minStockLevel,
      @JsonKey(fromJson: _stringOrNullFromJson) String? location,
      @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? productionDate,
      @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
      double? unitCost,
      @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
      double? totalValue,
      @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
      bool? isLowStock,
      @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? expiryDate,
      @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
      int? daysUntilExpiry,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class __$$ProductStockImplCopyWithImpl<$Res>
    extends _$ProductStockCopyWithImpl<$Res, _$ProductStockImpl>
    implements _$$ProductStockImplCopyWith<$Res> {
  __$$ProductStockImplCopyWithImpl(
      _$ProductStockImpl _value, $Res Function(_$ProductStockImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = freezed,
    Object? productCode = freezed,
    Object? customerName = freezed,
    Object? batchNo = freezed,
    Object? workOrderNumber = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? quantity = freezed,
    Object? reservedQuantity = freezed,
    Object? availableQuantity = freezed,
    Object? minStockLevel = freezed,
    Object? location = freezed,
    Object? productionDate = freezed,
    Object? unitCost = freezed,
    Object? totalValue = freezed,
    Object? isLowStock = freezed,
    Object? expiryDate = freezed,
    Object? daysUntilExpiry = freezed,
    Object? createdAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$ProductStockImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productCode: freezed == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double?,
      reservedQuantity: freezed == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      availableQuantity: freezed == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      minStockLevel: freezed == minStockLevel
          ? _value.minStockLevel
          : minStockLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      productionDate: freezed == productionDate
          ? _value.productionDate
          : productionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unitCost: freezed == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double?,
      totalValue: freezed == totalValue
          ? _value.totalValue
          : totalValue // ignore: cast_nullable_to_non_nullable
              as double?,
      isLowStock: freezed == isLowStock
          ? _value.isLowStock
          : isLowStock // ignore: cast_nullable_to_non_nullable
              as bool?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      daysUntilExpiry: freezed == daysUntilExpiry
          ? _value.daysUntilExpiry
          : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductStockImpl implements _ProductStock {
  const _$ProductStockImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      this.productName,
      @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
      this.productCode,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) this.batchNo,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(fromJson: _doubleOrNullFromJson) this.quantity,
      @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
      this.reservedQuantity,
      @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
      this.availableQuantity,
      @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
      this.minStockLevel,
      @JsonKey(fromJson: _stringOrNullFromJson) this.location,
      @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
      this.productionDate,
      @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
      this.unitCost,
      @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
      this.totalValue,
      @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
      this.isLowStock,
      @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
      this.expiryDate,
      @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
      this.daysUntilExpiry,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      this.createdAt,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes});

  factory _$ProductStockImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductStockImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  final String? productName;
  @override
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  final String? productCode;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  final String? batchNo;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  final double? quantity;
  @override
  @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
  final double? reservedQuantity;
  @override
  @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
  final double? availableQuantity;
  @override
  @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
  final int? minStockLevel;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? location;
  @override
  @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? productionDate;
  @override
  @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
  final double? unitCost;
  @override
  @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
  final double? totalValue;
  @override
  @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
  final bool? isLowStock;
  @override
  @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? expiryDate;
  @override
  @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
  final int? daysUntilExpiry;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;

  @override
  String toString() {
    return 'ProductStock(id: $id, productName: $productName, productCode: $productCode, customerName: $customerName, batchNo: $batchNo, workOrderNumber: $workOrderNumber, status: $status, statusDisplay: $statusDisplay, quantity: $quantity, reservedQuantity: $reservedQuantity, availableQuantity: $availableQuantity, minStockLevel: $minStockLevel, location: $location, productionDate: $productionDate, unitCost: $unitCost, totalValue: $totalValue, isLowStock: $isLowStock, expiryDate: $expiryDate, daysUntilExpiry: $daysUntilExpiry, createdAt: $createdAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductStockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.batchNo, batchNo) || other.batchNo == batchNo) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reservedQuantity, reservedQuantity) ||
                other.reservedQuantity == reservedQuantity) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.minStockLevel, minStockLevel) ||
                other.minStockLevel == minStockLevel) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.productionDate, productionDate) ||
                other.productionDate == productionDate) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.totalValue, totalValue) ||
                other.totalValue == totalValue) &&
            (identical(other.isLowStock, isLowStock) ||
                other.isLowStock == isLowStock) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.daysUntilExpiry, daysUntilExpiry) ||
                other.daysUntilExpiry == daysUntilExpiry) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        productName,
        productCode,
        customerName,
        batchNo,
        workOrderNumber,
        status,
        statusDisplay,
        quantity,
        reservedQuantity,
        availableQuantity,
        minStockLevel,
        location,
        productionDate,
        unitCost,
        totalValue,
        isLowStock,
        expiryDate,
        daysUntilExpiry,
        createdAt,
        notes
      ]);

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductStockImplCopyWith<_$ProductStockImpl> get copyWith =>
      __$$ProductStockImplCopyWithImpl<_$ProductStockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductStockImplToJson(
      this,
    );
  }
}

abstract class _ProductStock implements ProductStock {
  const factory _ProductStock(
          {@JsonKey(fromJson: _intFromJson) required final int id,
          @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
          final String? productName,
          @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
          final String? productCode,
          @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
          final String? customerName,
          @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
          final String? batchNo,
          @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
          final String? workOrderNumber,
          @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
          @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
          final String? statusDisplay,
          @JsonKey(fromJson: _doubleOrNullFromJson) final double? quantity,
          @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
          final double? reservedQuantity,
          @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
          final double? availableQuantity,
          @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
          final int? minStockLevel,
          @JsonKey(fromJson: _stringOrNullFromJson) final String? location,
          @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
          final DateTime? productionDate,
          @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
          final double? unitCost,
          @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
          final double? totalValue,
          @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
          final bool? isLowStock,
          @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
          final DateTime? expiryDate,
          @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
          final int? daysUntilExpiry,
          @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
          final DateTime? createdAt,
          @JsonKey(fromJson: _stringOrNullFromJson) final String? notes}) =
      _$ProductStockImpl;

  factory _ProductStock.fromJson(Map<String, dynamic> json) =
      _$ProductStockImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName;
  @override
  @JsonKey(name: 'product_code', fromJson: _stringOrNullFromJson)
  String? get productCode;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  String? get batchNo;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(fromJson: _doubleOrNullFromJson)
  double? get quantity;
  @override
  @JsonKey(name: 'reserved_quantity', fromJson: _doubleOrNullFromJson)
  double? get reservedQuantity;
  @override
  @JsonKey(name: 'available_quantity', fromJson: _doubleOrNullFromJson)
  double? get availableQuantity;
  @override
  @JsonKey(name: 'min_stock_level', fromJson: _intOrNullFromJson)
  int? get minStockLevel;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get location;
  @override
  @JsonKey(name: 'production_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get productionDate;
  @override
  @JsonKey(name: 'unit_cost', fromJson: _doubleOrNullFromJson)
  double? get unitCost;
  @override
  @JsonKey(name: 'total_value', fromJson: _doubleOrNullFromJson)
  double? get totalValue;
  @override
  @JsonKey(name: 'is_low_stock', fromJson: _boolOrNullFromJson)
  bool? get isLowStock;
  @override
  @JsonKey(name: 'expiry_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get expiryDate;
  @override
  @JsonKey(name: 'days_until_expiry', fromJson: _intOrNullFromJson)
  int? get daysUntilExpiry;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;

  /// Create a copy of ProductStock
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductStockImplCopyWith<_$ProductStockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
