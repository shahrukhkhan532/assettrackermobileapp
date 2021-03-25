import 'dart:io';
import 'package:assettracker_app/models/tblLatLong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:assettracker_app/models/subproductvm.dart' as SubProductBM;
import 'package:assettracker_app/screens/qrcode/qrCodeServices.dart';
import 'package:badges/badges.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assettracker_app/screens/audit/selectuser.dart';
import 'package:assettracker_app/screens/audit/user.dart';

class AudutItems extends StatefulWidget {
  @override
  _AudutItemsState createState() => _AudutItemsState();
}

class _AudutItemsState extends State<AudutItems> {
  LatLong latLong = new LatLong();
  List<String> productSerials = [];
  List<LatLong> latlongs = [];
  List<SubProductBM.BaseViewModel> models = [];
  File _image;
  final picker = ImagePicker();
  String cartCount = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[400],
    ));
  }
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      print('Could not launch $url');
    }
  }
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
  void ScanQRCode() async{
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    if(cameraScanResult == null){
      cameraScanResult = "40020146";
    }
      showLoadingDialog(context, _keyLoader);
      final m = await getProductBySerialNumber(cameraScanResult);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      setState(() {
        if(m != null){
          models.add(m);
          cartCount = (models.length >= 10) ? "${models.length}" : "0${models.length}";
          latlongs = m.model.latLongs;
          productSerials.add(cameraScanResult);
        }else{
          _showScaffold("Unable to find product.");
        }
      });
  }
  Widget GenerateListTile(List<LatLong> list){
    return Column(
      children: List.generate(list.length, (index) {
        String Title = "";
        if(list[index]?.creater != ""){
          Title = "Posted by ${list[index]?.creater}";
        }
        if(list[index]?.issuer != ""){
          Title = "Issue to ${list[index]?.issueTo} by ${list[index]?.issuer}";
        }
        return InkWell(
          child: Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Card(
              child: ListTile(
                  dense: true,
                  title: Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(0),
                        tooltip: "See location",
                        icon: Icon(Icons.location_on_sharp,color: Colors.blue),
                        onPressed: () async => await _launchInBrowser("https://maps.google.com/?q=${list[index]?.latitude},${list[index]?.longitude}"),
                      ),
                      Flexible(
                        child: Text('$Title',
                          style: TextStyle(
                              fontFamily: "OpenSans"
                          ),
                        ),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(left: 45),
                    child: Row(
                      children: [
                        Icon(Icons.timer_sharp,size: 15,color: Colors.blue,),
                        Text('${list[index]?.updatedAt}',
                          style: TextStyle(
                              fontFamily: "OpenSans"
                          ),)
                      ],
                    ),
                  ),
                onTap: () => "",
              ),
            ),
          ),
        );
      }),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to verify asset ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NO'),
              onPressed: () {
                print("No");
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Verify call
                print("YES");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showBottomSheet(index) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
            )
        ),
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove,size: 40)
              ],
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit user',
                style: TextStyle(
                  fontFamily: "OpenSans",
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final userName = await Navigator.push(context,MaterialPageRoute(builder: (context) => selectuser()));
                latLong.issueTo = userName;
                print("Selected user $userName and index: $index");
                _determinePosition();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(
                  'Update picture from gallery',
                  style: TextStyle(
                    fontFamily: "OpenSans",
                  )),
              onTap: () => getImage(0),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(
                  'Update picture from camera',
                  style: TextStyle(
                    fontFamily: "OpenSans",
                  )),
              onTap: () => getImage(1),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(
                  'Remove item from cart',
                  style: TextStyle(
                    fontFamily: "OpenSans",
                  )
              ),
              onTap: () {
                setState(() {
                  models.removeAt(index);
                  productSerials.removeAt(index);
                  cartCount = (models.length >= 10) ? "${models.length}" : "0${models.length}";
                  Navigator.of(context).pop(context);
                });
              },
            )
          ],
        )
    );
  }
  Future getImage(int value) async {
    ImageSource imageSource = value == 0 ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await picker.getImage(source: imageSource);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showScaffold("Location services are disabled.");
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _showScaffold("'Location permissions are permanently denied, we cannot request permissions.");
        return;
      }
      if (permission == LocationPermission.denied) {
        _showScaffold("Location permissions are denied.");
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition();
    latLong.latitude = position.latitude;
    latLong.longitude = position.longitude;
    // Getting address
    final coordinates = new Coordinates(position.latitude,position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    latLong.address = addresses[0]?.addressLine;
    var instance = await SharedPreferences.getInstance();
    print(instance.get('token'));
    print(latLong.toJSON());
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Audit'),
        elevation: 0.0,
        centerTitle: true,
        actions: [
          if (models.length > 0) Chip(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(0),
            label: Text(
                '$cartCount',
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            width: 15.0,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(models.length, (index) {
              return Card(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              '${models[index].model?.productName}',
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.0
                              ),
                            ),
                            subtitle: Text('${models[index].model?.productDescription}'),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert_sharp,color: Colors.black87,),
                              onPressed: () => _showBottomSheet(index),
                            ),
                          ),
                        ),
                        GenerateListTile(models[index].model?.latLongs),
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: Image.network("${models[index]?.model?.productImages[0]?.imageURL}",
                              alignment: Alignment.center
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 5),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showMyDialog(),
                                child: Text('Verify',style: TextStyle(
                                  fontFamily: "OpenSans",
                                    fontSize: 16.0
                                ),),
                              ),
                            ),
                            SizedBox(width: 5),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                        left: -32,
                        top: 10,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(-45/360),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[500]
                            ),
                            padding: EdgeInsets.symmetric(vertical: 4,horizontal: 32),
                            child: Text(
                              'Verified',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScanQRCode(),
        tooltip: 'Scan QR Code',
        child: Icon(Icons.qr_code_scanner_sharp),
      ),
    );
  }
}