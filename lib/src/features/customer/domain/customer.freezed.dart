// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Customer {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get contactPerson;@JsonKey(fromJson: _stringOrNullFromJson) String? get phone;@JsonKey(fromJson: _stringOrNullFromJson) String? get email;@JsonKey(fromJson: _stringOrNullFromJson) String? get address;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;@JsonKey(fromJson: _intOrNullFromJson) int? get salespersonId;@JsonKey(fromJson: _stringOrNullFromJson) String? get salespersonName;@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? get createdAt;@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? get updatedAt;
/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerCopyWith<Customer> get copyWith => _$CustomerCopyWithImpl<Customer>(this as Customer, _$identity);

  /// Serializes this Customer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.salespersonId, salespersonId) || other.salespersonId == salespersonId)&&(identical(other.salespersonName, salespersonName) || other.salespersonName == salespersonName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,address,notes,salespersonId,salespersonName,createdAt,updatedAt);

@override
String toString() {
  return 'Customer(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, address: $address, notes: $notes, salespersonId: $salespersonId, salespersonName: $salespersonName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomerCopyWith<$Res>  {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) _then) = _$CustomerCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(fromJson: _stringOrNullFromJson) String? phone,@JsonKey(fromJson: _stringOrNullFromJson) String? email,@JsonKey(fromJson: _stringOrNullFromJson) String? address,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(fromJson: _intOrNullFromJson) int? salespersonId,@JsonKey(fromJson: _stringOrNullFromJson) String? salespersonName,@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? createdAt,@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CustomerCopyWithImpl<$Res>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._self, this._then);

  final Customer _self;
  final $Res Function(Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? salespersonId = freezed,Object? salespersonName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,salespersonId: freezed == salespersonId ? _self.salespersonId : salespersonId // ignore: cast_nullable_to_non_nullable
as int?,salespersonName: freezed == salespersonName ? _self.salespersonName : salespersonName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Customer].
extension CustomerPatterns on Customer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Customer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Customer value)  $default,){
final _that = this;
switch (_that) {
case _Customer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Customer value)?  $default,){
final _that = this;
switch (_that) {
case _Customer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(fromJson: _intOrNullFromJson)  int? salespersonId, @JsonKey(fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.address,_that.notes,_that.salespersonId,_that.salespersonName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(fromJson: _intOrNullFromJson)  int? salespersonId, @JsonKey(fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Customer():
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.address,_that.notes,_that.salespersonId,_that.salespersonName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes, @JsonKey(fromJson: _intOrNullFromJson)  int? salespersonId, @JsonKey(fromJson: _stringOrNullFromJson)  String? salespersonName, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? createdAt, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Customer() when $default != null:
return $default(_that.id,_that.name,_that.contactPerson,_that.phone,_that.email,_that.address,_that.notes,_that.salespersonId,_that.salespersonName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Customer implements Customer {
  const _Customer({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.contactPerson, @JsonKey(fromJson: _stringOrNullFromJson) this.phone, @JsonKey(fromJson: _stringOrNullFromJson) this.email, @JsonKey(fromJson: _stringOrNullFromJson) this.address, @JsonKey(fromJson: _stringOrNullFromJson) this.notes, @JsonKey(fromJson: _intOrNullFromJson) this.salespersonId, @JsonKey(fromJson: _stringOrNullFromJson) this.salespersonName, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) this.createdAt, @JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) this.updatedAt});
  factory _Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? contactPerson;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? phone;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? email;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? address;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;
@override@JsonKey(fromJson: _intOrNullFromJson) final  int? salespersonId;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? salespersonName;
@override@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) final  DateTime? updatedAt;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerCopyWith<_Customer> get copyWith => __$CustomerCopyWithImpl<_Customer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Customer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.salespersonId, salespersonId) || other.salespersonId == salespersonId)&&(identical(other.salespersonName, salespersonName) || other.salespersonName == salespersonName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactPerson,phone,email,address,notes,salespersonId,salespersonName,createdAt,updatedAt);

@override
String toString() {
  return 'Customer(id: $id, name: $name, contactPerson: $contactPerson, phone: $phone, email: $email, address: $address, notes: $notes, salespersonId: $salespersonId, salespersonName: $salespersonName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerCopyWith<$Res> implements $CustomerCopyWith<$Res> {
  factory _$CustomerCopyWith(_Customer value, $Res Function(_Customer) _then) = __$CustomerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(fromJson: _stringOrNullFromJson) String? phone,@JsonKey(fromJson: _stringOrNullFromJson) String? email,@JsonKey(fromJson: _stringOrNullFromJson) String? address,@JsonKey(fromJson: _stringOrNullFromJson) String? notes,@JsonKey(fromJson: _intOrNullFromJson) int? salespersonId,@JsonKey(fromJson: _stringOrNullFromJson) String? salespersonName,@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? createdAt,@JsonKey(fromJson: _dateTimeOrNullFromJson, toJson: _dateTimeOrNullToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CustomerCopyWithImpl<$Res>
    implements _$CustomerCopyWith<$Res> {
  __$CustomerCopyWithImpl(this._self, this._then);

  final _Customer _self;
  final $Res Function(_Customer) _then;

/// Create a copy of Customer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? notes = freezed,Object? salespersonId = freezed,Object? salespersonName = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Customer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,salespersonId: freezed == salespersonId ? _self.salespersonId : salespersonId // ignore: cast_nullable_to_non_nullable
as int?,salespersonName: freezed == salespersonName ? _self.salespersonName : salespersonName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
