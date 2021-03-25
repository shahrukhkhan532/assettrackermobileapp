import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:assettracker_app/Auth/dio.dart';
import 'package:http/http.dart';
class Auth extends ChangeNotifier {
  bool _isAuthenticated = false;
  get loggedIn => _isAuthenticated;

  Future signIn({Map data,Function callback, Function error}) async{
    // Dio.Response response = await dio().post(
    //     'https://localhost:44300/Account/Login',
    //     data: json.encode(data)
    // );
    var body = json.encode(data);
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };
    try{
      var response = await http.post(
          'https://10.0.2.2:44300/Account/Login',
          body: body,
          headers: headers);
      String token = json.decode(response.toString());
      print("token " + token);
    }catch(e) {
      print(e);
    }
    //_isAuthenticated = true;
    //notifyListeners();
  }
}