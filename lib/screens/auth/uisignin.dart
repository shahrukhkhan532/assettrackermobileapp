import 'dart:convert';

import 'package:assettracker_app/services/tokenservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:http/http.dart' as http;

class signinx extends StatefulWidget {
  @override
  _signinxState createState() => _signinxState();
}

class _signinxState extends State<signinx> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TokenService tokenService = new TokenService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoggedIn = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Please Wait....",style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
        });
  }
  void SubmitUser() async {
    final uri = 'https://assettrackerservices.azurewebsites.net/v1/account/login';
    var map = new Map<String, dynamic>();
    map['Username'] = _usernameController.value.text;
    map['Password'] = _passwordController.value.text;
    showLoadingDialog(context, _keyLoader);
    http.Response response = await http.post(
        uri,
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        }
        ,
        body: jsonEncode(map));
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
    if(response.statusCode == 200){
      Map mmap = json.decode(response.body);
      if(mmap['model'] == null){
        final errorMessage = mmap['message'];
        tokenService.removeToken();
        print(errorMessage);
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.blue
            )
        );
      }else{
        final token = mmap['model']['token'];
        print(token);
        await tokenService.setToken(token);
        Provider.of<Auth>(context, listen: false).SingIn();
      }
    }
  }
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false);
    super.initState();
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Consumer<Auth>(
          builder: (context,auth,child){
            return FutureBuilder<bool>(
                future: auth.IsAuthenticated(),
              builder: (context,AsyncSnapshot<bool> snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data){
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                      });
                      return Center(child: CircularProgressIndicator());
                    }else{
                      return Container(
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipPath(
                                  clipper: DrawClip(),
                                  child: Container(
                                    height: size.height/2.2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.blue,
                                              Colors.blue[50]
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 45),
                                  child: Center(child: Image.asset('images/unnamed.png',
                                    fit: BoxFit.cover,
                                    height: size.height/3.5,
                                    alignment: Alignment.center,)),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.1,vertical: 10),
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue
                                ),
                              ),
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.1,
                                          vertical: 10
                                      ),
                                      child: TextFormField(
                                        validator: (String value){
                                          if(value.isEmpty){
                                            return 'Username is required';
                                          }else if(value.length < 3){
                                            return 'Min length 3 required';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                            labelText: 'Username',
                                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                                            fillColor: Colors.grey[200],
                                            filled: true
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.1,
                                          vertical: 10
                                      ),
                                      child: TextFormField(
                                        validator: (String value){
                                          if(value.isEmpty){
                                            return 'Password is required';
                                          }else if(value.length < 3){
                                            return 'Min length 3 required';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(borderSide: BorderSide.none),
                                            fillColor: Colors.grey[200],
                                            labelText: 'Password',
                                            suffixIcon: Icon(Icons.remove_red_eye),
                                            contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                            filled: true
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.1,
                                  right: size.width * 0.1,
                                  top: 10,
                                  bottom: 10
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    if(_formKey.currentState.validate()){
                                      print(_usernameController.value.text);
                                      print(_passwordController.value.text);
                                      SubmitUser();
                                    }
                                  },
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Center(
                                          child: Text(
                                            'SIGN IN',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'Since 1994',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontFamily: "OpenSans",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
              },
            );
          },
        ),
      ),
    );
  }
}

class DrawClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width*0.1, size.height-50);
    path.lineTo(size.width*0.9, size.height-50);
    path.lineTo(size.width, size.height-100);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}