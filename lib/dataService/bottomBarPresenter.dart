import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/NotificationMessage.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

abstract class BottomBarContract{
  void showError(String msg);
  void loadUserSuccess(UserInfo data);
  void loadUser(User data);
  void msgCountSuccess(MessageCount msgCount);
}

class BottomBarPresenter{
  BottomBarContract _contract;
  var db=DBHelper();

  BottomBarPresenter(BottomBarContract loginContract,BuildContext context){
    this._contract=loginContract;
  }

  void getUserData(){
    String userlng="";
    getLocale().then((res){
        userlng=res;
    });
    db.getUserInfo().then((result){
      result.userLanguage=userlng;
      _contract.loadUserSuccess(result);
    }).catchError((e){
      _contract.showError(e);
    });
  }

  void getUser(){
    db.getUser().then((result){
      _contract.loadUser(result);
    }).catchError((e){
      _contract.showError(e);
    });
  }

  Future<String> getLocale()async {
    String lng;
    var prefs=await SharedPreferences.getInstance();
    switch (prefs.getString('language_code')) {
      case 'mm':lng='mm';break;
      case 'zh':lng='zh';break;
      default:lng='en';break;
    }
    return lng;
  }

  void getMsgCount()async{
    db.getMessageCount().then((count){
      _contract.msgCountSuccess(count);
    }).catchError((e){
      _contract.showError(e);
    });
  }

}