// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quality_inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QualityInspection _$QualityInspectionFromJson(Map<String, dynamic> json) {
  return _QualityInspection.fromJson(json);
}

/// @nodoc
mixin _$QualityInspection {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
  String get inspectionNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
  String? get inspectionType => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
  String? get inspectionTypeDisplay => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get result => throw _privateConstructorUsedError;
  @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
  String? get resultDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  String? get batchNo => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
  String? get inspectorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get inspectionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
  double? get inspectionQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
  double? get passedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
  double? get failedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
  String? get defectiveRateFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
  String? get inspectionStandard => throw _privateConstructorUsedError;
  @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
  List<String> get inspectionItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'defects', fromJson: _stringListFromJson)
  List<String> get defects => throw _privateConstructorUsedError;
  @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
  String? get defectDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
  String? get disposition => throw _privateConstructorUsedError;
  @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
  String? get dispositionNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  String? get attachmentUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this QualityInspection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QualityInspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QualityInspectionCopyWith<QualityInspection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QualityInspectionCopyWith<$Res> {
  factory $QualityInspectionCopyWith(
          QualityInspection value, $Res Function(QualityInspection) then) =
      _$QualityInspectionCopyWithImpl<$Res, QualityInspection>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
      String inspectionNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
      String? inspectionType,
      @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
      String? inspectionTypeDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) String? result,
      @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
      String? resultDisplay,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
      String? batchNo,
      @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
      String? inspectorName,
      @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? inspectionDate,
      @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
      double? inspectionQuantity,
      @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
      double? passedQuantity,
      @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
      double? failedQuantity,
      @JsonKey(
          name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
      String? defectiveRateFormatted,
      @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
      String? inspectionStandard,
      @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
      List<String> inspectionItems,
      @JsonKey(name: 'defects', fromJson: _stringListFromJson)
      List<String> defects,
      @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
      String? defectDescription,
      @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
      String? disposition,
      @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
      String? dispositionNotes,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class _$QualityInspectionCopyWithImpl<$Res, $Val extends QualityInspection>
    implements $QualityInspectionCopyWith<$Res> {
  _$QualityInspectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QualityInspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionNumber = null,
    Object? workOrderId = freezed,
    Object? inspectionType = freezed,
    Object? inspectionTypeDisplay = freezed,
    Object? result = freezed,
    Object? resultDisplay = freezed,
    Object? customerName = freezed,
    Object? workOrderNumber = freezed,
    Object? productName = freezed,
    Object? batchNo = freezed,
    Object? inspectorName = freezed,
    Object? inspectionDate = freezed,
    Object? inspectionQuantity = freezed,
    Object? passedQuantity = freezed,
    Object? failedQuantity = freezed,
    Object? defectiveRateFormatted = freezed,
    Object? inspectionStandard = freezed,
    Object? inspectionItems = null,
    Object? defects = null,
    Object? defectDescription = freezed,
    Object? disposition = freezed,
    Object? dispositionNotes = freezed,
    Object? attachmentUrl = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inspectionNumber: null == inspectionNumber
          ? _value.inspectionNumber
          : inspectionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectionType: freezed == inspectionType
          ? _value.inspectionType
          : inspectionType // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionTypeDisplay: freezed == inspectionTypeDisplay
          ? _value.inspectionTypeDisplay
          : inspectionTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      resultDisplay: freezed == resultDisplay
          ? _value.resultDisplay
          : resultDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionDate: freezed == inspectionDate
          ? _value.inspectionDate
          : inspectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      inspectionQuantity: freezed == inspectionQuantity
          ? _value.inspectionQuantity
          : inspectionQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      passedQuantity: freezed == passedQuantity
          ? _value.passedQuantity
          : passedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      failedQuantity: freezed == failedQuantity
          ? _value.failedQuantity
          : failedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      defectiveRateFormatted: freezed == defectiveRateFormatted
          ? _value.defectiveRateFormatted
          : defectiveRateFormatted // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionStandard: freezed == inspectionStandard
          ? _value.inspectionStandard
          : inspectionStandard // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionItems: null == inspectionItems
          ? _value.inspectionItems
          : inspectionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defects: null == defects
          ? _value.defects
          : defects // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defectDescription: freezed == defectDescription
          ? _value.defectDescription
          : defectDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      disposition: freezed == disposition
          ? _value.disposition
          : disposition // ignore: cast_nullable_to_non_nullable
              as String?,
      dispositionNotes: freezed == dispositionNotes
          ? _value.dispositionNotes
          : dispositionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QualityInspectionImplCopyWith<$Res>
    implements $QualityInspectionCopyWith<$Res> {
  factory _$$QualityInspectionImplCopyWith(_$QualityInspectionImpl value,
          $Res Function(_$QualityInspectionImpl) then) =
      __$$QualityInspectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
      String inspectionNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      int? workOrderId,
      @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
      String? inspectionType,
      @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
      String? inspectionTypeDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) String? result,
      @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
      String? resultDisplay,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      String? workOrderNumber,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      String? productName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
      String? batchNo,
      @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
      String? inspectorName,
      @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
      DateTime? inspectionDate,
      @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
      double? inspectionQuantity,
      @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
      double? passedQuantity,
      @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
      double? failedQuantity,
      @JsonKey(
          name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
      String? defectiveRateFormatted,
      @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
      String? inspectionStandard,
      @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
      List<String> inspectionItems,
      @JsonKey(name: 'defects', fromJson: _stringListFromJson)
      List<String> defects,
      @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
      String? defectDescription,
      @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
      String? disposition,
      @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
      String? dispositionNotes,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) String? notes});
}

