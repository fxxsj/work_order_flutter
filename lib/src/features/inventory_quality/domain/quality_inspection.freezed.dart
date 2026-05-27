// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quality_inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QualityInspection {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'inspection_number', fromJson: _stringFromJson) String get inspectionNumber;@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? get workOrderId;@JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson) String? get inspectionType;@JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson) String? get inspectionTypeDisplay;@JsonKey(fromJson: _stringOrNullFromJson) String? get result;@JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson) String? get resultDisplay;@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? get workOrderNumber;@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? get productName;@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? get batchNo;@JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson) String? get inspectorName;@JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson) DateTime? get inspectionDate;@JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson) double? get inspectionQuantity;@JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson) double? get passedQuantity;@JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson) double? get failedQuantity;@JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson) String? get defectiveRateFormatted;@JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson) String? get inspectionStandard;@JsonKey(name: 'inspection_items', fromJson: _stringListFromJson) List<String> get inspectionItems;@JsonKey(name: 'defects', fromJson: _stringListFromJson) List<String> get defects;@JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson) String? get defectDescription;@JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson) String? get disposition;@JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson) String? get dispositionNotes;@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? get attachmentUrl;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of QualityInspection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QualityInspectionCopyWith<QualityInspection> get copyWith => _$QualityInspectionCopyWithImpl<QualityInspection>(this as QualityInspection, _$identity);

  /// Serializes this QualityInspection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QualityInspection&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionNumber, inspectionNumber) || other.inspectionNumber == inspectionNumber)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.inspectionType, inspectionType) || other.inspectionType == inspectionType)&&(identical(other.inspectionTypeDisplay, inspectionTypeDisplay) || other.inspectionTypeDisplay == inspectionTypeDisplay)&&(identical(other.result, result) || other.result == result)&&(identical(other.resultDisplay, resultDisplay) || other.resultDisplay == resultDisplay)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.inspectorName, inspectorName) || other.inspectorName == inspectorName)&&(identical(other.inspectionDate, inspectionDate) || other.inspectionDate == inspectionDate)&&(identical(other.inspectionQuantity, inspectionQuantity) || other.inspectionQuantity == inspectionQuantity)&&(identical(other.passedQuantity, passedQuantity) || other.passedQuantity == passedQuantity)&&(identical(other.failedQuantity, failedQuantity) || other.failedQuantity == failedQuantity)&&(identical(other.defectiveRateFormatted, defectiveRateFormatted) || other.defectiveRateFormatted == defectiveRateFormatted)&&(identical(other.inspectionStandard, inspectionStandard) || other.inspectionStandard == inspectionStandard)&&const DeepCollectionEquality().equals(other.inspectionItems, inspectionItems)&&const DeepCollectionEquality().equals(other.defects, defects)&&(identical(other.defectDescription, defectDescription) || other.defectDescription == defectDescription)&&(identical(other.disposition, disposition) || other.disposition == disposition)&&(identical(other.dispositionNotes, dispositionNotes) || other.dispositionNotes == dispositionNotes)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,inspectionNumber,workOrderId,inspectionType,inspectionTypeDisplay,result,resultDisplay,customerName,workOrderNumber,productName,batchNo,inspectorName,inspectionDate,inspectionQuantity,passedQuantity,failedQuantity,defectiveRateFormatted,inspectionStandard,const DeepCollectionEquality().hash(inspectionItems),const DeepCollectionEquality().hash(defects),defectDescription,disposition,dispositionNotes,attachmentUrl,notes]);

