// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Statement {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson) String? get statementNumber;@JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson) String? get statementType;@JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson) String? get statementTypeDisplay;@JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson) String? get partnerName;@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? get customerName;@JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson) DateTime? get periodStart;@JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson) DateTime? get periodEnd;@JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson) double? get totalAmount;@JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson) double? get debitAmount;@JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson) double? get creditAmount;@JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson) double? get closingBalance;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? get followUpText;@JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson) String? get confirmedByName;@JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson) DateTime? get confirmedAt;@JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson) String? get confirmationNotes;
/// Create a copy of Statement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatementCopyWith<Statement> get copyWith => _$StatementCopyWithImpl<Statement>(this as Statement, _$identity);

  /// Serializes this Statement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Statement&&(identical(other.id, id) || other.id == id)&&(identical(other.statementNumber, statementNumber) || other.statementNumber == statementNumber)&&(identical(other.statementType, statementType) || other.statementType == statementType)&&(identical(other.statementTypeDisplay, statementTypeDisplay) || other.statementTypeDisplay == statementTypeDisplay)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.debitAmount, debitAmount) || other.debitAmount == debitAmount)&&(identical(other.creditAmount, creditAmount) || other.creditAmount == creditAmount)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.confirmedByName, confirmedByName) || other.confirmedByName == confirmedByName)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.confirmationNotes, confirmationNotes) || other.confirmationNotes == confirmationNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,statementNumber,statementType,statementTypeDisplay,partnerName,customerName,periodStart,periodEnd,totalAmount,debitAmount,creditAmount,closingBalance,status,statusDisplay,followUpText,confirmedByName,confirmedAt,confirmationNotes);

@override
String toString() {
  return 'Statement(id: $id, statementNumber: $statementNumber, statementType: $statementType, statementTypeDisplay: $statementTypeDisplay, partnerName: $partnerName, customerName: $customerName, periodStart: $periodStart, periodEnd: $periodEnd, totalAmount: $totalAmount, debitAmount: $debitAmount, creditAmount: $creditAmount, closingBalance: $closingBalance, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, confirmedByName: $confirmedByName, confirmedAt: $confirmedAt, confirmationNotes: $confirmationNotes)';
}


}

