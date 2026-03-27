// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) {
  return _AuditLog.fromJson(json);
}

/// @nodoc
mixin _$AuditLog {
  @JsonKey(fromJson: _intFromJson)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
  String? get actionType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
  String? get contentTypeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
  String? get objectRepr => throw _privateConstructorUsedError;
  @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
  String? get changedFields => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
  String? get ipAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogCopyWith<AuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogCopyWith<$Res> {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) then) =
      _$AuditLogCopyWithImpl<$Res, AuditLog>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
      String? actionType,
      @JsonKey(fromJson: _stringOrNullFromJson) String? username,
      @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
      String? contentTypeName,
      @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
      String? objectRepr,
      @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
      String? changedFields,
      @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
      String? ipAddress,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt});
}

/// @nodoc
class _$AuditLogCopyWithImpl<$Res, $Val extends AuditLog>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actionType = freezed,
    Object? username = freezed,
    Object? contentTypeName = freezed,
    Object? objectRepr = freezed,
    Object? changedFields = freezed,
    Object? ipAddress = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      contentTypeName: freezed == contentTypeName
          ? _value.contentTypeName
          : contentTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      objectRepr: freezed == objectRepr
          ? _value.objectRepr
          : objectRepr // ignore: cast_nullable_to_non_nullable
              as String?,
      changedFields: freezed == changedFields
          ? _value.changedFields
          : changedFields // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogImplCopyWith<$Res>
    implements $AuditLogCopyWith<$Res> {
  factory _$$AuditLogImplCopyWith(
          _$AuditLogImpl value, $Res Function(_$AuditLogImpl) then) =
      __$$AuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intFromJson) int id,
      @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
      String? actionType,
      @JsonKey(fromJson: _stringOrNullFromJson) String? username,
      @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
      String? contentTypeName,
      @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
      String? objectRepr,
      @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
      String? changedFields,
      @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
      String? ipAddress,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      DateTime? createdAt});
}

/// @nodoc
class __$$AuditLogImplCopyWithImpl<$Res>
    extends _$AuditLogCopyWithImpl<$Res, _$AuditLogImpl>
    implements _$$AuditLogImplCopyWith<$Res> {
  __$$AuditLogImplCopyWithImpl(
      _$AuditLogImpl _value, $Res Function(_$AuditLogImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actionType = freezed,
    Object? username = freezed,
    Object? contentTypeName = freezed,
    Object? objectRepr = freezed,
    Object? changedFields = freezed,
    Object? ipAddress = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$AuditLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      actionType: freezed == actionType
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      contentTypeName: freezed == contentTypeName
          ? _value.contentTypeName
          : contentTypeName // ignore: cast_nullable_to_non_nullable
              as String?,
      objectRepr: freezed == objectRepr
          ? _value.objectRepr
          : objectRepr // ignore: cast_nullable_to_non_nullable
              as String?,
      changedFields: freezed == changedFields
          ? _value.changedFields
          : changedFields // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogImpl implements _AuditLog {
  const _$AuditLogImpl(
      {@JsonKey(fromJson: _intFromJson) required this.id,
      @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
      this.actionType,
      @JsonKey(fromJson: _stringOrNullFromJson) this.username,
      @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
      this.contentTypeName,
      @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
      this.objectRepr,
      @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
      this.changedFields,
      @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
      this.ipAddress,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      this.createdAt});

  factory _$AuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogImplFromJson(json);

  @override
  @JsonKey(fromJson: _intFromJson)
  final int id;
  @override
  @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
  final String? actionType;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  final String? username;
  @override
  @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
  final String? contentTypeName;
  @override
  @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
  final String? objectRepr;
  @override
  @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
  final String? changedFields;
  @override
  @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
  final String? ipAddress;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AuditLog(id: $id, actionType: $actionType, username: $username, contentTypeName: $contentTypeName, objectRepr: $objectRepr, changedFields: $changedFields, ipAddress: $ipAddress, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.contentTypeName, contentTypeName) ||
                other.contentTypeName == contentTypeName) &&
            (identical(other.objectRepr, objectRepr) ||
                other.objectRepr == objectRepr) &&
            (identical(other.changedFields, changedFields) ||
                other.changedFields == changedFields) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, actionType, username,
      contentTypeName, objectRepr, changedFields, ipAddress, createdAt);

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      __$$AuditLogImplCopyWithImpl<_$AuditLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogImplToJson(
      this,
    );
  }
}

abstract class _AuditLog implements AuditLog {
  const factory _AuditLog(
      {@JsonKey(fromJson: _intFromJson) required final int id,
      @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
      final String? actionType,
      @JsonKey(fromJson: _stringOrNullFromJson) final String? username,
      @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
      final String? contentTypeName,
      @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
      final String? objectRepr,
      @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
      final String? changedFields,
      @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
      final String? ipAddress,
      @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
      final DateTime? createdAt}) = _$AuditLogImpl;

  factory _AuditLog.fromJson(Map<String, dynamic> json) =
      _$AuditLogImpl.fromJson;

  @override
  @JsonKey(fromJson: _intFromJson)
  int get id;
  @override
  @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)
  String? get actionType;
  @override
  @JsonKey(fromJson: _stringOrNullFromJson)
  String? get username;
  @override
  @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)
  String? get contentTypeName;
  @override
  @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)
  String? get objectRepr;
  @override
  @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)
  String? get changedFields;
  @override
  @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)
  String? get ipAddress;
  @override
  @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)
  DateTime? get createdAt;

  /// Create a copy of AuditLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
