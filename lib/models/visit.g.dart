// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Visit _$VisitFromJson(Map<String, dynamic> json) {
  return Visit(
    visitID: json['visitID'] as String,
    store: Store.fromJson(json['store'] as Map<String, dynamic>),
    description: json['description'] as String,
    photoPath: json['photoPath'] as String,
    lat: (json['lat'] as num).toDouble(),
    lang: (json['lang'] as num).toDouble(),
    createdDate: json['createdDate'] as String,
    createdBy: json['createdBy'] as String,
    modifiedDate: json['modifiedDate'] as String,
    modifiedBy: json['modifiedBy'] as String,
  );
}

Map<String, dynamic> _$VisitToJson(Visit instance) => <String, dynamic>{
      'visitID': instance.visitID,
      'store': instance.store,
      'description': instance.description,
      'photoPath': instance.photoPath,
      'lat': instance.lat,
      'lang': instance.lang,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
      'modifiedDate': instance.modifiedDate,
      'modifiedBy': instance.modifiedBy,
    };
