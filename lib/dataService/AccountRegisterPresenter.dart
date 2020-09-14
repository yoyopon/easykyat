import 'package:flutter/material.dart';
import 'package:ypay/dataService/AccountRegisterRepository.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/userInfo.dart';

abstract class AccountRegisterContract{
  void showError(String msg);
  void showMessage(String msg);
  void getTempTokenSuccess(bool res);
  void getPhoneCodeSuccess(ResponseModel res);
  void codeVerifySuccess(ResponseModel res);
  void createAccountSuccess(ResponseModel success);
  void getuserTypeCodesuccess(ResponseModel model);
  void getUserRepasswordSuccess(ResponseModel model);
}

class AccountRegisterPresenter{
  AccountRegisterContract _contract;
  AccountRegisterRepostory _repostory;
  var db=DBHelper();

  AccountRegisterPresenter(AccountRegisterContract loginContract,BuildContext context){
    this._contract=loginContract;
    this._repostory=new AccountRegisterRepostory(context);
  }
  
  void getTempToken({String username,String password}){
    _repostory.getTempToken(uname: username,upass: password).then((res){
      if(res==true){
        _contract.getTempTokenSuccess(res);
      }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void getPhoneCode({String mobile}){
    _repostory.getPhoneCode(mobile:mobile).then((res){
      if(res.status=="1"){
       //_contract.showMessage(res.msg.toString());
       _contract.getPhoneCodeSuccess(res);
     }
     if(res.status=="0"){
       _contract.showError(res.msg.toString());
     }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void codeVerify({String mobile,String code}){
    _repostory.codeVerify(mobile:mobile,code: code).then((res){
      if(res.status=="1"){
       //_contract.showMessage(res.msg.toString());
       _contract.codeVerifySuccess(res);
     }
     if(res.status=="0"){
       _contract.showError(res.msg.toString());
     }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void createAccount(){
    _repostory.createAcc().then((res){
      if(res.status=="1"){
       _contract.showMessage(res.msg.toString());
       _contract.createAccountSuccess(res);
     }
     if(res.status=="0"){
       _contract.showError(res.msg.toString());
     }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void getUserTypeCode({String username,String type}){
    _repostory.getUserCode(username:username,type: type).then((res){
     if(res.status=="1"){
       //_contract.showMessage(res.msg.toString());
        _contract.getuserTypeCodesuccess(res);
     }
     if(res.status=="0"){
       _contract.showError(res.msg.toString());
     }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void userRepassword({String code,String password}){
    _repostory.userRepassword(code:code,pass: password).then((res){
      if(res.status=="1"){
       _contract.showMessage(res.msg.toString());
       _contract.getUserRepasswordSuccess(res);
     }
     if(res.status=="0"){
       _contract.showError(res.msg.toString());
     }
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

}