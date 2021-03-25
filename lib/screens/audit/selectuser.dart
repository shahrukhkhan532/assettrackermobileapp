import 'package:flutter/material.dart';
import 'package:assettracker_app/screens/audit/user.dart';
import 'package:assettracker_app/screens/audit/auditServices.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';


class selectuser extends StatefulWidget {
  @override
  _selectuserState createState() => _selectuserState();
}
class _selectuserState extends State<selectuser> {
  var _textEditingController = TextEditingController();
  List<User> users = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AuditServices auditServices = new AuditServices();
  bool isLoading = false;
  void getUsers(String query) async{
    setState(() {
      isLoading = true;
    });
    users = await auditServices.getUsersbysearch(query) ?? [];
    if(mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showScaffold("Please enable location services.");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _showScaffold("'Location permissions are permanently denied, we cannot request permissions.");
        return false;
      }
      if (permission == LocationPermission.denied) {
        _showScaffold("Location permissions are denied.");
        return false;
      }
    }
    final position = await Geolocator.getCurrentPosition();
    // Getting address
    final coordinates = new Coordinates(position.latitude,position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print("${addresses[0].addressLine}");
    return true;
  }
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_sharp,color: Colors.white),
          SizedBox(width: 5),
          Text("$message",style: TextStyle(fontFamily: "OpenSans"))
        ]
      ),
      backgroundColor: Colors.red[400],
    ));
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextField(
          controller: _textEditingController,
          style: TextStyle(
              color: Colors.white
          ),
          onSubmitted: (value) async{
            if(await _determinePosition()){
              print("onSubmitted: $value");
              if(value != null && value != ""){
                getUsers(value);
              }
            }
          },
          decoration: InputDecoration(
            suffixIcon: GestureDetector(child: Icon(Icons.close,color: Colors.white),
                onTap: () {
                  _textEditingController.clear();
                }),
            hintText: "Search user",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : buildListView()
    );
  }
  buildListView(){
    return !(users.length > 0) ? Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No result found',style: TextStyle(fontFamily: "OpenSans")),
            Icon(Icons.whatshot)
          ]
        )
    ) : ListView.builder(
        itemCount: users.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index){
          return ListTile(
            leading: CircleAvatar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              child: Text('${users[index].firstName.substring(0,1).toUpperCase()}',style: TextStyle(fontFamily: "OpenSans")),
            ),
            title: Text('${users[index].fullName}',style: TextStyle(fontFamily: "OpenSans")),
            subtitle: Text('${users[index].userName}',style: TextStyle(fontFamily: "OpenSans")),
            onTap: (){
              Navigator.pop(context,users[index].userName);
          },
          );
        }
    );
  }
  buildSearch(){
    return Text('');
  }
}
