import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';

String backendUrl="http://mapi.yoyopon.com";
var db=DBHelper();

Future<Map> getHeaders() async {//timezone
  try {
    var headers =
    <String, String>{
      "x-timestamp":await db.getData(DataKeyValue.xtimeStamp),
      "x-sign":await db.getData(DataKeyValue.xsign),
      "Authorization":await db.getData(DataKeyValue.token)
    };
    return headers;
  }catch(ex){
    var headers =
    <String, String>{
      "x-timestamp": "",
      "x-sign":"",
      "Authorization":""
    };
    return headers;
  }
}

Future<Map> getHeaders1() async {//timezone
  try {
    var headers =
    <String, String>{
      "x-timestamp":await db.getData(DataKeyValue.xtimeStamp),
      "x-sign":await db.getData(DataKeyValue.xsign),
      "Authorization":await db.getData(DataKeyValue.token),
      "full-name":await db.getData(DataKeyValue.fullname),
      "img-url":await db.getData(DataKeyValue.imgUrl)
    };
    return headers;
  }catch(ex){
    var headers =
    <String, String>{
      "x-timestamp": "",
      "x-sign":"",
      "Authorization":"",
      "full-name":"",
      "img-url":""
    };
    return headers;
  }
}