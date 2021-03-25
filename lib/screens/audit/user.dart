class BaseViewModel{
  User model;
  List<User> listModel;
  String message;
  int statusCode;
  Pager pager;
  BaseViewModel({this.model,this.listModel,this.message,this.statusCode,this.pager});
  factory BaseViewModel.fromJson(dynamic json){
    return BaseViewModel
      (
        model: User.fromJSON(json['model']),
        listModel: (json['listModel'] as List).map((data) => User.fromJSON(data)).toList(),
        message: json['message'] == null ? "" : json['message'] as String,
        statusCode: json['statusCode'] == null ? 404 : json['statusCode'] as int,
        pager: Pager.fromJson(json['pager'])
    );
  }
}
class User{
  int incrementID;
  String firstName;
  String lastName;
  String fullName;
  String userName;
  String email;
  User({this.incrementID,this.firstName,this.lastName,this.fullName,this.userName,this.email});
  factory User.fromJSON(dynamic json){
    if(json == null){
      return User();
    }
    return User(
      incrementID: json['incrementID'] == null ? 0 : json['incrementID'] as int,
      firstName: json['firstName'] == null ? "" : json['firstName'] as String,
      lastName: json['lastName'] == null ? "" : json['lastName'] as String,
      fullName: json['fullName'] == null ? "" : json['fullName'] as String,
      userName: json['userName'] == null ? "" : json['userName'] as String,
      email: json['email'] == null ? "" : json['email'] as String
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
    if(json == null){
      return Pager();
    }
    return Pager(
        totalItems: json['totalItems'] == null ? 0 : json['totalItems'] as int,
        currentPage: json['currentPage'] == null ? 0 : json['currentPage'] as int,
        pageSize: json['pageSize'] == null ? 0 : json['pageSize'] as int,
        totalPages: json['totalPages'] == null ? 0 : json['totalPages'] as int,
        startPage: json['startPage'] == null ? 0 : json['startPage'] as int,
        endPage: json['endPage'] == null ? 0 : json['endPage'] as int
    );
  }
}