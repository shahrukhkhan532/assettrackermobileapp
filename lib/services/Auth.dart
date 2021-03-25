import 'package:assettracker_app/services/tokenservice.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  TokenService tokenService = new TokenService();
  bool authenticated = false;
  get loggedIn {
   return authenticated;
  }

  Future<bool> IsAuthenticated() async{
    authenticated = await tokenService.isAuthenticated();
    return authenticated;
  }

  SingIn(){
    authenticated = true;
    notifyListeners();
  }
  Logout(){
    tokenService.removeToken();
    authenticated = false;
    notifyListeners();
  }
  UpdateFlag(){

  }
}