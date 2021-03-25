import 'package:assettracker_app/screens/qrcode/scan.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:assettracker_app/services/tokenservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'audit/audit.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  TokenService tokenService = new TokenService();
  String _userName = null;
  @override
  void initState() {
    tokenService.getUserName()
    .then((username) => {
    setState(() {
      _userName = username;
    })
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('$_userName'),
              accountEmail: Text('Account Email'),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
            ),
          ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image: AssetImage('images/car1.jpeg'),
                fit: BoxFit.cover
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner_sharp),
            title: Text('Scan QR Code',
              style: TextStyle(
                  fontFamily: "OpenSans"
              ),
            ),
            onTap: (){
              Navigator.of(context).pop();
              //Navigator.pushReplacementNamed(context, "/qrcode");
              Navigator.push(context,MaterialPageRoute(builder: (context) => qrcode()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Audit Asset',
              style: TextStyle(
                  fontFamily: "OpenSans"
              ),),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(context,MaterialPageRoute(builder: (context) => AudutItems()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',
              style: TextStyle(
                  fontFamily: "OpenSans"
              ),
            ),
            onTap: () {
              Provider.of<Auth>(context,listen: false).Logout();
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              });
            },
          )
        ],
      ),
    );
  }
}
