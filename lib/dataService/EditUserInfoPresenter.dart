import 'package:flutter/material.dart';
import 'package:ypay/dataService/AccountRegisterRepository.dart';
import 'package:ypay/dataService/loginRepository.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

abstract class EditUserInfoContract{
  void showError(String msg);
  void showMessage(String msg);
  void editUserInfoSuccess(ResponseModel1 model);
  void getUserInfoByIdSuccess(User user);
}

class EditUserInfoPresenter{
  EditUserInfoContract _contract;
  AccountRegisterRepostory _repostory;
  LoginRepostory _loginRepostory;
  var db=DBHelper();

  EditUserInfoPresenter(EditUserInfoContract loginContract,BuildContext context){
    this._contract=loginContract;
    this._repostory=new AccountRegisterRepostory(context);
    this._loginRepostory=new LoginRepostory(context);
  }

  void editUserInfo({User user1}){
    _repostory.editUserInfo(user: user1).then((res){
      if(res.status.toString()=="1"){
       _contract.showMessage(res.msg.toString());
       _contract.editUserInfoSuccess(res);
     }
     if(res.status.toString()=="0"){
       _contract.showError(res.msg.toString());
     }
    //  else{
    //    _contract.showError(res.toString());
    //  }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void setUserInformation(User res){
    db.setUserInformation(res).then((success){
      if(success==true){
        _contract.getUserInfoByIdSuccess(res);
      }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void getUserInfo({String uid}){
    _loginRepostory.getUserInfoById(userId: uid).then((res){
      setUserInformation(res);
    }).catchError((e){
      
    });
  }

}