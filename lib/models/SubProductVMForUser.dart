import 'package:assettracker_app/models/tblLatLong.dart';
import 'package:assettracker_app/models/user.dart';
class BaseViewModel{
  SubProductVMForUser model;
  List<SubProductVMForUser> listModel;
  String message;
  int statusCode;
  bool isSuccess;
  Pager pager;
  BaseViewModel({this.model,this.listModel,this.message,this.statusCode,this.isSuccess,this.pager});
  factory BaseViewModel.fromJSON(dynamic json){
    return BaseViewModel
      (
        listModel: (json['listModel'] as List).map((data) => SubProductVMForUser.fromJSON(data)).toList(),
        isSuccess: json['isSuccess'] as bool,
        message: json['message'] as String,
        statusCode: json['statusCode'] as int
    );
  }
}
class SubProductVMForUser{
  String subProductSerialNumber;
  String productERPNumber;
  String serialNumber;
  int subProState;
  String productName;
  String productDescription;
  String createdAt;
  double unitPrice;
  String assetStateName;
  String tagName;
  String typeName;
  String imageURL;
  String issueTo;
  int orderSerialNumber;
  int incrementNumber;
  LatLong latLong;
  bool isSelected = false;
  SubProductVMForUser({this.subProductSerialNumber,this.productERPNumber,this.serialNumber,this.subProState,this.productName,this.productDescription,
  this.createdAt,this.unitPrice,this.assetStateName,this.tagName,this.typeName,this.imageURL,this.issueTo,this.orderSerialNumber,
  this.incrementNumber,this.latLong});
  factory SubProductVMForUser.fromJSON(dynamic json){
    return SubProductVMForUser(
      subProductSerialNumber: json['subProductSerialNumber'] == null ? "" : json['subProductSerialNumber'],
      productERPNumber: json['productERPNumber'] == null ? "" : json['productERPNumber'],
      serialNumber: json['serialNumber'] == null ? "" : json['serialNumber'],
      subProState: json['subProState'] == null ? 0 : json['subProState'],
      productName: json['productName'] == null ? "" : json['productName'],
      productDescription: json['productDescription'] == null ? 0 : json['productDescription'],
      createdAt: json['createdAt'] == null ? 0 : json['createdAt'],
      unitPrice: json['unitPrice'] == null ? 0.0 : json['unitPrice'],
      assetStateName: json['assetStateName'] == null ? "" : json['assetStateName'],
      tagName: json['tagName'] == null ? "" : json['tagName'],
      typeName: json['typeName'] == null ? "" : json['typeName'],
      imageURL: json['imageURL'] == null ? "" : json['imageURL'],
      issueTo: json['issueTo'] == null ? "" : json['issueTo'],
      orderSerialNumber: json['orderSerialNumber'] == null ? "" : json['orderSerialNumber'],
      incrementNumber: json['incrementNumber'] == null ? "" : json['incrementNumber'],
      latLong: LatLong.fromJSON(json['latLong'])
    );
  }
}