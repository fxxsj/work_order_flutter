// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Customer _$CustomerFromJson(Map<String, dynamic> json) => _Customer(
  id: _intFromJson(json['id']),
  name: _stringFromJson(json['name']),
  contactPerson: _stringOrNullFromJson(json['contactPerson']),
  phone: _stringOrNullFromJson(json['phone']),
  email: _stringOrNullFromJson(json['email']),
  address: _stringOrNullFromJson(json['address']),
  notes: _stringOrNullFromJson(json['notes']),
  salespersonId: _intOrNullFromJson(json['salespersonId']),
  salespersonName: _stringOrNullFromJson(json['salespersonName']),
  createdAt: _dateTimeOrNullFromJson(json['createdAt']),
  updatedAt: _dateTimeOrNullFromJson(json['updatedAt']),
);

Map<String, dynamic> _$CustomerToJson(_Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'notes': instance.notes,
  'salespersonId': instance.salespersonId,
  'salespersonName': instance.salespersonName,
  'createdAt': _dateTimeOrNullToJson(instance.createdAt),
  'updatedAt': _dateTimeOrNullToJson(instance.updatedAt),
};
