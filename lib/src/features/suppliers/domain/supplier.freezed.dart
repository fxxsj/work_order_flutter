// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Supplier {

@JsonKey(fromJson: _intFromJson) int get id;@JsonKey(fromJson: _stringFromJson) String get name;@JsonKey(fromJson: _stringOrNullFromJson) String? get code;@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? get contactPerson;@JsonKey(fromJson: _stringOrNullFromJson) String? get phone;@JsonKey(fromJson: _stringOrNullFromJson) String? get email;@JsonKey(fromJson: _stringOrNullFromJson) String? get address;@JsonKey(fromJson: _stringOrNullFromJson) String? get status;@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? get statusDisplay;@JsonKey(name: 'material_count', fromJson: _intOrNullFromJson) int? get materialCount;@JsonKey(fromJson: _stringOrNullFromJson) String? get notes;
/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierCopyWith<Supplier> get copyWith => _$SupplierCopyWithImpl<Supplier>(this as Supplier, _$identity);

  /// Serializes this Supplier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.materialCount, materialCount) || other.materialCount == materialCount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,contactPerson,phone,email,address,status,statusDisplay,materialCount,notes);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, code: $code, contactPerson: $contactPerson, phone: $phone, email: $email, address: $address, status: $status, statusDisplay: $statusDisplay, materialCount: $materialCount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $SupplierCopyWith<$Res>  {
  factory $SupplierCopyWith(Supplier value, $Res Function(Supplier) _then) = _$SupplierCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? code,@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(fromJson: _stringOrNullFromJson) String? phone,@JsonKey(fromJson: _stringOrNullFromJson) String? email,@JsonKey(fromJson: _stringOrNullFromJson) String? address,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'material_count', fromJson: _intOrNullFromJson) int? materialCount,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class _$SupplierCopyWithImpl<$Res>
    implements $SupplierCopyWith<$Res> {
  _$SupplierCopyWithImpl(this._self, this._then);

  final Supplier _self;
  final $Res Function(Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? materialCount = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,materialCount: freezed == materialCount ? _self.materialCount : materialCount // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Supplier].
extension SupplierPatterns on Supplier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Supplier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Supplier value)  $default,){
final _that = this;
switch (_that) {
case _Supplier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Supplier value)?  $default,){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? code, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'material_count', fromJson: _intOrNullFromJson)  int? materialCount, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.contactPerson,_that.phone,_that.email,_that.address,_that.status,_that.statusDisplay,_that.materialCount,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? code, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'material_count', fromJson: _intOrNullFromJson)  int? materialCount, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Supplier():
return $default(_that.id,_that.name,_that.code,_that.contactPerson,_that.phone,_that.email,_that.address,_that.status,_that.statusDisplay,_that.materialCount,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _intFromJson)  int id, @JsonKey(fromJson: _stringFromJson)  String name, @JsonKey(fromJson: _stringOrNullFromJson)  String? code, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson)  String? contactPerson, @JsonKey(fromJson: _stringOrNullFromJson)  String? phone, @JsonKey(fromJson: _stringOrNullFromJson)  String? email, @JsonKey(fromJson: _stringOrNullFromJson)  String? address, @JsonKey(fromJson: _stringOrNullFromJson)  String? status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson)  String? statusDisplay, @JsonKey(name: 'material_count', fromJson: _intOrNullFromJson)  int? materialCount, @JsonKey(fromJson: _stringOrNullFromJson)  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.code,_that.contactPerson,_that.phone,_that.email,_that.address,_that.status,_that.statusDisplay,_that.materialCount,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Supplier implements Supplier {
  const _Supplier({@JsonKey(fromJson: _intFromJson) required this.id, @JsonKey(fromJson: _stringFromJson) required this.name, @JsonKey(fromJson: _stringOrNullFromJson) this.code, @JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) this.contactPerson, @JsonKey(fromJson: _stringOrNullFromJson) this.phone, @JsonKey(fromJson: _stringOrNullFromJson) this.email, @JsonKey(fromJson: _stringOrNullFromJson) this.address, @JsonKey(fromJson: _stringOrNullFromJson) this.status, @JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) this.statusDisplay, @JsonKey(name: 'material_count', fromJson: _intOrNullFromJson) this.materialCount, @JsonKey(fromJson: _stringOrNullFromJson) this.notes});
  factory _Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

@override@JsonKey(fromJson: _intFromJson) final  int id;
@override@JsonKey(fromJson: _stringFromJson) final  String name;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? code;
@override@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) final  String? contactPerson;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? phone;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? email;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? address;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? status;
@override@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) final  String? statusDisplay;
@override@JsonKey(name: 'material_count', fromJson: _intOrNullFromJson) final  int? materialCount;
@override@JsonKey(fromJson: _stringOrNullFromJson) final  String? notes;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierCopyWith<_Supplier> get copyWith => __$SupplierCopyWithImpl<_Supplier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.code, code) || other.code == code)&&(identical(other.contactPerson, contactPerson) || other.contactPerson == contactPerson)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusDisplay, statusDisplay) || other.statusDisplay == statusDisplay)&&(identical(other.materialCount, materialCount) || other.materialCount == materialCount)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,code,contactPerson,phone,email,address,status,statusDisplay,materialCount,notes);

@override
String toString() {
  return 'Supplier(id: $id, name: $name, code: $code, contactPerson: $contactPerson, phone: $phone, email: $email, address: $address, status: $status, statusDisplay: $statusDisplay, materialCount: $materialCount, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$SupplierCopyWith<$Res> implements $SupplierCopyWith<$Res> {
  factory _$SupplierCopyWith(_Supplier value, $Res Function(_Supplier) _then) = __$SupplierCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _intFromJson) int id,@JsonKey(fromJson: _stringFromJson) String name,@JsonKey(fromJson: _stringOrNullFromJson) String? code,@JsonKey(name: 'contact_person', fromJson: _stringOrNullFromJson) String? contactPerson,@JsonKey(fromJson: _stringOrNullFromJson) String? phone,@JsonKey(fromJson: _stringOrNullFromJson) String? email,@JsonKey(fromJson: _stringOrNullFromJson) String? address,@JsonKey(fromJson: _stringOrNullFromJson) String? status,@JsonKey(name: 'status_display', fromJson: _stringOrNullFromJson) String? statusDisplay,@JsonKey(name: 'material_count', fromJson: _intOrNullFromJson) int? materialCount,@JsonKey(fromJson: _stringOrNullFromJson) String? notes
});




}
/// @nodoc
class __$SupplierCopyWithImpl<$Res>
    implements _$SupplierCopyWith<$Res> {
  __$SupplierCopyWithImpl(this._self, this._then);

  final _Supplier _self;
  final $Res Function(_Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? code = freezed,Object? contactPerson = freezed,Object? phone = freezed,Object? email = freezed,Object? address = freezed,Object? status = freezed,Object? statusDisplay = freezed,Object? materialCount = freezed,Object? notes = freezed,}) {
  return _then(_Supplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,contactPerson: freezed == contactPerson ? _self.contactPerson : contactPerson // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,statusDisplay: freezed == statusDisplay ? _self.statusDisplay : statusDisplay // ignore: cast_nullable_to_non_nullable
as String?,materialCount: freezed == materialCount ? _self.materialCount : materialCount // ignore: cast_nullable_to_non_nullable
as int?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
