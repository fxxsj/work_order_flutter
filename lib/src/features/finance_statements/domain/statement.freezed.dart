// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Statement _$StatementFromJson(Map<String, dynamic> json) {
  return _Statement.fromJson(json);
}

/// @nodoc
mixin _$Statement {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'statement_number',
      readValue: _readStatementNumber,
      fromJson: _stringOrNullFromJson)
  String? get statementNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
  String? get statementType => throw _privateConstructorUsedError;
  @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
  String? get statementTypeDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
  String? get partnerName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  String? get customerName => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'period_start',
      readValue: _readPeriodStart,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get periodStart => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'period_end',
      readValue: _readPeriodEnd,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get periodEnd => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'total_amount',
      readValue: _readTotalAmount,
      fromJson: _doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'debit_amount',
      readValue: _readDebitAmount,
      fromJson: _doubleOrNullFromJson)
  double? get debitAmount => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'credit_amount',
      readValue: _readCreditAmount,
      fromJson: _doubleOrNullFromJson)
  double? get creditAmount => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'closing_balance',
      readValue: _readClosingBalance,
      fromJson: _doubleOrNullFromJson)
  double? get closingBalance => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  String? get followUpText => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
  String? get confirmedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get confirmedAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'confirmation_notes',
      readValue: _readConfirmationNotes,
      fromJson: _stringOrNullFromJson)
  String? get confirmationNotes => throw _privateConstructorUsedError;

  /// Serializes this Statement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Statement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatementCopyWith<Statement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatementCopyWith<$Res> {
  factory $StatementCopyWith(Statement value, $Res Function(Statement) then) =
      _$StatementCopyWithImpl<$Res, Statement>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'statement_number',
          readValue: _readStatementNumber,
          fromJson: _stringOrNullFromJson)
      String? statementNumber,
      @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
      String? statementType,
      @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
      String? statementTypeDisplay,
      @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
      String? partnerName,
      @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'period_start', readValue: _readPeriodStart, fromJson: _dateTimeOrNullFromJson)
      DateTime? periodStart,
      @JsonKey(name: 'period_end', readValue: _readPeriodEnd, fromJson: _dateTimeOrNullFromJson)
      DateTime? periodEnd,
      @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'debit_amount', readValue: _readDebitAmount, fromJson: _doubleOrNullFromJson)
      double? debitAmount,
      @JsonKey(
          name: 'credit_amount',
          readValue: _readCreditAmount,
          fromJson: _doubleOrNullFromJson)
      double? creditAmount,
      @JsonKey(
          name: 'closing_balance',
          readValue: _readClosingBalance,
          fromJson: _doubleOrNullFromJson)
      double? closingBalance,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
      String? confirmedByName,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? confirmedAt,
      @JsonKey(
          name: 'confirmation_notes',
          readValue: _readConfirmationNotes,
          fromJson: _stringOrNullFromJson)
      String? confirmationNotes});
}

/// @nodoc
class _$StatementCopyWithImpl<$Res, $Val extends Statement>
    implements $StatementCopyWith<$Res> {
  _$StatementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Statement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statementNumber = freezed,
    Object? statementType = freezed,
    Object? statementTypeDisplay = freezed,
    Object? partnerName = freezed,
    Object? customerName = freezed,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? totalAmount = freezed,
    Object? debitAmount = freezed,
    Object? creditAmount = freezed,
    Object? closingBalance = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? confirmationNotes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      statementNumber: freezed == statementNumber
          ? _value.statementNumber
          : statementNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      statementType: freezed == statementType
          ? _value.statementType
          : statementType // ignore: cast_nullable_to_non_nullable
              as String?,
      statementTypeDisplay: freezed == statementTypeDisplay
          ? _value.statementTypeDisplay
          : statementTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      partnerName: freezed == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      debitAmount: freezed == debitAmount
          ? _value.debitAmount
          : debitAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      creditAmount: freezed == creditAmount
          ? _value.creditAmount
          : creditAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      closingBalance: freezed == closingBalance
          ? _value.closingBalance
          : closingBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpText: freezed == followUpText
          ? _value.followUpText
          : followUpText // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedByName: freezed == confirmedByName
          ? _value.confirmedByName
          : confirmedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmationNotes: freezed == confirmationNotes
          ? _value.confirmationNotes
          : confirmationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatementImplCopyWith<$Res>
    implements $StatementCopyWith<$Res> {
  factory _$$StatementImplCopyWith(
          _$StatementImpl value, $Res Function(_$StatementImpl) then) =
      __$$StatementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(
          name: 'statement_number',
          readValue: _readStatementNumber,
          fromJson: _stringOrNullFromJson)
      String? statementNumber,
      @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
      String? statementType,
      @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
      String? statementTypeDisplay,
      @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
      String? partnerName,
      @JsonKey(name: 'customer_name', readValue: _readCustomerName, fromJson: _stringOrNullFromJson)
      String? customerName,
      @JsonKey(name: 'period_start', readValue: _readPeriodStart, fromJson: _dateTimeOrNullFromJson)
      DateTime? periodStart,
      @JsonKey(name: 'period_end', readValue: _readPeriodEnd, fromJson: _dateTimeOrNullFromJson)
      DateTime? periodEnd,
      @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)
      double? totalAmount,
      @JsonKey(name: 'debit_amount', readValue: _readDebitAmount, fromJson: _doubleOrNullFromJson)
      double? debitAmount,
      @JsonKey(
          name: 'credit_amount',
          readValue: _readCreditAmount,
          fromJson: _doubleOrNullFromJson)
      double? creditAmount,
      @JsonKey(
          name: 'closing_balance',
          readValue: _readClosingBalance,
          fromJson: _doubleOrNullFromJson)
      double? closingBalance,
      @JsonKey(fromJson: _stringOrNullFromJson) String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      String? followUpText,
      @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
      String? confirmedByName,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? confirmedAt,
      @JsonKey(
          name: 'confirmation_notes',
          readValue: _readConfirmationNotes,
          fromJson: _stringOrNullFromJson)
      String? confirmationNotes});
}