/// @nodoc
class __$$QualityInspectionImplCopyWithImpl<$Res>
    extends _$QualityInspectionCopyWithImpl<$Res, _$QualityInspectionImpl>
    implements _$$QualityInspectionImplCopyWith<$Res> {
  __$$QualityInspectionImplCopyWithImpl(_$QualityInspectionImpl _value,
      $Res Function(_$QualityInspectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QualityInspection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inspectionNumber = null,
    Object? workOrderId = freezed,
    Object? inspectionType = freezed,
    Object? inspectionTypeDisplay = freezed,
    Object? result = freezed,
    Object? resultDisplay = freezed,
    Object? customerName = freezed,
    Object? workOrderNumber = freezed,
    Object? productName = freezed,
    Object? batchNo = freezed,
    Object? inspectorName = freezed,
    Object? inspectionDate = freezed,
    Object? inspectionQuantity = freezed,
    Object? passedQuantity = freezed,
    Object? failedQuantity = freezed,
    Object? defectiveRateFormatted = freezed,
    Object? inspectionStandard = freezed,
    Object? inspectionItems = null,
    Object? defects = null,
    Object? defectDescription = freezed,
    Object? disposition = freezed,
    Object? dispositionNotes = freezed,
    Object? attachmentUrl = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$QualityInspectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inspectionNumber: null == inspectionNumber
          ? _value.inspectionNumber
          : inspectionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      workOrderId: freezed == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int?,
      inspectionType: freezed == inspectionType
          ? _value.inspectionType
          : inspectionType // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionTypeDisplay: freezed == inspectionTypeDisplay
          ? _value.inspectionTypeDisplay
          : inspectionTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      resultDisplay: freezed == resultDisplay
          ? _value.resultDisplay
          : resultDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      workOrderNumber: freezed == workOrderNumber
          ? _value.workOrderNumber
          : workOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      batchNo: freezed == batchNo
          ? _value.batchNo
          : batchNo // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectorName: freezed == inspectorName
          ? _value.inspectorName
          : inspectorName // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionDate: freezed == inspectionDate
          ? _value.inspectionDate
          : inspectionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      inspectionQuantity: freezed == inspectionQuantity
          ? _value.inspectionQuantity
          : inspectionQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      passedQuantity: freezed == passedQuantity
          ? _value.passedQuantity
          : passedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      failedQuantity: freezed == failedQuantity
          ? _value.failedQuantity
          : failedQuantity // ignore: cast_nullable_to_non_nullable
              as double?,
      defectiveRateFormatted: freezed == defectiveRateFormatted
          ? _value.defectiveRateFormatted
          : defectiveRateFormatted // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionStandard: freezed == inspectionStandard
          ? _value.inspectionStandard
          : inspectionStandard // ignore: cast_nullable_to_non_nullable
              as String?,
      inspectionItems: null == inspectionItems
          ? _value._inspectionItems
          : inspectionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defects: null == defects
          ? _value._defects
          : defects // ignore: cast_nullable_to_non_nullable
              as List<String>,
      defectDescription: freezed == defectDescription
          ? _value.defectDescription
          : defectDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      disposition: freezed == disposition
          ? _value.disposition
          : disposition // ignore: cast_nullable_to_non_nullable
              as String?,
      dispositionNotes: freezed == dispositionNotes
          ? _value.dispositionNotes
          : dispositionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QualityInspectionImpl implements _QualityInspection {
  const _$QualityInspectionImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
      required this.inspectionNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      this.workOrderId,
      @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
      this.inspectionType,
      @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
      this.inspectionTypeDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) this.result,
      @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
      this.resultDisplay,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      this.workOrderNumber,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      this.productName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) this.batchNo,
      @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
      this.inspectorName,
      @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
      this.inspectionDate,
      @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
      this.inspectionQuantity,
      @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
      this.passedQuantity,
      @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
      this.failedQuantity,
      @JsonKey(
          name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
      this.defectiveRateFormatted,
      @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
      this.inspectionStandard,
      @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
      final List<String> inspectionItems = const <String>[],
      @JsonKey(name: 'defects', fromJson: _stringListFromJson)
      final List<String> defects = const <String>[],
      @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
      this.defectDescription,
      @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
      this.disposition,
      @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
      this.dispositionNotes,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      this.attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes})
      : _inspectionItems = inspectionItems,
        _defects = defects;

  factory _$QualityInspectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QualityInspectionImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
  final String inspectionNumber;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  final int? workOrderId;
  @override
  @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
  final String? inspectionType;
  @override
  @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
  final String? inspectionTypeDisplay;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? result;
  @override
  @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
  final String? resultDisplay;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  final String? workOrderNumber;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  final String? productName;
  @override
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  final String? batchNo;
  @override
  @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
  final String? inspectorName;
  @override
  @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
  final DateTime? inspectionDate;
  @override
  @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
  final double? inspectionQuantity;
  @override
  @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
  final double? passedQuantity;
  @override
  @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
  final double? failedQuantity;
  @override
  @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
  final String? defectiveRateFormatted;
  @override
  @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
  final String? inspectionStandard;
  final List<String> _inspectionItems;
  @override
  @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
  List<String> get inspectionItems {
    if (_inspectionItems is EqualUnmodifiableListView) return _inspectionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inspectionItems);
  }

  final List<String> _defects;
  @override
  @JsonKey(name: 'defects', fromJson: _stringListFromJson)
  List<String> get defects {
    if (_defects is EqualUnmodifiableListView) return _defects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defects);
  }

  @override
  @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
  final String? defectDescription;
  @override
  @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
  final String? disposition;
  @override
  @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
  final String? dispositionNotes;
  @override
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  final String? attachmentUrl;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;

  @override
  String toString() {
    return 'QualityInspection(id: $id, inspectionNumber: $inspectionNumber, workOrderId: $workOrderId, inspectionType: $inspectionType, inspectionTypeDisplay: $inspectionTypeDisplay, result: $result, resultDisplay: $resultDisplay, customerName: $customerName, workOrderNumber: $workOrderNumber, productName: $productName, batchNo: $batchNo, inspectorName: $inspectorName, inspectionDate: $inspectionDate, inspectionQuantity: $inspectionQuantity, passedQuantity: $passedQuantity, failedQuantity: $failedQuantity, defectiveRateFormatted: $defectiveRateFormatted, inspectionStandard: $inspectionStandard, inspectionItems: $inspectionItems, defects: $defects, defectDescription: $defectDescription, disposition: $disposition, dispositionNotes: $dispositionNotes, attachmentUrl: $attachmentUrl, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QualityInspectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inspectionNumber, inspectionNumber) ||
                other.inspectionNumber == inspectionNumber) &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.inspectionType, inspectionType) ||
                other.inspectionType == inspectionType) &&
            (identical(other.inspectionTypeDisplay, inspectionTypeDisplay) ||
                other.inspectionTypeDisplay == inspectionTypeDisplay) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.resultDisplay, resultDisplay) ||
                other.resultDisplay == resultDisplay) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.workOrderNumber, workOrderNumber) ||
                other.workOrderNumber == workOrderNumber) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.batchNo, batchNo) || other.batchNo == batchNo) &&
            (identical(other.inspectorName, inspectorName) ||
                other.inspectorName == inspectorName) &&
            (identical(other.inspectionDate, inspectionDate) ||
                other.inspectionDate == inspectionDate) &&
            (identical(other.inspectionQuantity, inspectionQuantity) ||
                other.inspectionQuantity == inspectionQuantity) &&
            (identical(other.passedQuantity, passedQuantity) ||
                other.passedQuantity == passedQuantity) &&
            (identical(other.failedQuantity, failedQuantity) ||
                other.failedQuantity == failedQuantity) &&
            (identical(other.defectiveRateFormatted, defectiveRateFormatted) ||
                other.defectiveRateFormatted == defectiveRateFormatted) &&
            (identical(other.inspectionStandard, inspectionStandard) ||
                other.inspectionStandard == inspectionStandard) &&
            const DeepCollectionEquality()
                .equals(other._inspectionItems, _inspectionItems) &&
            const DeepCollectionEquality().equals(other._defects, _defects) &&
            (identical(other.defectDescription, defectDescription) ||
                other.defectDescription == defectDescription) &&
            (identical(other.disposition, disposition) ||
                other.disposition == disposition) &&
            (identical(other.dispositionNotes, dispositionNotes) ||
                other.dispositionNotes == dispositionNotes) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        inspectionNumber,
        workOrderId,
        inspectionType,
        inspectionTypeDisplay,
        result,
        resultDisplay,
        customerName,
        workOrderNumber,
        productName,
        batchNo,
        inspectorName,
        inspectionDate,
        inspectionQuantity,
        passedQuantity,
        failedQuantity,
        defectiveRateFormatted,
        inspectionStandard,
        const DeepCollectionEquality().hash(_inspectionItems),
        const DeepCollectionEquality().hash(_defects),
        defectDescription,
        disposition,
        dispositionNotes,
        attachmentUrl,
        notes
      ]);

  /// Create a copy of QualityInspection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QualityInspectionImplCopyWith<_$QualityInspectionImpl> get copyWith =>
      __$$QualityInspectionImplCopyWithImpl<_$QualityInspectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QualityInspectionImplToJson(
      this,
    );
  }
}

