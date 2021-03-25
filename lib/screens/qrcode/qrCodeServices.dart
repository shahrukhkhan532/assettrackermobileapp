import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assettracker_app/models/subproductvm.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

String URL = "https://assettrackerservices.azurewebsites.net/v1/SubProduct/GetProductBySerialNumber?serialNumber=";

Future<BaseViewModel> getProductBySerialNumber(String SerialNumber) async {
    final response = await http.get("$URL$SerialNumber");
    if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        print("STATUS CODE: ${response.statusCode}");
        BaseViewModel result = BaseViewModel.fromJSON(data);
        return result;
    }else{
        return null;
    }
}
