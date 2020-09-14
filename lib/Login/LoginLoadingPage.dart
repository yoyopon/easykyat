import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/dataService/loginPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class LoginLoading extends StatefulWidget {
  @override
  _LoginLoadingState createState() => _LoginLoadingState();
}

class _LoginLoadingState extends State<LoginLoading> implements LoginContract{
  bool loginUserInfoLoading=false;
  LoginPresenter _loginPresenter;

  getUserLoginInformation()async{
    String username=await db.getData(DataKeyValue.username);
    String password=await db.getData(DataKeyValue.password);
    String text="yoyopon1";
    String text1="88771234";
    var encrypt = await FlutterDes.encrypt(password, text, iv: text1);
    var result=base64Encode(encrypt);
    print("result:$result");
    _loginPresenter.testLoginResult(username: username,password: result,remember: "");
    setState(() {
      loginUserInfoLoading=true;
    });
  }

  @override
  void initState() {
    _loginPresenter=new LoginPresenter(this, context);
    getUserLoginInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          body: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text("Logging In"),
            Container(margin: EdgeInsets.only(left:10),),
            //CircularProgressIndicator(),
            SpinKitCircle(color: Colors.amber,)
          ],),),
        ),
      ),
    );
  }

  @override
  void loginSuccess(UserInfo data) {
    
  }

  @override
  void showError(String msg) {
    
  }

  @override
  void showMessage() {
    
  }

  @override
  void userInfogetSuccess(User user) {
    if(user!=null){
      User.users=user;
      for (var i = 0; i < GroupId.group.length; i++) {
        if(User.users.groupId==GroupId.group[i].id){
          GroupId.groupName=GroupId.group[i].name;
        }
      }
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => BottomTabBar()));
    }
    setState(() {
      loginUserInfoLoading=false;
    });
  }

  @override
  void changePassSuccess(bool res) {
    
  }

  @override
  void socialLoginSuccess(UserInfo data) {
    
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    
  }
}

class GroupId{
  int id;
  String name;
  GroupId({this.id,this.name});
  static List<GroupId> group=[
    new GroupId(id: 1,name: "Standard"),
    new GroupId(id: 2,name: "Advanced Level"),
    new GroupId(id: 3,name: "Intermediate Level"),
    new GroupId(id: 4,name: "Diamond Level"),
  ];
  static String groupName="";
}