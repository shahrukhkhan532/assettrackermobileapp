import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
class LatLong{
  int latLongID;
  double latitude;
  double longitude;
  String address;
  String updatedAt;
  String creater;
  String issuer;
  String issueTo;
  String receiver;
  String productERPNumber;
  String subProductSerialNumber;
  LatLong({this.latLongID,this.latitude,this.longitude,this.address,this.updatedAt,this.creater,this.issuer,this.issueTo,this.receiver,this.productERPNumber,this.subProductSerialNumber});
  factory LatLong.fromJSON(dynamic json){
    if(json == null){
      return LatLong();
    }
    return LatLong(
      latLongID: json['latLongID'] == null ? "" : json['latLongID'],
      latitude: json['latitude'] == null ? 0.0 : json['latitude'],
      longitude: json['longitude'] == null ? 0.0 : json['longitude'],
      address: json['address'] == null ? "" : json['address'],
      updatedAt: json['updatedAt'] == null ? "" : "${new DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse('${json['updatedAt']}'))}",
      creater: json['creater'] == null ? "" : json['creater'],
      issuer: json['issuer'] == null ? "" : json['issuer'],
      issueTo: json['issueTo'] == null ? "" : json['issueTo'],
      receiver: json['receiver'] == null ? "" : json['receiver'],
      productERPNumber: json['productERPNumber'] == null ? "" : json['productERPNumber'],
      subProductSerialNumber: json['subProductSerialNumber'] == null ? "" : json['subProductSerialNumber']
    );
  }
  Map<String, dynamic> toJSON() => {
    'latLongID': latLongID,
    'latitude' : latitude,
    'longitude' : longitude,
    'address' : address,
    'updatedAt': updatedAt,
    'creater' : creater,
    'issuer' : issuer,
    'issueTo' : issueTo,
    'receiver' : receiver,
    'productERPNumber' : productERPNumber,
    'subProductSerialNumber' : subProductSerialNumber
  };
}