/// @nodoc
class __$$StatementImplCopyWithImpl<$Res>
    extends _$StatementCopyWithImpl<$Res, _$StatementImpl>
    implements _$$StatementImplCopyWith<$Res> {
  __$$StatementImplCopyWithImpl(
      _$StatementImpl _value, $Res Function(_$StatementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Statement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? statementNumber = freezed,
    Object? statementType = freezed,
    Object? statementTypeDisplay = freezed,
    Object? partnerName = freezed,
    Object? customerName = freezed,
    Object? periodStart = freezed,
    Object? periodEnd = freezed,
    Object? totalAmount = freezed,
    Object? debitAmount = freezed,
    Object? creditAmount = freezed,
    Object? closingBalance = freezed,
    Object? status = freezed,
    Object? statusDisplay = freezed,
    Object? followUpText = freezed,
    Object? confirmedByName = freezed,
    Object? confirmedAt = freezed,
    Object? confirmationNotes = freezed,
  }) {
    return _then(_$StatementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      statementNumber: freezed == statementNumber
          ? _value.statementNumber
          : statementNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      statementType: freezed == statementType
          ? _value.statementType
          : statementType // ignore: cast_nullable_to_non_nullable
              as String?,
      statementTypeDisplay: freezed == statementTypeDisplay
          ? _value.statementTypeDisplay
          : statementTypeDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      partnerName: freezed == partnerName
          ? _value.partnerName
          : partnerName // ignore: cast_nullable_to_non_nullable
              as String?,
      customerName: freezed == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String?,
      periodStart: freezed == periodStart
          ? _value.periodStart
          : periodStart // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      periodEnd: freezed == periodEnd
          ? _value.periodEnd
          : periodEnd // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      debitAmount: freezed == debitAmount
          ? _value.debitAmount
          : debitAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      creditAmount: freezed == creditAmount
          ? _value.creditAmount
          : creditAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      closingBalance: freezed == closingBalance
          ? _value.closingBalance
          : closingBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      statusDisplay: freezed == statusDisplay
          ? _value.statusDisplay
          : statusDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      followUpText: freezed == followUpText
          ? _value.followUpText
          : followUpText // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedByName: freezed == confirmedByName
          ? _value.confirmedByName
          : confirmedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confirmationNotes: freezed == confirmationNotes
          ? _value.confirmationNotes
          : confirmationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatementImpl implements _Statement {
  const _$StatementImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(
          name: 'statement_number',
          readValue: _readStatementNumber,
          fromJson: _stringOrNullFromJson)
      this.statementNumber,
      @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
      this.statementType,
      @JsonKey(
          name: 'statement_type_display', fromJson: _stringOrNullFromJson)
      this.statementTypeDisplay,
      @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
      this.partnerName,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      this.customerName,
      @JsonKey(
          name: 'period_start',
          readValue: _readPeriodStart,
          fromJson: _dateTimeOrNullFromJson)
      this.periodStart,
      @JsonKey(
          name: 'period_end',
          readValue: _readPeriodEnd,
          fromJson: _dateTimeOrNullFromJson)
      this.periodEnd,
      @JsonKey(
          name: 'total_amount',
          readValue: _readTotalAmount,
          fromJson: _doubleOrNullFromJson)
      this.totalAmount,
      @JsonKey(
          name: 'debit_amount',
          readValue: _readDebitAmount,
          fromJson: _doubleOrNullFromJson)
      this.debitAmount,
      @JsonKey(
          name: 'credit_amount',
          readValue: _readCreditAmount,
          fromJson: _doubleOrNullFromJson)
      this.creditAmount,
      @JsonKey(
          name: 'closing_balance',
          readValue: _readClosingBalance,
          fromJson: _doubleOrNullFromJson)
      this.closingBalance,
      @JsonKey(fromJson: _stringOrNullFromJson) this.status,
      @JsonKey(
          name: 'status_display', fromJson: _stringOrNullFromJson)
      this.statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      this.followUpText,
      @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
      this.confirmedByName,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
      this.confirmedAt,
      @JsonKey(
          name: 'confirmation_notes',
          readValue: _readConfirmationNotes,
          fromJson: _stringOrNullFromJson)
      this.confirmationNotes});

  factory _$StatementImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatementImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(
      name: 'statement_number',
      readValue: _readStatementNumber,
      fromJson: _stringOrNullFromJson)
  final String? statementNumber;
  @override
  @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
  final String? statementType;
  @override
  @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
  final String? statementTypeDisplay;
  @override
  @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
  final String? partnerName;
  @override
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  final String? customerName;
  @override
  @JsonKey(
      name: 'period_start',
      readValue: _readPeriodStart,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? periodStart;
  @override
  @JsonKey(
      name: 'period_end',
      readValue: _readPeriodEnd,
      fromJson: _dateTimeOrNullFromJson)
  final DateTime? periodEnd;
  @override
  @JsonKey(
      name: 'total_amount',
      readValue: _readTotalAmount,
      fromJson: _doubleOrNullFromJson)
  final double? totalAmount;
  @override
  @JsonKey(
      name: 'debit_amount',
      readValue: _readDebitAmount,
      fromJson: _doubleOrNullFromJson)
  final double? debitAmount;
  @override
  @JsonKey(
      name: 'credit_amount',
      readValue: _readCreditAmount,
      fromJson: _doubleOrNullFromJson)
  final double? creditAmount;
  @override
  @JsonKey(
      name: 'closing_balance',
      readValue: _readClosingBalance,
      fromJson: _doubleOrNullFromJson)
  final double? closingBalance;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  final String? statusDisplay;
  @override
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  final String? followUpText;
  @override
  @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
  final String? confirmedByName;
  @override
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? confirmedAt;
  @override
  @JsonKey(
      name: 'confirmation_notes',
      readValue: _readConfirmationNotes,
      fromJson: _stringOrNullFromJson)
  final String? confirmationNotes;

  @override
  String toString() {
    return 'Statement(id: $id, statementNumber: $statementNumber, statementType: $statementType, statementTypeDisplay: $statementTypeDisplay, partnerName: $partnerName, customerName: $customerName, periodStart: $periodStart, periodEnd: $periodEnd, totalAmount: $totalAmount, debitAmount: $debitAmount, creditAmount: $creditAmount, closingBalance: $closingBalance, status: $status, statusDisplay: $statusDisplay, followUpText: $followUpText, confirmedByName: $confirmedByName, confirmedAt: $confirmedAt, confirmationNotes: $confirmationNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.statementNumber, statementNumber) ||
                other.statementNumber == statementNumber) &&
            (identical(other.statementType, statementType) ||
                other.statementType == statementType) &&
            (identical(other.statementTypeDisplay, statementTypeDisplay) ||
                other.statementTypeDisplay == statementTypeDisplay) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.periodStart, periodStart) ||
                other.periodStart == periodStart) &&
            (identical(other.periodEnd, periodEnd) ||
                other.periodEnd == periodEnd) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.debitAmount, debitAmount) ||
                other.debitAmount == debitAmount) &&
            (identical(other.creditAmount, creditAmount) ||
                other.creditAmount == creditAmount) &&
            (identical(other.closingBalance, closingBalance) ||
                other.closingBalance == closingBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDisplay, statusDisplay) ||
                other.statusDisplay == statusDisplay) &&
            (identical(other.followUpText, followUpText) ||
                other.followUpText == followUpText) &&
            (identical(other.confirmedByName, confirmedByName) ||
                other.confirmedByName == confirmedByName) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.confirmationNotes, confirmationNotes) ||
                other.confirmationNotes == confirmationNotes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      statementNumber,
      statementType,
      statementTypeDisplay,
      partnerName,
      customerName,
      periodStart,
      periodEnd,
      totalAmount,
      debitAmount,
      creditAmount,
      closingBalance,
      status,
      statusDisplay,
      followUpText,
      confirmedByName,
      confirmedAt,
      confirmationNotes);

  /// Create a copy of Statement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatementImplCopyWith<_$StatementImpl> get copyWith =>
      __$$StatementImplCopyWithImpl<_$StatementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatementImplToJson(
      this,
    );
  }
}