/// @nodoc
abstract mixin class $StatementCopyWith<$Res>  {
  factory $StatementCopyWith(Statement value, $Res Function(Statement) _then) = _$StatementCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson) String? statementNumber,@JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson) String? statementType,@JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson) String? statementTypeDisplay,@JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson) String? partnerName,@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson) DateTime? periodStart,@JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson) DateTime? periodEnd,@JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson) double? debitAmount,@JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson) double? creditAmount,@JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson) double? closingBalance,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson) String? confirmedByName,@JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson) DateTime? confirmedAt,@JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson) String? confirmationNotes
});




}
/// @nodoc
class _$StatementCopyWithImpl<$Res>
    implements $StatementCopyWith<$Res> {
  _$StatementCopyWithImpl(this._self, this._then);

  final Statement _self;
  final $Res Function(Statement) _then;

/// Create a copy of Statement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statementNumber = freezed,Object? statementType = freezed,Object? statementTypeDisplay = freezed,Object? partnerName = freezed,Object? customerName = freezed,Object? periodStart = freezed,Object? periodEnd = freezed,Object? totalAmount = freezed,Object? debitAmount = freezed,Object? creditAmount = freezed,Object? closingBalance = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? confirmedByName = freezed,Object? confirmedAt = freezed,Object? confirmationNotes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,statementNumber: freezed == statementNumber ? _self.statementNumber : statementNumber // ignore: cast_nullable_to_non_nullable
as String?,statementType: freezed == statementType ? _self.statementType : statementType // ignore: cast_nullable_to_non_nullable
as String?,statementTypeDisplay: freezed == statementTypeDisplay ? _self.statementTypeDisplay : statementTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,periodStart: freezed == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,periodEnd: freezed == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,debitAmount: freezed == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as double?,creditAmount: freezed == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as double?,closingBalance: freezed == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,confirmedByName: freezed == confirmedByName ? _self.confirmedByName : confirmedByName // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationNotes: freezed == confirmationNotes ? _self.confirmationNotes : confirmationNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Statement].
extension StatementPatterns on Statement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Statement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Statement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Statement value)  $default,){
final _that = this;
switch (_that) {
case _Statement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Statement value)?  $default,){
final _that = this;
switch (_that) {
case _Statement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson)  String? statementNumber, @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)  String? statementType, @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)  String? statementTypeDisplay, @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)  String? partnerName, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodStart, @JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodEnd, @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson)  double? debitAmount, @JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson)  double? creditAmount, @JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson)  double? closingBalance, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)  String? confirmedByName, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)  DateTime? confirmedAt, @JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson)  String? confirmationNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Statement() when $default != null:
return $default(_that.id,_that.statementNumber,_that.statementType,_that.statementTypeDisplay,_that.partnerName,_that.customerName,_that.periodStart,_that.periodEnd,_that.totalAmount,_that.debitAmount,_that.creditAmount,_that.closingBalance,_that.status,_that.statusDisplay,_that.followUpText,_that.confirmedByName,_that.confirmedAt,_that.confirmationNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson)  String? statementNumber, @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)  String? statementType, @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)  String? statementTypeDisplay, @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)  String? partnerName, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodStart, @JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodEnd, @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson)  double? debitAmount, @JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson)  double? creditAmount, @JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson)  double? closingBalance, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)  String? confirmedByName, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)  DateTime? confirmedAt, @JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson)  String? confirmationNotes)  $default,) {final _that = this;
switch (_that) {
case _Statement():
return $default(_that.id,_that.statementNumber,_that.statementType,_that.statementTypeDisplay,_that.partnerName,_that.customerName,_that.periodStart,_that.periodEnd,_that.totalAmount,_that.debitAmount,_that.creditAmount,_that.closingBalance,_that.status,_that.statusDisplay,_that.followUpText,_that.confirmedByName,_that.confirmedAt,_that.confirmationNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson)  String? statementNumber, @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)  String? statementType, @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)  String? statementTypeDisplay, @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)  String? partnerName, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)  String? customerName, @JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodStart, @JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson)  DateTime? periodEnd, @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)  double? totalAmount, @JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson)  double? debitAmount, @JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson)  double? creditAmount, @JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson)  double? closingBalance, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)  String? followUpText, @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)  String? confirmedByName, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)  DateTime? confirmedAt, @JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson)  String? confirmationNotes)?  $default,) {final _that = this;
switch (_that) {
case _Statement() when $default != null:
return $default(_that.id,_that.statementNumber,_that.statementType,_that.statementTypeDisplay,_that.partnerName,_that.customerName,_that.periodStart,_that.periodEnd,_that.totalAmount,_that.debitAmount,_that.creditAmount,_that.closingBalance,_that.status,_that.statusDisplay,_that.followUpText,_that.confirmedByName,_that.confirmedAt,_that.confirmationNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Statement implements Statement {
  const _Statement({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson) this.statementNumber, @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson) this.statementType, @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson) this.statementTypeDisplay, @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson) this.partnerName, @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) this.customerName, @JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson) this.periodStart, @JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson) this.periodEnd, @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson) this.totalAmount, @JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson) this.debitAmount, @JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson) this.creditAmount, @JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson) this.closingBalance, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) this.followUpText, @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson) this.confirmedByName, @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson) this.confirmedAt, @JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson) this.confirmationNotes});
  factory _Statement.fromJson(Map<String, dynamic> json) => _$StatementFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson) final  String? statementNumber;
@override@JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson) final  String? statementType;
@override@JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson) final  String? statementTypeDisplay;
@override@JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson) final  String? partnerName;
@override@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) final  String? customerName;
@override@JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? periodStart;
@override@JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson) final  DateTime? periodEnd;
@override@JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson) final  double? totalAmount;
@override@JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson) final  double? debitAmount;
@override@JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson) final  double? creditAmount;
@override@JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson) final  double? closingBalance;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) final  String? followUpText;
@override@JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson) final  String? confirmedByName;
@override@JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? confirmedAt;
@override@JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson) final  String? confirmationNotes;

