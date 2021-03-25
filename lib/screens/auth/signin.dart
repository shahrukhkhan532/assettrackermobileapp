import 'package:assettracker_app/Auth/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void _submit(){
    Provider.of<Auth>(context,listen: false).signIn(
      data: {
        'userName': emailController.text,
        'password': passwordController.text
      }
    );

  }
  @override void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 0,
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'you@sospakistan.net',
                    labelText: 'Username',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password'
                  )
                ),
                Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    onPressed: () => _submit(),
                    color: Colors.blue,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
