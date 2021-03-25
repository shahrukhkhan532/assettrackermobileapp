import 'dart:convert';

import 'package:assettracker_app/models/user.dart';
import 'package:assettracker_app/models/tblLatLong.dart';
import 'package:assettracker_app/models/productImage.dart';
class BaseViewModel{
  SubProductVM model;
  List<SubProductVM> listModel;
  String message;
  int statusCode;
  Pager pager;
  BaseViewModel({this.model,this.listModel,this.message,this.statusCode,this.pager});
  factory BaseViewModel.fromJSON(dynamic json){
    if(json == null){
      return new BaseViewModel();
    }
    return BaseViewModel
      (
        model: SubProductVM.fromJSON(json['model']),
        message: json['message'] as String,
        statusCode: json['statusCode'] as int
    );
  }
}
class SubProductVM{
  String productERPNumber;
  String productName;
  String productDescription;
  String createdAt;
  String purchaseDate;
  double unitPrice;
  String locationName;
  String assetStateName;
  String tagName;
  String typeName;
  String c_Code;
  String s_C_Code;
  String s_S_C_Code;
  String c_Code_Name;
  String s_C_Code_Name;
  String s_S_C_Code_Name;
  var latLongs = [];
  var productImages = [];
  bool isIssued;
  bool isPending;
  SubProductVM({this.productERPNumber,
    this.productName,
    this.productDescription,
    this.createdAt,
    this.purchaseDate
    ,this.unitPrice
    ,this.locationName
    ,this.assetStateName
    ,this.tagName
    ,this.typeName
    ,this.c_Code
    ,this.s_C_Code
    ,this.s_S_C_Code
    ,this.c_Code_Name
    ,this.s_C_Code_Name
    ,this.s_S_C_Code_Name
    ,this.latLongs
    ,this.productImages
    ,this.isIssued
    ,this.isPending});
  factory SubProductVM.fromJSON(dynamic json)
  {
    if(json == null){
      return SubProductVM();
    }
    return SubProductVM(
        productName: json['productName'] == null ? "" : json['productName'],
        productERPNumber: json['productERPNumber'] == null ? "" : json['productERPNumber'],
        productDescription: json['productDescription'] == null ? "" : json['productDescription'],
        createdAt: json['createdAt'] == null ? "" : json['createdAt'],
        purchaseDate: json['purchaseDate'] == null ? "" : json['purchaseDate'],
        unitPrice: json['unitPrice'] == null ? 0 : json['unitPrice'],
        locationName: json['locationName']  == null ? "" : json['locationName'],
      assetStateName: json['assetStateName']  == null ? "" : json['assetStateName'],
      tagName: json['tagName']  == null ? "" : json['tagName'],
      c_Code: json['c_Code']  == null ? "" : json['c_Code'],
      s_C_Code: json['s_C_Code']  == null ? "" : json['s_C_Code'],
      s_S_C_Code: json['s_S_C_Code']  == null ? "" : json['s_S_C_Code'],
      c_Code_Name: json['c_Code_Name']  == null ? "" : json['c_Code_Name'],
      s_C_Code_Name: json['s_C_Code_Name']  == null ? "" : json['s_C_Code_Name'],
      s_S_C_Code_Name: json['s_S_C_Code_Name']  == null ? "" : json['s_S_C_Code_Name'],
      latLongs: (json['latLongs'] as List).map((data) => LatLong.fromJSON(data)).toList(),
      productImages: (json['productImages'] as List).map((data) => ProductImage.fromJSON(data)).toList()
    );
  }
}