/// Create a copy of Statement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatementCopyWith<_Statement> get copyWith => __$StatementCopyWithImpl<_Statement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Statement&&(identical(other.id, id) || other.id == id)&&(identical(other.statementNumber, statementNumber) || other.statementNumber == statementNumber)&&(identical(other.statementType, statementType) || other.statementType == statementType)&&(identical(other.statementTypeDisplay, statementTypeDisplay) || other.statementTypeDisplay == statementTypeDisplay)&&(identical(other.partnerName, partnerName) || other.partnerName == partnerName)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.debitAmount, debitAmount) || other.debitAmount == debitAmount)&&(identical(other.creditAmount, creditAmount) || other.creditAmount == creditAmount)&&(identical(other.closingBalance, closingBalance) || other.closingBalance == closingBalance)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.followUpText, followUpText) || other.followUpText == followUpText)&&(identical(other.confirmedByName, confirmedByName) || other.confirmedByName == confirmedByName)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.confirmationNotes, confirmationNotes) || other.confirmationNotes == confirmationNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,statementNumber,statementType,statementTypeDisplay,partnerName,customerName,periodStart,periodEnd,totalAmount,debitAmount,creditAmount,closingBalance,status,statusDisplay,followUpText,confirmedByName,confirmedAt,confirmationNotes);

@override
String toString() {
  return 'Statement(id: $id, statementNumber: $statementNumber, statementType: $statementType, statementTypeDisplay: $statementTypeDisplay, partnerName: $partnerName, customerName: $customerName, periodStart: $periodStart, periodEnd: $periodEnd, totalAmount: $totalAmount, debitAmount: $debitAmount, creditAmount: $creditAmount, closingBalance: $closingBalance, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, confirmedByName: $confirmedByName, confirmedAt: $confirmedAt, confirmationNotes: $confirmationNotes)';
}


}

/// @nodoc
abstract mixin class _$StatementCopyWith<$Res> implements $StatementCopyWith<$Res> {
  factory _$StatementCopyWith(_Statement value, $Res Function(_Statement) _then) = __$StatementCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'statement_number', readValue: _readStatementNumber, fromJson: _stringOrNullFromJson) String? statementNumber,@JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson) String? statementType,@JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson) String? statementTypeDisplay,@JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson) String? partnerName,@JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson) String? customerName,@JsonKey(name: 'start_date', fromJson: _dateTimeOrNullFromJson) DateTime? periodStart,@JsonKey(name: 'end_date', fromJson: _dateTimeOrNullFromJson) DateTime? periodEnd,@JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson) double? totalAmount,@JsonKey(name: 'total_debit', fromJson: _doubleOrNullFromJson) double? debitAmount,@JsonKey(name: 'total_credit', fromJson: _doubleOrNullFromJson) double? creditAmount,@JsonKey(name: 'closing_balance', readValue: _readClosingBalance, fromJson: _doubleOrNullFromJson) double? closingBalance,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson) String? followUpText,@JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson) String? confirmedByName,@JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson) DateTime? confirmedAt,@JsonKey(name: 'confirmation_notes', readValue: _readConfirmationNotes, fromJson: _stringOrNullFromJson) String? confirmationNotes
});




}
/// @nodoc
class __$StatementCopyWithImpl<$Res>
    implements _$StatementCopyWith<$Res> {
  __$StatementCopyWithImpl(this._self, this._then);

  final _Statement _self;
  final $Res Function(_Statement) _then;

/// Create a copy of Statement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statementNumber = freezed,Object? statementType = freezed,Object? statementTypeDisplay = freezed,Object? partnerName = freezed,Object? customerName = freezed,Object? periodStart = freezed,Object? periodEnd = freezed,Object? totalAmount = freezed,Object? debitAmount = freezed,Object? creditAmount = freezed,Object? closingBalance = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? followUpText = freezed,Object? confirmedByName = freezed,Object? confirmedAt = freezed,Object? confirmationNotes = freezed,}) {
  return _then(_Statement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,statementNumber: freezed == statementNumber ? _self.statementNumber : statementNumber // ignore: cast_nullable_to_non_nullable
as String?,statementType: freezed == statementType ? _self.statementType : statementType // ignore: cast_nullable_to_non_nullable
as String?,statementTypeDisplay: freezed == statementTypeDisplay ? _self.statementTypeDisplay : statementTypeDisplay // ignore: cast_nullable_to_non_nullable
as String?,partnerName: freezed == partnerName ? _self.partnerName : partnerName // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,periodStart: freezed == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,periodEnd: freezed == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double?,debitAmount: freezed == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as double?,creditAmount: freezed == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as double?,closingBalance: freezed == closingBalance ? _self.closingBalance : closingBalance // ignore: cast_nullable_to_non_nullable
as double?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,followUpText: freezed == followUpText ? _self.followUpText : followUpText // ignore: cast_nullable_to_non_nullable
as String?,confirmedByName: freezed == confirmedByName ? _self.confirmedByName : confirmedByName // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confirmationNotes: freezed == confirmationNotes ? _self.confirmationNotes : confirmationNotes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
