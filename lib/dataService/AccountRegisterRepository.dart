import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ypay/APIService/NetworkUtil.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class AccountRegisterRepostory{
  BuildContext context;
  AccountRegisterRepostory(this.context);
  NetworkUtil _netUtil = new NetworkUtil();
  var db=DBHelper();

  Future<bool> getTempToken({String uname,String upass}) async {
    var url = "$backendUrl/token";
    var dataStr="UserName=$uname&Password=$upass&grant_type=password";
    return getHeaders().then((myHeaders) {
      return _netUtil.post(this.context,url, headers:myHeaders, body:
      dataStr
      ).then((http.Response response) async {
        print(response.statusCode);
        var obj = json.decode(response.body);//["data"];
        UserInfo info=new UserInfo();
        if(obj==null){
          info.msg="Error occurred";
          return false; 
        }
        else{
          info=UserInfo.fromJson(obj);
          await db.setData(info.accessToken,DataKeyValue.token);
          return true;
        }
      });
    });
  }

  Future<ResponseModel> getPhoneCode({String mobile}){
    var url="$backendUrl/api/usersubmit/send_verify_smscode?mobile=$mobile";
    return getHeaders().then((myHeaders){
      return _netUtil.get(this.context,url, myHeaders).then((http.Response response) async {
        var obj=json.decode(response.body);
        if(obj!=null){
          var obj1=json.decode(obj);
          ResponseModel responseModel=new ResponseModel();
          responseModel=ResponseModel.fromJson(obj1);
          return responseModel;
        }
        else{
          return null;
        }
      });
    });
  }

  Future<ResponseModel> codeVerify({String mobile,String code}){
    var url="$backendUrl/api/usersubmit/Phone_verify_smscode?mobile=$mobile&code=$code";
    return getHeaders().then((myHeaders){
      return _netUtil.get(this.context,url, myHeaders).then((http.Response response) async {
        var obj=json.decode(response.body);
        if(obj!=null){
          var obj1=json.decode(obj);
          ResponseModel responseModel=new ResponseModel();
          responseModel=ResponseModel.fromJson(obj1);
          return responseModel;
        }
        else{
          return null;
        }
      });
    });
  }

  Future<ResponseModel> createAcc()async{
    var url = "$backendUrl/api/usersubmit/user_register";
    var body=json.encode(UserRegister.userRegister);
    //var body=json.encode(User.users);
    print(body);
    return getToken().then((tt){
      return registerAcc(url, tt, body).then((res){
        if(res!=null)return res;
        else return null;
      });
    });
  }

  Future<String> getToken()async{
    String token=await db.getData(DataKeyValue.token);
    return token;
  }

  Future<ResponseModel> registerAcc(String url,String token,dynamic body,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": token},
      encoding: encoding,
      body: body
      );
    if(request.statusCode==200){
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        ResponseModel responseModel=new ResponseModel();
          responseModel=ResponseModel.fromJson(obj1);
          return responseModel;
      }else{
        return null;
      }
  }

  Future<ResponseModel> getUserCode({String username,String type}){
    var url="$backendUrl/api/usersubmit/user_getpassword?user_name=$username&type=$type";
    return getToken().then((tt){
      return getUserCode1(url, tt).then((res){
        return res;
      });
    });
  }

  Future<ResponseModel> getUserCode1(String url,String token,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: { 'Content-type': 'application/json',
              'Accept': 'application/json',
              "Authorization": token},
      encoding: encoding
      );
    if(request.statusCode==200){
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        ResponseModel responseModel=new ResponseModel();
          responseModel=ResponseModel.fromJson(obj1);
          return responseModel;
    }
    else{
      var obj=json.decode(request.body);
        var obj1=json.decode(obj);
      ResponseModel responseModel=new ResponseModel();
          responseModel=ResponseModel.fromJson(obj1);
          return responseModel;
    }
  }

  Future<ResponseModel> userRepassword({String code,String pass}){
    var url="$backendUrl/api/usersubmit/user_repassword?code=$code&password=$pass";
    return getToken().then((tt){
      return getUserCode1(url, tt).then((res){
        return res;
      });
    });
  }

  Future<dynamic> editUserInfo({User user}){
    var url="$backendUrl/api/usersubmit/user_info_edit";
    var dataStr="id=${user.id}&group_id=${user.groupId}&user_name=${user.userName}&salt=${user.salt}&password=${user.password}&mobile=${user.mobile}&email=${user.email}&avatar=${user.avatar}&nick_name=${user.nickName}&sex=${user.sex}&birthday=${user.birthday}&telphone=${user.telphone}&area=${user.area}&address=${user.address}&qq=${user.qq}&msn=${user.msn}&amount=${user.amount}&point=${user.point}&exp=${user.exp}&status=${user.status}&reg_time=${user.regTime}&reg_ip=${user.regIp}&security_stamp=${user.securityStamp}&device_id=${user.deviceId}&gps_location=${user.gpsLocation}&use_lang=${user.useLang}";
   // Map<String, dynamic> dataStr = {'id': user.id.toString(), 'group_id': user.groupId.toString(),'user_name':user.userName,'salt':user.salt,'password':user.password,
    // "mobile":user.mobile,"email":user.email,"avatar":user.avatar,"nick_name":user.nickName,"sex":user.sex,"birthday":user.birthday,
    // "telphone":user.telphone,"area":user.area,"address":user.address,"qq":user.qq,"msn":user.msn,"amount":user.amount.toString(),"point":user.point.toString(),
    // "exp":user.exp.toString(),"status":user.status.toString(),r"eg_time":user.regTime,"reg_ip":user.regIp,"security_stamp":user.securityStamp,"device_id":user.deviceId,"gps_location":user.gpsLocation,"use_lang":user.useLang
    // };
  // var dataStr=user.toJson();
    return getToken().then((tt){
      return updateUser(url, tt,body:dataStr).then((res){
        return res;
      });
    });
  }

  Future<dynamic> updateUser(String url,String token,{dynamic body,dynamic encoding})async{
    var request=await http.post(
      url,
      headers: { 
              "Content-Type": "application/x-www-form-urlencoded",
              "Accept": "application/json",
              "Authorization": token},
      body: body,
      encoding: Encoding.getByName("utf-8")
      );
      print(request.statusCode);
      if(request.statusCode==200){
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        ResponseModel1 responseModel=new ResponseModel1();
        responseModel=ResponseModel1.fromJson(obj1);
        return responseModel;
      }
      else{
        var obj=json.decode(request.body);
        var obj1=json.decode(obj["Message"]);
        ResponseModel1 responseModel=new ResponseModel1();
        responseModel=ResponseModel1.fromJson(obj1);
        return responseModel;
      }
  }

}