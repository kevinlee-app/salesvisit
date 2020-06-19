// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(
    storeID: json['storeID'] as String,
    name: json['name'] as String,
    ownerName: json['ownerName'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    createdDate: json['createdDate'] as String,
    createdBy: json['createdBy'] as String,
    modifiedDate: json['modifiedDate'] as String,
    modifiedBy: json['modifiedBy'] as String,
    lat: (json['lat'] as num).toDouble(),
    lang: (json['lang'] as num).toDouble(),
  );
}

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'storeID': instance.storeID,
      'name': instance.name,
      'ownerName': instance.ownerName,
      'phone': instance.phone,
      'email': instance.email,
      'lat': instance.lat,
      'lang': instance.lang,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'modifiedDate': instance.modifiedDate,
      'modifiedBy': instance.modifiedBy,
    };
