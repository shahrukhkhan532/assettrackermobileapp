import 'package:assettracker_app/models/SubProductVMForUser.dart';
import 'package:assettracker_app/models/tblLatLong.dart';
import 'package:flutter/material.dart';
import 'package:assettracker_app/models/subproductvm.dart' as SubProductBM;
import 'package:assettracker_app/screens/qrcode/qrCodeServices.dart';

class productdetails extends StatefulWidget {
  @override
  _productdetailsState createState() => _productdetailsState();
}

class _productdetailsState extends State<productdetails> {
  String appbartitle = "";
  SubProductVMForUser modelToPass;
  bool isLoading = false;
  List<LatLong> latlongs = [];
  List<SubProductBM.BaseViewModel> models = [];
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void getProductDetail(String SerialNumber) async{
    showLoadingDialog(context, _keyLoader);
    final m = await getProductBySerialNumber(SerialNumber);
    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
    setState(() {
      if(m != null){
        models.add(m);
        latlongs = m.model.latLongs;
      }else{
        _showScaffold("Unable to find product.");
      }
    });
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
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[400],
    ));
  }
  Widget GenerateListTile(List<LatLong> list){
    return Column(
      children: List.generate(list.length, (index) {
        String Title = "";
        if(list[index]?.creater != ""){
          Title += "Posted by ${list[index]?.creater}";
        }
        if(list[index]?.issuer != ""){
          Title += "Issue to ${list[index]?.issueTo} by ${list[index]?.issuer}";
        }
        return Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: Card(
            child: ListTile(
              leading: IconButton(
                padding: EdgeInsets.all(0),
                tooltip: "See location",
                icon: Icon(Icons.location_on_sharp,color: Colors.blue),
                onPressed: () async => await "",
              ),
              dense: true,
              title: Text('$Title'),
              subtitle: Text('${list[index]?.updatedAt}'),
              trailing: IconButton(
                icon: Icon(Icons.edit_outlined),
                onPressed: () => print("Location"),
              ),
              onTap: () => "",
            ),
          ),
        );
      }),
    );
  }
  Widget buildImages() => SliverToBoxAdapter(
    child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
        ),
        primary: false,
        shrinkWrap: true,
        itemCount: 20,
        itemBuilder: (context,index) => Center(child: Text('$index'))),
  );
  @override
  void initState() {
    super.initState();
    print("init State");
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    var model = arguments["id"] as SubProductVMForUser;
    //getProductDetail(arguments["id"] as String);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue,
            expandedHeight: 200,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Wrap(
                spacing: 0.0,
                runSpacing: 0.0,
                children: [
                  Image.network(
                    '${model.imageURL}',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              centerTitle: true,
              title: Text('${model.productName}'),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(context),
            ),
            actions: [
              Icon(Icons.more_vert_sharp),
              SizedBox(width: 12)
            ],
          ),
          buildImages()
        ],
      ),
    );
  }
}