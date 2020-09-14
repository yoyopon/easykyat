import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/dataService/loginPresenter.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class SocialLoginUserInfo extends StatefulWidget {
  SocialLoginUserInfo({this.userId}):super();
  final String userId;
  
  @override
  _SocialLoginUserInfoState createState() => _SocialLoginUserInfoState();
}

class _SocialLoginUserInfoState extends State<SocialLoginUserInfo> implements LoginContract{

  LoginPresenter _presenter;

  @override
  void initState() {
    _presenter=LoginPresenter(this,context);
    getUserInfo();
    super.initState();
  }

  getUserInfo(){
    _presenter.getUserInfo(uid: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SpinKitFadingCircle(color: Colors.orange[500]),
          ),
        ),
      ),
    );
  }

  @override
  void changePassSuccess(bool res) {
    
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    if(user!=null){
      User.users=user;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => BottomTabBar()));
    }
  }

  @override
  void loginSuccess(UserInfo data) {
    
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
  }

  @override
  void showMessage() {
    
  }

  @override
  void socialLoginSuccess(UserInfo data) {
    
  }

  @override
  void userInfogetSuccess(User user) {
    
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
}