@override
String toString() {
  return 'QualityInspection(id: $id, inspectionNumber: $inspectionNumber, workOrderId: $workOrderId, inspectionType: $inspectionType, inspectionTypeDisplay: $inspectionTypeDisplay, result: $result, resultDisplay: $resultDisplay, customerName: $customerName, workOrderNumber: $workOrderNumber, productName: $productName, batchNo: $batchNo, inspectorName: $inspectorName, inspectionDate: $inspectionDate, inspectionQuantity: $inspectionQuantity, passedQuantity: $passedQuantity, failedQuantity: $failedQuantity, defectiveRateFormatted: $defectiveRateFormatted, inspectionStandard: $inspectionStandard, inspectionItems: $inspectionItems, defects: $defects, defectDescription: $defectDescription, disposition: $disposition, dispositionNotes: $dispositionNotes, attachmentUrl: $attachmentUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $QualityInspectionCopyWith<$Res>  {
  factory $QualityInspectionCopyWith(QualityInspection value, $Res Function(QualityInspection) _then) = _$QualityInspectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'inspection_number', fromJson: _stringFromJson) String inspectionNumber,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson) String? inspectionType,@JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson) String? inspectionTypeDisplay,@JsonKey(fromJson: _stringOrNullFromJson) String? result,@JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson) String? resultDisplay,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,@JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson) String? inspectorName,@JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson) DateTime? inspectionDate,@JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson) double? inspectionQuantity,@JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson) double? passedQuantity,@JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson) double? failedQuantity,@JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson) String? defectiveRateFormatted,@JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson) String? inspectionStandard,@JsonKey(name: 'inspection_items', fromJson: _stringListFromJson) List<String> inspectionItems,@JsonKey(name: 'defects', fromJson: _stringListFromJson) List<String> defects,@JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson) String? defectDescription,@JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson) String? disposition,@JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson) String? dispositionNotes,@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? attachmentUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$QualityInspectionCopyWithImpl<$Res>
    implements $QualityInspectionCopyWith<$Res> {
  _$QualityInspectionCopyWithImpl(this._self, this._then);

  final QualityInspection _self;
  final $Res Function(QualityInspection) _then;

/// Create a copy of QualityInspection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inspectionNumber = null,Object? workOrderId = freezed,Object? inspectionType = freezed,Object? inspectionTypeDisplay = freezed,Object? result = freezed,Object? resultDisplay = freezed,Object? customerName = freezed,Object? workOrderNumber = freezed,Object? productName = freezed,Object? batchNo = freezed,Object? inspectorName = freezed,Object? inspectionDate = freezed,Object? inspectionQuantity = freezed,Object? passedQuantity = freezed,Object? failedQuantity = freezed,Object? defectiveRateFormatted = freezed,Object? inspectionStandard = freezed,Object? inspectionItems = null,Object? defects = null,Object? defectDescription = freezed,Object? disposition = freezed,Object? dispositionNotes = freezed,Object? attachmentUrl = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,inspectionNumber: null == inspectionNumber ? _self.inspectionNumber : inspectionNumber // ignore: cast_nullable_to_non_nullable
as String,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,inspectionType: freezed == inspectionType ? _self.inspectionType : inspectionType // ignore: cast_nullable_to_non_nullable
as String?,inspectionTypeDisplay: freezed == inspectionTypeDisplay ? _self.inspectionTypeDisplay : inspectionTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String?,resultDisplay: freezed == resultDisplay ? _self.resultDisplay : resultDisplay // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,inspectorName: freezed == inspectorName ? _self.inspectorName : inspectorName // ignore: cast_nullable_to_non_nullable
as String?,inspectionDate: freezed == inspectionDate ? _self.inspectionDate : inspectionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectionQuantity: freezed == inspectionQuantity ? _self.inspectionQuantity : inspectionQuantity // ignore: cast_nullable_to_non_nullable
as double?,passedQuantity: freezed == passedQuantity ? _self.passedQuantity : passedQuantity // ignore: cast_nullable_to_non_nullable
as double?,failedQuantity: freezed == failedQuantity ? _self.failedQuantity : failedQuantity // ignore: cast_nullable_to_non_nullable
as double?,defectiveRateFormatted: freezed == defectiveRateFormatted ? _self.defectiveRateFormatted : defectiveRateFormatted // ignore: cast_nullable_to_non_nullable
as String?,inspectionStandard: freezed == inspectionStandard ? _self.inspectionStandard : inspectionStandard // ignore: cast_nullable_to_non_nullable
as String?,inspectionItems: null == inspectionItems ? _self.inspectionItems : inspectionItems // ignore: cast_nullable_to_non_nullable
as List<String>,defects: null == defects ? _self.defects : defects // ignore: cast_nullable_to_non_nullable
as List<String>,defectDescription: freezed == defectDescription ? _self.defectDescription : defectDescription // ignore: cast_nullable_to_non_nullable
as String?,disposition: freezed == disposition ? _self.disposition : disposition // ignore: cast_nullable_to_non_nullable
as String?,dispositionNotes: freezed == dispositionNotes ? _self.dispositionNotes : dispositionNotes // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QualityInspection].
extension QualityInspectionPatterns on QualityInspection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QualityInspection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QualityInspection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QualityInspection value)  $default,){
final _that = this;
switch (_that) {
case _QualityInspection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QualityInspection value)?  $default,){
final _that = this;
switch (_that) {
case _QualityInspection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)  String inspectionNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)  String? inspectionType, @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)  String? inspectionTypeDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? result, @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)  String? resultDisplay, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)  String? inspectorName, @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)  DateTime? inspectionDate, @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)  double? inspectionQuantity, @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)  double? passedQuantity, @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)  double? failedQuantity, @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)  String? defectiveRateFormatted, @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)  String? inspectionStandard, @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)  List<String> inspectionItems, @JsonKey(name: 'defects', fromJson: _stringListFromJson)  List<String> defects, @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)  String? defectDescription, @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)  String? disposition, @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)  String? dispositionNotes, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QualityInspection() when $default != null:
return $default(_that.id,_that.inspectionNumber,_that.workOrderId,_that.inspectionType,_that.inspectionTypeDisplay,_that.result,_that.resultDisplay,_that.customerName,_that.workOrderNumber,_that.productName,_that.batchNo,_that.inspectorName,_that.inspectionDate,_that.inspectionQuantity,_that.passedQuantity,_that.failedQuantity,_that.defectiveRateFormatted,_that.inspectionStandard,_that.inspectionItems,_that.defects,_that.defectDescription,_that.disposition,_that.dispositionNotes,_that.attachmentUrl,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)  String inspectionNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)  String? inspectionType, @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)  String? inspectionTypeDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? result, @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)  String? resultDisplay, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)  String? inspectorName, @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)  DateTime? inspectionDate, @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)  double? inspectionQuantity, @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)  double? passedQuantity, @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)  double? failedQuantity, @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)  String? defectiveRateFormatted, @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)  String? inspectionStandard, @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)  List<String> inspectionItems, @JsonKey(name: 'defects', fromJson: _stringListFromJson)  List<String> defects, @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)  String? defectDescription, @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)  String? disposition, @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)  String? dispositionNotes, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _QualityInspection():
return $default(_that.id,_that.inspectionNumber,_that.workOrderId,_that.inspectionType,_that.inspectionTypeDisplay,_that.result,_that.resultDisplay,_that.customerName,_that.workOrderNumber,_that.productName,_that.batchNo,_that.inspectorName,_that.inspectionDate,_that.inspectionQuantity,_that.passedQuantity,_that.failedQuantity,_that.defectiveRateFormatted,_that.inspectionStandard,_that.inspectionItems,_that.defects,_that.defectDescription,_that.disposition,_that.dispositionNotes,_that.attachmentUrl,_that.notes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'inspection_number', fromJson: _stringFromJson)  String inspectionNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson)  int? workOrderId, @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson)  String? inspectionType, @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson)  String? inspectionTypeDisplay, @JsonKey(fromJson: _stringOrNullFromJson)  String? result, @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson)  String? resultDisplay, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson)  String? workOrderNumber, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson)  String? productName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson)  String? batchNo, @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson)  String? inspectorName, @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson)  DateTime? inspectionDate, @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson)  double? inspectionQuantity, @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson)  double? passedQuantity, @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson)  double? failedQuantity, @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson)  String? defectiveRateFormatted, @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson)  String? inspectionStandard, @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson)  List<String> inspectionItems, @JsonKey(name: 'defects', fromJson: _stringListFromJson)  List<String> defects, @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson)  String? defectDescription, @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson)  String? disposition, @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson)  String? dispositionNotes, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson)  String? attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _QualityInspection() when $default != null:
return $default(_that.id,_that.inspectionNumber,_that.workOrderId,_that.inspectionType,_that.inspectionTypeDisplay,_that.result,_that.resultDisplay,_that.customerName,_that.workOrderNumber,_that.productName,_that.batchNo,_that.inspectorName,_that.inspectionDate,_that.inspectionQuantity,_that.passedQuantity,_that.failedQuantity,_that.defectiveRateFormatted,_that.inspectionStandard,_that.inspectionItems,_that.defects,_that.defectDescription,_that.disposition,_that.dispositionNotes,_that.attachmentUrl,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QualityInspection implements QualityInspection {
  const _QualityInspection({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'inspection_number', fromJson: _stringFromJson) required this.inspectionNumber, @JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) this.workOrderId, @JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson) this.inspectionType, @JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson) this.inspectionTypeDisplay, @JsonKey(fromJson: _stringOrNullFromJson) this.result, @JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson) this.resultDisplay, @JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) this.workOrderNumber, @JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) this.productName, @JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) this.batchNo, @JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson) this.inspectorName, @JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson) this.inspectionDate, @JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson) this.inspectionQuantity, @JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson) this.passedQuantity, @JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson) this.failedQuantity, @JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson) this.defectiveRateFormatted, @JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson) this.inspectionStandard, @JsonKey(name: 'inspection_items', fromJson: _stringListFromJson) final  List<String> inspectionItems = const <String>[], @JsonKey(name: 'defects', fromJson: _stringListFromJson) final  List<String> defects = const <String>[], @JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson) this.defectDescription, @JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson) this.disposition, @JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson) this.dispositionNotes, @JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) this.attachmentUrl, @JsonKey(fromJson: _stringOrNullFromJson) this.notes}): _inspectionItems = inspectionItems,_defects = defects;
  factory _QualityInspection.fromJson(Map<String, dynamic> json) => _$QualityInspectionFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'inspection_number', fromJson: _stringFromJson) final  String inspectionNumber;
