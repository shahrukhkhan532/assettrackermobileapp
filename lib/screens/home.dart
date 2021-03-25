import 'dart:async';

import 'package:assettracker_app/models/SubProductVMForUser.dart';
import 'package:assettracker_app/screens/navbar.dart';
import 'package:assettracker_app/screens/productdetails.dart';
import 'package:assettracker_app/services/SubProductServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<SubProductVMForUser> list = [];
  var isLoading = true;
  SubProductServices subProductServices = new SubProductServices();
  void GetPro() async{
    setState(() {
      isLoading = true;
    });
    list = await subProductServices?.GetSubProducts() ?? [];
   if(mounted) {
     setState(() {
       isLoading = false;
     });
   }

  }
  bool _showScaffold(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet ? 'Connection established' : 'You have no internet';
    final color = hasInternet ? Colors.green : Colors.red;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
    return hasInternet;
  }
  @override
  void initState(){
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((event)
    {
      if(_showScaffold(event)){
        GetPro();
      }
    });
    GetPro();
    super.initState();
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Asset Tracker',
            style: TextStyle(
                fontFamily: "OpenSans"
            ),
          ),
          elevation: 0.0,
          leading: Builder(
            builder: (BuildContext context) {
              return TextButton(
                child: Image.asset(
                  'images/menu-icon.png',
                  color: Colors.white,
                  height: 20,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              itemBuilder: (BuildContext bc) => [
                PopupMenuItem(child: Text(
                  "Logout",
                  style: TextStyle(fontFamily: "OpenSans"),
                ),
                    value: "/AudutItems",
                    height: 15
                ),
              ],
              onSelected: (route) {
                print(route);
                // Note You must create respective pages for navigation
                Navigator.pushNamed(context, route);
              },
            ),
          ],
        ),
        body: buildEmployeeListView());
  }
  buildEmployeeListView(){
    return isLoading ? Center(
      child: CircularProgressIndicator(),
    ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20,top: 10),
                child: Text(
                    'My Assets',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "OpenSans"
                  ),
                )
            ),
            GridView.builder(
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (BuildContext context,int index){
                  SubProductVMForUser model = list[index];
                  return Card(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, "/productdetails",arguments: { "id": model }),
                      child: GridTile(
                        child: Image.network('${model.imageURL}'),
                        footer: Container(
                          color: Colors.white54,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('${model.productName}',style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text('${model.productDescription}')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        );
  }
}
