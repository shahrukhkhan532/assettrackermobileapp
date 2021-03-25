import 'package:assettracker_app/models/SubProductVMForUser.dart';
import 'package:assettracker_app/services/tokenservice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SubProductServices{
  TokenService tokenService = new TokenService();
  String Token = "";
  SubProductServices(){
    tokenService.getToken().then((value) => {
      Token = value,
    });
  }
  String url = "https://assettrackerservices.azurewebsites.net/v1/";

  Future<List<SubProductVMForUser>> GetSubProducts() async{
    var prefs = await SharedPreferences.getInstance();
    print('THIS IS THE BEARER TOKEN ${prefs.getString('token')}');
    final response = await http.get("${url}SubProduct/GetSubProducts",
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
        "Authorization": "Bearer ${prefs.getString('token')}"
      });
    print('THIS IS THE STATUS CODE ${response.statusCode}');
    if(response.body.isNotEmpty){
      Map map = json.decode(response.body);
      BaseViewModel res = BaseViewModel.fromJSON(map);
      return res.listModel;
    }else{
      return null;
    }
  }
}