@override@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) final  int? workOrderId;
@override@JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson) final  String? inspectionType;
@override@JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson) final  String? inspectionTypeDisplay;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? result;
@override@JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson) final  String? resultDisplay;
@override@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) final  String? workOrderNumber;
@override@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) final  String? productName;
@override@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) final  String? batchNo;
@override@JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson) final  String? inspectorName;
@override@JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? inspectionDate;
@override@JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson) final  double? inspectionQuantity;
@override@JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson) final  double? passedQuantity;
@override@JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson) final  double? failedQuantity;
@override@JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson) final  String? defectiveRateFormatted;
@override@JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson) final  String? inspectionStandard;
 final  List<String> _inspectionItems;
@override@JsonKey(name: 'inspection_items', fromJson: _stringListFromJson) List<String> get inspectionItems {
  if (_inspectionItems is EqualUnmodifiableListView) return _inspectionItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inspectionItems);
}

 final  List<String> _defects;
@override@JsonKey(name: 'defects', fromJson: _stringListFromJson) List<String> get defects {
  if (_defects is EqualUnmodifiableListView) return _defects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defects);
}

@override@JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson) final  String? defectDescription;
@override@JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson) final  String? disposition;
@override@JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson) final  String? dispositionNotes;
@override@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) final  String? attachmentUrl;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of QualityInspection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QualityInspectionCopyWith<_QualityInspection> get copyWith => __$QualityInspectionCopyWithImpl<_QualityInspection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QualityInspectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QualityInspection&&(identical(other.id, id) || other.id == id)&&(identical(other.inspectionNumber, inspectionNumber) || other.inspectionNumber == inspectionNumber)&&(identical(other.workOrderId, workOrderId) || other.workOrderId == workOrderId)&&(identical(other.inspectionType, inspectionType) || other.inspectionType == inspectionType)&&(identical(other.inspectionTypeDisplay, inspectionTypeDisplay) || other.inspectionTypeDisplay == inspectionTypeDisplay)&&(identical(other.result, result) || other.result == result)&&(identical(other.resultDisplay, resultDisplay) || other.resultDisplay == resultDisplay)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.workOrderNumber, workOrderNumber) || other.workOrderNumber == workOrderNumber)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.inspectorName, inspectorName) || other.inspectorName == inspectorName)&&(identical(other.inspectionDate, inspectionDate) || other.inspectionDate == inspectionDate)&&(identical(other.inspectionQuantity, inspectionQuantity) || other.inspectionQuantity == inspectionQuantity)&&(identical(other.passedQuantity, passedQuantity) || other.passedQuantity == passedQuantity)&&(identical(other.failedQuantity, failedQuantity) || other.failedQuantity == failedQuantity)&&(identical(other.defectiveRateFormatted, defectiveRateFormatted) || other.defectiveRateFormatted == defectiveRateFormatted)&&(identical(other.inspectionStandard, inspectionStandard) || other.inspectionStandard == inspectionStandard)&&const DeepCollectionEquality().equals(other._inspectionItems, _inspectionItems)&&const DeepCollectionEquality().equals(other._defects, _defects)&&(identical(other.defectDescription, defectDescription) || other.defectDescription == defectDescription)&&(identical(other.disposition, disposition) || other.disposition == disposition)&&(identical(other.dispositionNotes, dispositionNotes) || other.dispositionNotes == dispositionNotes)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,inspectionNumber,workOrderId,inspectionType,inspectionTypeDisplay,result,resultDisplay,customerName,workOrderNumber,productName,batchNo,inspectorName,inspectionDate,inspectionQuantity,passedQuantity,failedQuantity,defectiveRateFormatted,inspectionStandard,const DeepCollectionEquality().hash(_inspectionItems),const DeepCollectionEquality().hash(_defects),defectDescription,disposition,dispositionNotes,attachmentUrl,notes]);

