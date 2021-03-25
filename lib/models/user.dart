import 'dart:convert';
class BaseViewModel{
  Bug model;
  List<Bug> listModel;
  String message;
  int statusCode;
  Pager pager;
  BaseViewModel({this.model,this.listModel,this.message,this.statusCode,this.pager});
  factory BaseViewModel.fromJson(dynamic json){
    return BaseViewModel
      (
        model: Bug.fromJson(json['model']),
        listModel: (json['listModel'] as List).map((data) => Bug.fromJson(data)).toList(),
        message: json['message'] as String,
        statusCode: json['statusCode'] as int,
        pager: Pager.fromJson(json['pager'])
      );
  }
}
class Pager{
  int totalItems;
  int currentPage;
  int pageSize;
  int totalPages;
  int startPage;
  int endPage;
  Pager({this.totalItems,this.currentPage,this.pageSize,this.totalPages,this.startPage,this.endPage});
  factory Pager.fromJson(dynamic json){
    return Pager(
        totalItems: json['totalItems'],
        currentPage: json['currentPage'],
        pageSize: json['pageSize'],
        totalPages: json['totalPages'],
        startPage: json['startPage'],
        endPage: json['endPage']);
  }
}
class User{
  String FirstName;
  String LastName;
  User({this.FirstName,this.LastName});
}
class Bug{
  int bugID;
  String issueDetails;
  Bug({this.bugID,this.issueDetails});
  factory Bug.fromJson(dynamic json) {
    return Bug(bugID: json['bugID'],issueDetails: json['issueDetails']);
  }
}