import 'package:assettracker_app/models/user.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:assettracker_app/services/tokenservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TokenService tokenService = new TokenService();
  String url = "https://assettrackerservices.azurewebsites.net/v1/";
  List<Bug> bugs = [];
  Future<List<Bug>> getBugs() async {
    final response = await get(url + "Bug/GetBugs");
      Map data = jsonDecode(response.body);
      final list = data['listModel'];
      return (list as List).map((data) => Bug.fromJson(data)).toList();
  }
  Widget getRow(int i){
    return Text('${bugs[i].issueDetails}');
  }

  @override
  void initState() {
    getBugs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact us'),
        elevation: 0,
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Consumer<Auth>(
        builder: (context,auth,child){
          if(auth.loggedIn){
            return FutureBuilder(
              future: getBugs(),
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index){
                      Bug bug = snapshot.data[index];
                      return GestureDetector(
                        child: Card(
                          color: Colors.deepPurple[400],
                          elevation: 0,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
                                title: Text(
                                  '${bug.issueDetails}',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                subtitle: Text('${bug.bugID}'),
                                onTap: () async {
                                  print('${bug.bugID}');
                                  await tokenService.removeToken();
                                  Provider.of<Auth>(context,listen: false).Logout();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }else{
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            });
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