@override
String toString() {
  return 'QualityInspection(id: $id, inspectionNumber: $inspectionNumber, workOrderId: $workOrderId, inspectionType: $inspectionType, inspectionTypeDisplay: $inspectionTypeDisplay, result: $result, resultDisplay: $resultDisplay, customerName: $customerName, workOrderNumber: $workOrderNumber, productName: $productName, batchNo: $batchNo, inspectorName: $inspectorName, inspectionDate: $inspectionDate, inspectionQuantity: $inspectionQuantity, passedQuantity: $passedQuantity, failedQuantity: $failedQuantity, defectiveRateFormatted: $defectiveRateFormatted, inspectionStandard: $inspectionStandard, inspectionItems: $inspectionItems, defects: $defects, defectDescription: $defectDescription, disposition: $disposition, dispositionNotes: $dispositionNotes, attachmentUrl: $attachmentUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$QualityInspectionCopyWith<$Res> implements $QualityInspectionCopyWith<$Res> {
  factory _$QualityInspectionCopyWith(_QualityInspection value, $Res Function(_QualityInspection) _then) = __$QualityInspectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'inspection_number', fromJson: _stringFromJson) String inspectionNumber,@JsonKey(name: 'work_order', fromJson: _intOrNullFromJson) int? workOrderId,@JsonKey(name: 'inspection_type', fromJson: _stringOrNullFromJson) String? inspectionType,@JsonKey(name: 'inspection_type_display', fromJson: _stringOrNullFromJson) String? inspectionTypeDisplay,@JsonKey(fromJson: _stringOrNullFromJson) String? result,@JsonKey(name: 'result_display', fromJson: _stringOrNullFromJson) String? resultDisplay,@JsonKey(name: 'customer_name', fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'work_order_number', fromJson: _stringOrNullFromJson) String? workOrderNumber,@JsonKey(name: 'product_name', fromJson: _stringOrNullFromJson) String? productName,@JsonKey(name: 'batch_no', fromJson: _stringOrNullFromJson) String? batchNo,@JsonKey(name: 'inspector_name', fromJson: _stringOrNullFromJson) String? inspectorName,@JsonKey(name: 'inspection_date', fromJson: _dateTimeOrNullFromJson) DateTime? inspectionDate,@JsonKey(name: 'inspection_quantity', fromJson: _doubleOrNullFromJson) double? inspectionQuantity,@JsonKey(name: 'passed_quantity', fromJson: _doubleOrNullFromJson) double? passedQuantity,@JsonKey(name: 'failed_quantity', fromJson: _doubleOrNullFromJson) double? failedQuantity,@JsonKey(name: 'defective_rate_formatted', fromJson: _stringOrNullFromJson) String? defectiveRateFormatted,@JsonKey(name: 'inspection_standard', fromJson: _stringOrNullFromJson) String? inspectionStandard,@JsonKey(name: 'inspection_items', fromJson: _stringListFromJson) List<String> inspectionItems,@JsonKey(name: 'defects', fromJson: _stringListFromJson) List<String> defects,@JsonKey(name: 'defect_description', fromJson: _stringOrNullFromJson) String? defectDescription,@JsonKey(name: 'disposition', fromJson: _stringOrNullFromJson) String? disposition,@JsonKey(name: 'disposition_notes', fromJson: _stringOrNullFromJson) String? dispositionNotes,@JsonKey(name: 'attachment', fromJson: _stringOrNullFromJson) String? attachmentUrl,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$QualityInspectionCopyWithImpl<$Res>
    implements _$QualityInspectionCopyWith<$Res> {
  __$QualityInspectionCopyWithImpl(this._self, this._then);

  final _QualityInspection _self;
  final $Res Function(_QualityInspection) _then;

/// Create a copy of QualityInspection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inspectionNumber = null,Object? workOrderId = freezed,Object? inspectionType = freezed,Object? inspectionTypeDisplay = freezed,Object? result = freezed,Object? resultDisplay = freezed,Object? customerName = freezed,Object? workOrderNumber = freezed,Object? productName = freezed,Object? batchNo = freezed,Object? inspectorName = freezed,Object? inspectionDate = freezed,Object? inspectionQuantity = freezed,Object? passedQuantity = freezed,Object? failedQuantity = freezed,Object? defectiveRateFormatted = freezed,Object? inspectionStandard = freezed,Object? inspectionItems = null,Object? defects = null,Object? defectDescription = freezed,Object? disposition = freezed,Object? dispositionNotes = freezed,Object? attachmentUrl = freezed,Object? notes = freezed,}) {
  return _then(_QualityInspection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,inspectionNumber: null == inspectionNumber ? _self.inspectionNumber : inspectionNumber // ignore: cast_nullable_to_non_nullable
as String,workOrderId: freezed == workOrderId ? _self.workOrderId : workOrderId // ignore: cast_nullable_to_non_nullable
as int?,inspectionType: freezed == inspectionType ? _self.inspectionType : inspectionType // ignore: cast_nullable_to_non_nullable
as String?,inspectionTypeDisplay: freezed == inspectionTypeDisplay ? _self.inspectionTypeDisplay : inspectionTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as String?,resultDisplay: freezed == resultDisplay ? _self.resultDisplay : resultDisplay // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,workOrderNumber: freezed == workOrderNumber ? _self.workOrderNumber : workOrderNumber // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,inspectorName: freezed == inspectorName ? _self.inspectorName : inspectorName // ignore: cast_nullable_to_non_nullable
as String?,inspectionDate: freezed == inspectionDate ? _self.inspectionDate : inspectionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,inspectionQuantity: freezed == inspectionQuantity ? _self.inspectionQuantity : inspectionQuantity // ignore: cast_nullable_to_non_nullable
as double?,passedQuantity: freezed == passedQuantity ? _self.passedQuantity : passedQuantity // ignore: cast_nullable_to_non_nullable
as double?,failedQuantity: freezed == failedQuantity ? _self.failedQuantity : failedQuantity // ignore: cast_nullable_to_non_nullable
as double?,defectiveRateFormatted: freezed == defectiveRateFormatted ? _self.defectiveRateFormatted : defectiveRateFormatted // ignore: cast_nullable_to_non_nullable
as String?,inspectionStandard: freezed == inspectionStandard ? _self.inspectionStandard : inspectionStandard // ignore: cast_nullable_to_non_nullable
as String?,inspectionItems: null == inspectionItems ? _self._inspectionItems : inspectionItems // ignore: cast_nullable_to_non_nullable
as List<String>,defects: null == defects ? _self._defects : defects // ignore: cast_nullable_to_non_nullable
as List<String>,defectDescription: freezed == defectDescription ? _self.defectDescription : defectDescription // ignore: cast_nullable_to_non_nullable
as String?,disposition: freezed == disposition ? _self.disposition : disposition // ignore: cast_nullable_to_non_nullable
as String?,dispositionNotes: freezed == dispositionNotes ? _self.dispositionNotes : dispositionNotes // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
