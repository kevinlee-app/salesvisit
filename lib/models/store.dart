import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(nullable: false)
class Store {
  String storeID;
  String name;
  String ownerName;
  String phone;
  String email;
  double lat;
  double lang;
  String createdDate;
  String createdBy;
  String modifiedDate;
  String modifiedBy;

  Store({this.storeID, this.name, this.ownerName, this.phone, this.email, this.createdDate, this.createdBy, this.modifiedDate, this.modifiedBy, this.lat, this.lang});
  
  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}