abstract class _QualityInspection implements QualityInspection {
  const factory _QualityInspection(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
      required final String inspectionNumber,
      @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
      final int? workOrderId,
      @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
      final String? inspectionType,
      @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
      final String? inspectionTypeDisplay,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? result,
      @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
      final String? resultDisplay,
      @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
      final String? workOrderNumber,
      @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
      final String? productName,
      @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
      final String? batchNo,
      @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
      final String? inspectorName,
      @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
      final DateTime? inspectionDate,
      @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
      final double? inspectionQuantity,
      @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
      final double? passedQuantity,
      @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
      final double? failedQuantity,
      @JsonKey(
          name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
      final String? defectiveRateFormatted,
      @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
      final String? inspectionStandard,
      @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
      final List<String> inspectionItems,
      @JsonKey(name: 'defects', fromJson: _stringListFromJson)
      final List<String> defects,
      @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
      final String? defectDescription,
      @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
      final String? disposition,
      @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
      final String? dispositionNotes,
      @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
      final String? attachmentUrl,
      @JsonKey(fromJson: _stringOrNullFromJson)
      final String? notes}) = _$QualityInspectionImpl;

  factory _QualityInspection.fromJson(Map<String, dynamic> json) =
      _$QualityInspectionImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)
  String get inspectionNumber;
  @override
  @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)
  int? get workOrderId;
  @override
  @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)
  String? get inspectionType;
  @override
  @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)
  String? get inspectionTypeDisplay;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get result;
  @override
  @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)
  String? get resultDisplay;
  @override
  @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)
  String? get workOrderNumber;
  @override
  @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)
  String? get productName;
  @override
  @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)
  String? get batchNo;
  @override
  @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)
  String? get inspectorName;
  @override
  @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)
  DateTime? get inspectionDate;
  @override
  @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)
  double? get inspectionQuantity;
  @override
  @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)
  double? get passedQuantity;
  @override
  @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)
  double? get failedQuantity;
  @override
  @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)
  String? get defectiveRateFormatted;
  @override
  @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)
  String? get inspectionStandard;
  @override
  @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)
  List<String> get inspectionItems;
  @override
  @JsonKey(name: 'defects', fromJson: _stringListFromJson)
  List<String> get defects;
  @override
  @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)
  String? get defectDescription;
  @override
  @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)
  String? get disposition;
  @override
  @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)
  String? get dispositionNotes;
  @override
  @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)
  String? get attachmentUrl;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;

  /// Create a copy of QualityInspection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QualityInspectionImplCopyWith<_$QualityInspectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
