import 'package:assettracker_app/screens/audit/audit.dart';
import 'package:assettracker_app/screens/audit/selectuser.dart';
import 'package:assettracker_app/screens/home.dart';
import 'package:assettracker_app/screens/productdetails.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assettracker_app/screens/contact.dart';
import 'package:assettracker_app/screens/qrcode/scan.dart';
import 'package:assettracker_app/screens/auth/uisignin.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // TokenService tokenService = new TokenService();
  // bool isAuthenticated = await tokenService.isAuthenticated();
  runApp(
      ChangeNotifierProvider(
        create: (context) => Auth(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              '/': (context) => signinx(),
              '/contact': (context) => Contact(),
              '/qrcode': (context) => qrcode(),
              '/home': (context) => Home(),
              '/AudutItems': (context) => AudutItems(),
              '/selectuser': (context) => selectuser(),
              '/productdetails': (context) => productdetails()
            },
          )
      )
  );
}