import 'package:assettracker_app/screens/audit/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuditServices{
  String url = "https://assettrackerservices.azurewebsites.net/v1/";

  Future<List<User>> getUsersbysearch(String query) async{
    var prefs = await SharedPreferences.getInstance();
    //print('THIS IS THE BEARER TOKEN ${prefs.getString('token')}');
    final response = await http.get("${url}User/GetUsers?username=$query",
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
          "Authorization": "Bearer ${prefs.getString('token')}"
        });
    print('THIS IS THE STATUS CODE ${response.statusCode}');
    if(response.body.isNotEmpty){
      Map map = json.decode(response.body);
      BaseViewModel res = BaseViewModel.fromJson(map);
      return res.listModel;
    }else{
      return null;
    }
  }
}