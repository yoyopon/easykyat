import 'package:flutter/material.dart';
import 'package:ypay/dataService/loginRepository.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

abstract class LoginContract{
  void showError(String msg);
  void showMessage();
  void loginSuccess(UserInfo data);
  void userInfogetSuccess(User user);
  void changePassSuccess(bool res);
  void socialLoginSuccess(UserInfo data);
  void getUserInfoByIdSuccess(User user);
}

class LoginPresenter{
  LoginContract _contract;
  LoginRepostory _repostory;
  var dbHelper = DBHelper();

  LoginPresenter(LoginContract loginContract,BuildContext context){
    this._contract=loginContract;
    this._repostory=new LoginRepostory(context);
  }
  
  void loginWithFacebook(){
    _repostory.initiateFacebookLogin().then((result){
      if(result!=null){
        switch(result.msg){
          case "Login Error": _contract.showError(result.msg);break;
          case "Login Cancelled By User": _contract.showError(result.msg);break;
          case "Login Success":
          // var dbHelper = DBHelper();
          // dbHelper.saveUserInfo(result);
          _contract.loginSuccess(result);break;
        }
      }
    }).catchError((e)
    {
      _contract.showError(e.toString());
    });
  }

  void loginWithGoogleAcc(){
    _repostory.googleSignin().then((result){
      if(result!=null){
        if(result.msg=="Login Success"){
          //dbHelper.saveUserInfo(result);
          _contract.loginSuccess(result);
        }
        else{
          _contract.showError(result.msg);
        }
      }
    }).catchError((onError){
      _contract.showError(onError.toString());
    });
  }

  void loginWithUserName({String username,String password}){
    _repostory.login(username: username, password: password).then((res){
      if(res!=null){
        if(res.msg=="Login Success"){
          var dbHelper = DBHelper();
          dbHelper.saveUserInfo(res);
          _contract.loginSuccess(res);
        }
        else{
          _contract.showError(res.msg);
        }
      }
    }).catchError((onError){
      _contract.showError(onError.toString());
    });
  }

  void getSocialToken({String username,String password,String imageUrl,String loginWith}){
    _repostory.socialToken(username: username, password: password,imageUrl: imageUrl,loginWith: loginWith).then((res){
      if(res!=null){
        if(res.msg=="Login Success"){
          dbHelper.saveUserInfo(res);
          _contract.socialLoginSuccess(res);
        }
        else{
          _contract.showError(res.msg);
        }
      }
    }).catchError((onError){
      _contract.showError(onError.toString());
    });
  }

  void testLoginResult({String username,String password,String remember}){
    _repostory.getUserInfo(username: username,password: password,remember: remember).then((result){
      dbHelper.setUserInformation(result);
      _contract.userInfogetSuccess(result);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void changePassword({String oldpass,String newpass,int userId}){
    _repostory.changeUserPassword(oldpass:oldpass,newpass:newpass,userId:userId).then((success){
      _contract.changePassSuccess(success);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void getUserInfo({String uid}){
    _repostory.getUserInfoById(userId: uid).then((res){
      dbHelper.setUserInformation(res);
      _contract.getUserInfoByIdSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

}