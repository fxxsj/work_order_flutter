// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLog {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson) String? get actionType;@JsonKey(fromJson: _stringOrNullFromJson) String? get username;@JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson) String? get contentTypeName;@JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson) String? get objectRepr;@JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson) String? get changedFields;@JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson) String? get ipAddress;@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? get createdAt;
/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogCopyWith<AuditLog> get copyWith => _$AuditLogCopyWithImpl<AuditLog>(this as AuditLog, _$identity);

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.username, username) || other.username == username)&&(identical(other.contentTypeName, contentTypeName) || other.contentTypeName == contentTypeName)&&(identical(other.objectRepr, objectRepr) || other.objectRepr == objectRepr)&&(identical(other.changedFields, changedFields) || other.changedFields == changedFields)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionType,username,contentTypeName,objectRepr,changedFields,ipAddress,createdAt);

@override
String toString() {
  return 'AuditLog(id: $id, actionType: $actionType, username: $username, contentTypeName: $contentTypeName, objectRepr: $objectRepr, changedFields: $changedFields, ipAddress: $ipAddress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AuditLogCopyWith<$Res>  {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) _then) = _$AuditLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson) String? actionType,@JsonKey(fromJson: _stringOrNullFromJson) String? username,@JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson) String? contentTypeName,@JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson) String? objectRepr,@JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson) String? changedFields,@JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson) String? ipAddress,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$AuditLogCopyWithImpl<$Res>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._self, this._then);

  final AuditLog _self;
  final $Res Function(AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? actionType = freezed,Object? username = freezed,Object? contentTypeName = freezed,Object? objectRepr = freezed,Object? changedFields = freezed,Object? ipAddress = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,contentTypeName: freezed == contentTypeName ? _self.contentTypeName : contentTypeName // ignore: cast_nullable_to_non_nullable
as String?,objectRepr: freezed == objectRepr ? _self.objectRepr : objectRepr // ignore: cast_nullable_to_non_nullable
as String?,changedFields: freezed == changedFields ? _self.changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLog].
extension AuditLogPatterns on AuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)  String? actionType, @JsonKey(fromJson: _stringOrNullFromJson)  String? username, @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)  String? contentTypeName, @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)  String? objectRepr, @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)  String? changedFields, @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)  String? ipAddress, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.actionType,_that.username,_that.contentTypeName,_that.objectRepr,_that.changedFields,_that.ipAddress,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)  String? actionType, @JsonKey(fromJson: _stringOrNullFromJson)  String? username, @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)  String? contentTypeName, @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)  String? objectRepr, @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)  String? changedFields, @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)  String? ipAddress, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AuditLog():
return $default(_that.id,_that.actionType,_that.username,_that.contentTypeName,_that.objectRepr,_that.changedFields,_that.ipAddress,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson)  String? actionType, @JsonKey(fromJson: _stringOrNullFromJson)  String? username, @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson)  String? contentTypeName, @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson)  String? objectRepr, @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson)  String? changedFields, @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson)  String? ipAddress, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.actionType,_that.username,_that.contentTypeName,_that.objectRepr,_that.changedFields,_that.ipAddress,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLog implements AuditLog {
  const _AuditLog({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson) this.actionType, @JsonKey(fromJson: _stringOrNullFromJson) this.username, @JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson) this.contentTypeName, @JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson) this.objectRepr, @JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson) this.changedFields, @JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson) this.ipAddress, @JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) this.createdAt});
  factory _AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson) final  String? actionType;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? username;
@override@JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson) final  String? contentTypeName;
@override@JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson) final  String? objectRepr;
@override@JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson) final  String? changedFields;
@override@JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson) final  String? ipAddress;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) final  DateTime? createdAt;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogCopyWith<_AuditLog> get copyWith => __$AuditLogCopyWithImpl<_AuditLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.username, username) || other.username == username)&&(identical(other.contentTypeName, contentTypeName) || other.contentTypeName == contentTypeName)&&(identical(other.objectRepr, objectRepr) || other.objectRepr == objectRepr)&&(identical(other.changedFields, changedFields) || other.changedFields == changedFields)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actionType,username,contentTypeName,objectRepr,changedFields,ipAddress,createdAt);

@override
String toString() {
  return 'AuditLog(id: $id, actionType: $actionType, username: $username, contentTypeName: $contentTypeName, objectRepr: $objectRepr, changedFields: $changedFields, ipAddress: $ipAddress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AuditLogCopyWith<$Res> implements $AuditLogCopyWith<$Res> {
  factory _$AuditLogCopyWith(_AuditLog value, $Res Function(_AuditLog) _then) = __$AuditLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(name: 'action_type', fromJson: _stringOrNullFromJson) String? actionType,@JsonKey(fromJson: _stringOrNullFromJson) String? username,@JsonKey(name: 'content_type_name', fromJson: _stringOrNullFromJson) String? contentTypeName,@JsonKey(name: 'object_repr', fromJson: _stringOrNullFromJson) String? objectRepr,@JsonKey(name: 'changed_fields', fromJson: _stringOrNullFromJson) String? changedFields,@JsonKey(name: 'ip_address', fromJson: _stringOrNullFromJson) String? ipAddress,@JsonKey(name: 'created_at', fromJson: _dateTimeOrNullFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$AuditLogCopyWithImpl<$Res>
    implements _$AuditLogCopyWith<$Res> {
  __$AuditLogCopyWithImpl(this._self, this._then);

  final _AuditLog _self;
  final $Res Function(_AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? actionType = freezed,Object? username = freezed,Object? contentTypeName = freezed,Object? objectRepr = freezed,Object? changedFields = freezed,Object? ipAddress = freezed,Object? createdAt = freezed,}) {
  return _then(_AuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,actionType: freezed == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,contentTypeName: freezed == contentTypeName ? _self.contentTypeName : contentTypeName // ignore: cast_nullable_to_non_nullable
as String?,objectRepr: freezed == objectRepr ? _self.objectRepr : objectRepr // ignore: cast_nullable_to_non_nullable
as String?,changedFields: freezed == changedFields ? _self.changedFields : changedFields // ignore: cast_nullable_to_non_nullable
as String?,ipAddress: freezed == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
