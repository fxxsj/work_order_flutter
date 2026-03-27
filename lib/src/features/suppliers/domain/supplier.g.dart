// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupplierImpl _$$SupplierImplFromJson(Map<String, dynamic> json) =>
    _$SupplierImpl(
      id: _intFromJson(json['id']),
      name: _stringFromJson(json['name']),
      code: _stringOrNullFromJson(json['code']),
      contactPerson: _stringOrNullFromJson(json['contact_person']),
      phone: _stringOrNullFromJson(json['phone']),
      email: _stringOrNullFromJson(json['email']),
      address: _stringOrNullFromJson(json['address']),
      status: _stringOrNullFromJson(json['status']),
      statusDisplay: _stringOrNullFromJson(json['status_display']),
      materialCount: _intOrNullFromJson(json['material_count']),
      notes: _stringOrNullFromJson(json['notes']),
    );

Map<String, dynamic> _$$SupplierImplToJson(_$SupplierImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'contact_person': instance.contactPerson,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'status': instance.status,
      'status_display': instance.statusDisplay,
      'material_count': instance.materialCount,
      'notes': instance.notes,
    };