abstract class _Statement implements Statement {
  const factory _Statement(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(
          name: 'statement_number',
          readValue: _readStatementNumber,
          fromJson: _stringOrNullFromJson)
      final String? statementNumber,
      @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
      final String? statementType,
      @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
      final String? statementTypeDisplay,
      @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
      final String? partnerName,
      @JsonKey(
          name: 'customer_name',
          readValue: _readCustomerName,
          fromJson: _stringOrNullFromJson)
      final String? customerName,
      @JsonKey(
          name: 'period_start',
          readValue: _readPeriodStart,
          fromJson: _dateTimeOrNullFromJson)
      final DateTime? periodStart,
      @JsonKey(name: 'period_end', readValue: _readPeriodEnd, fromJson: _dateTimeOrNullFromJson)
      final DateTime? periodEnd,
      @JsonKey(name: 'total_amount', readValue: _readTotalAmount, fromJson: _doubleOrNullFromJson)
      final double? totalAmount,
      @JsonKey(
          name: 'debit_amount',
          readValue: _readDebitAmount,
          fromJson: _doubleOrNullFromJson)
      final double? debitAmount,
      @JsonKey(
          name: 'credit_amount',
          readValue: _readCreditAmount,
          fromJson: _doubleOrNullFromJson)
      final double? creditAmount,
      @JsonKey(
          name: 'closing_balance',
          readValue: _readClosingBalance,
          fromJson: _doubleOrNullFromJson)
      final double? closingBalance,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? status,
      @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
      final String? statusDisplay,
      @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
      final String? followUpText,
      @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
      final String? confirmedByName,
      @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? confirmedAt,
      @JsonKey(
          name: 'confirmation_notes',
          readValue: _readConfirmationNotes,
          fromJson: _stringOrNullFromJson)
      final String? confirmationNotes}) = _$StatementImpl;

  factory _Statement.fromJson(Map<String, dynamic> json) =
      _$StatementImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(
      name: 'statement_number',
      readValue: _readStatementNumber,
      fromJson: _stringOrNullFromJson)
  String? get statementNumber;
  @override
  @JsonKey(name: 'statement_type', fromJson: _stringOrNullFromJson)
  String? get statementType;
  @override
  @JsonKey(name: 'statement_type_display', fromJson: _stringOrNullFromJson)
  String? get statementTypeDisplay;
  @override
  @JsonKey(name: 'partner_name', fromJson: _stringOrNullFromJson)
  String? get partnerName;
  @override
  @JsonKey(
      name: 'customer_name',
      readValue: _readCustomerName,
      fromJson: _stringOrNullFromJson)
  String? get customerName;
  @override
  @JsonKey(
      name: 'period_start',
      readValue: _readPeriodStart,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get periodStart;
  @override
  @JsonKey(
      name: 'period_end',
      readValue: _readPeriodEnd,
      fromJson: _dateTimeOrNullFromJson)
  DateTime? get periodEnd;
  @override
  @JsonKey(
      name: 'total_amount',
      readValue: _readTotalAmount,
      fromJson: _doubleOrNullFromJson)
  double? get totalAmount;
  @override
  @JsonKey(
      name: 'debit_amount',
      readValue: _readDebitAmount,
      fromJson: _doubleOrNullFromJson)
  double? get debitAmount;
  @override
  @JsonKey(
      name: 'credit_amount',
      readValue: _readCreditAmount,
      fromJson: _doubleOrNullFromJson)
  double? get creditAmount;
  @override
  @JsonKey(
      name: 'closing_balance',
      readValue: _readClosingBalance,
      fromJson: _doubleOrNullFromJson)
  double? get closingBalance;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get status;
  @override
  @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)
  String? get statusDisplay;
  @override
  @JsonKey(name: 'follow_up_text', fromJson: _stringOrNullFromJson)
  String? get followUpText;
  @override
  @JsonKey(name: 'confirmed_by_name', fromJson: _stringOrNullFromJson)
  String? get confirmedByName;
  @override
  @JsonKey(name: 'confirmed_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get confirmedAt;
  @override
  @JsonKey(
      name: 'confirmation_notes',
      readValue: _readConfirmationNotes,
      fromJson: _stringOrNullFromJson)
  String? get confirmationNotes;

  /// Create a copy of Statement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatementImplCopyWith<_$StatementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
