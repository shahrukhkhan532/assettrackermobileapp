import 'dart:convert';
import 'package:assettracker_app/screens/contact.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:assettracker_app/services/tokenservice.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TokenService tokenService = new TokenService();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoggedIn = false;

  void SubmitUser() async {
    final uri = 'https://assettrackerservices.azurewebsites.net/v1/account/login';
    var map = new Map<String, dynamic>();
    map['Username'] = _usernameController.value.text;
    map['Password'] = _passwordController.value.text;
    http.Response response = await http.post(
        uri,
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
        }
    ,
        body: jsonEncode(map));
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
  void initState(){
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   Provider.of<Auth>(context, listen: false).IsAuthenticated();
    // });
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Consumer<Auth>(
        builder: (context,auth,child){
            return FutureBuilder<bool>(
              future: auth.IsAuthenticated(),
              builder: (context, AsyncSnapshot<bool> snapshot){
                if(snapshot.hasData){
                  print("Snapshot Data ${snapshot.data}");
                  if(snapshot.data){
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                    });
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return Container(
                      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
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
                                  hintText: 'example@sospakistan.net'
                              ),
                            ),
                            TextFormField(
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
                                  labelText: 'Password'
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }else{
                  return CircularProgressIndicator();
                }
              },
            );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 20.0,
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_formKey.currentState.validate()){
            print(_usernameController.value.text);
            print(_passwordController.value.text);
            SubmitUser();
          }
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
