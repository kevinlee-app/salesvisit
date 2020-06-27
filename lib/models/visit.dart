import 'package:json_annotation/json_annotation.dart';
import 'package:salesvisit/models/store.dart';

part 'visit.g.dart';

@JsonSerializable(nullable: false)
class Visit {
  String visitID;
  String storeID;
  Store store;
  String description;
  String photoPath;
  double lat;
  double lang;
  DateTime createdDate;
  String createdBy;
  String modifiedDate;
  String modifiedBy;

  Visit({this.visitID, this.storeID, this.store, this.description, this.photoPath, this.lat, this.lang, this.createdDate, this.createdBy, this.modifiedDate, this.modifiedBy});
  
  factory Visit.fromJson(Map<String, dynamic> json) => _$VisitFromJson(json);
  Map<String, dynamic> toJson() => _$VisitToJson(this);
}
