import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TokenService{
  // static final TokenService instance = TokenService._();
  // TokenService._();

  Future setToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    return token;
  }
  Future removeToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }
  Future<bool> isAuthenticated() async {
    String token = await getToken();
    if(token != null && !(Jwt.isExpired(token))){
      return true;
    }
    await removeToken();
    return false;
  }
  Future<String> getUserName() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token');
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    return decodedToken['unique_name'] as String;
  }
}