// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringFromJson)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get contactPerson => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _intOrNullFromJson)
  int? get salespersonId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get salespersonName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String name,
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
      DateTime? updatedAt});
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contactPerson = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? salespersonId = freezed,
    Object? salespersonName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      salespersonId: freezed == salespersonId
          ? _value.salespersonId
          : salespersonId // ignore: cast_nullable_to_non_nullable
              as int?,
      salespersonName: freezed == salespersonName
          ? _value.salespersonName
          : salespersonName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
          _$CustomerImpl value, $Res Function(_$CustomerImpl) then) =
      __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(fromJson: _stringFromJson) String name,
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
      DateTime? updatedAt});
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
      _$CustomerImpl _value, $Res Function(_$CustomerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? contactPerson = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? salespersonId = freezed,
    Object? salespersonName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CustomerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactPerson: freezed == contactPerson
          ? _value.contactPerson
          : contactPerson // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      salespersonId: freezed == salespersonId
          ? _value.salespersonId
          : salespersonId // ignore: cast_nullable_to_non_nullable
              as int?,
      salespersonName: freezed == salespersonName
          ? _value.salespersonName
          : salespersonName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(fromJson: _stringFromJson) required this.name,
      @JsonKey(fromJson: _stringOrNullFromJson) this.contactPerson,
      @JsonKey(fromJson: _stringOrNullFromJson) this.phone,
      @JsonKey(fromJson: _stringOrNullFromJson) this.email,
      @JsonKey(fromJson: _stringOrNullFromJson) this.address,
      @JsonKey(fromJson: _stringOrNullFromJson) this.notes,
      @JsonKey(fromJson: _intOrNullFromJson) this.salespersonId,
      @JsonKey(fromJson: _stringOrNullFromJson) this.salespersonName,
      @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
      this.createdAt,
      @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
      this.updatedAt});

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  final String name;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? contactPerson;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? phone;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? email;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? address;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? notes;
  @override
  @JsonKey(fromJson: _intOrNullFromJson)
  final int? salespersonId;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? salespersonName;
  @override
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, address: $address, notes: $notes, salespersonId: $salespersonId, salespersonName: $salespersonName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.salespersonId, salespersonId) ||
                other.salespersonId == salespersonId) &&
            (identical(other.salespersonName, salespersonName) ||
                other.salespersonName == salespersonName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      contactPerson,
      phone,
      email,
      address,
      notes,
      salespersonId,
      salespersonName,
      createdAt,
      updatedAt);

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(
      this,
    );
  }
}

abstract class _Customer implements Customer {
  const factory _Customer(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(fromJson: _stringFromJson) required final String name,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? contactPerson,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? phone,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? email,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? address,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? notes,
      @JsonKey(fromJson: _intOrNullFromJson) final int? salespersonId,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? salespersonName,
      @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
      final DateTime? updatedAt}) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(fromJson: _stringFromJson)
  String get name;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get contactPerson;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get phone;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get email;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get address;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get notes;
  @override
  @JsonKey(fromJson: _intOrNullFromJson)
  int? get salespersonId;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get salespersonName;
  @override
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)
  DateTime? get updatedAt;

  /// Create a copy of Customer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
