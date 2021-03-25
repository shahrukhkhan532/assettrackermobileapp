import 'package:assettracker_app/screens/qrcode/qrCodeServices.dart';
import 'package:assettracker_app/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:assettracker_app/models/subproductvm.dart' as SubProductBM;
import 'package:assettracker_app/models/subproductvm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class qrcode extends StatefulWidget {
  @override
  _qrcodeState createState() => _qrcodeState();
}

class _qrcodeState extends State<qrcode> {
  String ActualResult = "";
  SubProductBM.BaseViewModel model = new SubProductBM.BaseViewModel();
  bool isLoading = true;
  Future<SubProductBM.BaseViewModel> fetchqrCode() async{
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    setState(() {
      isLoading = true;
    });
    model = await getProductBySerialNumber(cameraScanResult);
    setState(() {
      isLoading = false;
    });
    return model;
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Scan now'),
          elevation: 10,
          backgroundColor: Colors.deepPurple[400],
        ),
        body: Consumer<Auth>(
          builder: (context,auth,child){
            if(auth.loggedIn){
              return SizedBox(
                child: isLoading == true ? CircularProgressIndicator() : DataView(),
              );
            }else{
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              });
              return CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => {
              fetchqrCode(),
            },
            child: Icon(Icons.qr_code_scanner_sharp),
            backgroundColor: Colors.deepPurple[400]
        ),
      );
  }
  Widget DataView(){
    return MyContainer();
  }
  Widget MyContainer(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "${model?.model?.productName}",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                "Description: ${model?.model?.productDescription}",
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                "Register Date: ${model?.model?.createdAt}",
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                "Unit Price: ${model?.model?.unitPrice}",
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                "Category: ${model?.model?.c_Code_Name}/${model?.model?.s_C_Code_Name}/${model?.model?.s_S_C_Code_Name}",
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
              child: Text(
                "Location: ${model?.model?.locationName}",
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: Image.network(model?.model?.productImages[0]?.imageURL),
            )
          ],
        ),
      ),
    );
  }
  Widget EmptyCartView(){
    return Center(
      child: Image(image: AssetImage('images/empty.png')),
    );
  }
}