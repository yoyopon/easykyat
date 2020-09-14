import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/Login/LoginLoadingPage.dart';
import 'package:ypay/dataService/loginPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class LoginAfterReset extends StatefulWidget {
  final String username;final String password;
  LoginAfterReset({this.username,this.password}):super();
  @override
  _LoginAfterResetState createState() => _LoginAfterResetState();
}

class _LoginAfterResetState extends State<LoginAfterReset> implements LoginContract{

  var db=DBHelper();
  LoginPresenter _presenter;
  String dateFormat=DateFormat('yyyyddMMhhmmssmmm').format(DateTime.now()).toString();

  @override
  void initState() {
    _presenter=LoginPresenter(this, context);
    userLogin();
    super.initState();
  }

  userLogin()async{
    await db.setData(dateFormat, DataKeyValue.xtimeStamp);
    await db.setData(getMD5val(), DataKeyValue.xsign);
    _presenter.loginWithUserName(username: widget.username,password:widget.password);
    
  }

  String getMD5val(){
    var bytes = utf8.encode(widget.username);
    var username =UserInfo.username= base64.encode(bytes);
    var bytes1 = utf8.encode(widget.password);
    var password = UserInfo.password=base64.encode(bytes1);
    String text=findEvenDigits(dateFormat)+":"+username+":"+password;
    String md5Res=md5.convert(utf8.encode(text)).toString();
    print("timestamp:"+dateFormat+"username:"+username+"--password:"+password+"--xsign:"+md5Res);
    return md5Res;
  }

  String findEvenDigits(String name){
    String evenDigits="";
    for (var i = 0; i < name.length; i++) {
      if(i%2==1){
        evenDigits=evenDigits+name[i];
      }
    }
    return evenDigits;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: Scaffold(
        body: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text("Loading"),
            Container(margin: EdgeInsets.only(left:10),),
            //CircularProgressIndicator(),
            SpinKitCircle(color: Colors.amber,)
          ],),),
      ),
    );
  }

  @override
  void changePassSuccess(bool res) {
    
  }

  @override
  void loginSuccess(UserInfo data) async{
    if(data!=null){
      UserInfo.userInfo=data;
      await db.setData(widget.username,DataKeyValue.username);
      await db.setData(widget.password,DataKeyValue.password);
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => LoginLoading()));
    }
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
  }

  @override
  void showMessage() {
    
  }

  @override
  void userInfogetSuccess(User user) {
    
  }

  @override
  void socialLoginSuccess(UserInfo data) {
    
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    
  }

}