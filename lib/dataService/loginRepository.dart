import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ypay/APIService/NetworkUtil.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class LoginRepostory{
  BuildContext context;
  LoginRepostory(this.context);
  var facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn=GoogleSignIn();
  NetworkUtil _netUtil = new NetworkUtil();
  var db=DBHelper();

  Future<UserInfo> initiateFacebookLogin() async {
    UserInfo fbData=new UserInfo();
    var facebookLoginResult =
        await facebookLogin.logIn(['email']);
      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
     switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        fbData.accessToken=fbData.email=fbData.imageUrl=fbData.name=fbData.loginWith=fbData.phone="";
        fbData.msg="Login Error";
        break;

      case FacebookLoginStatus.cancelledByUser:
        fbData.accessToken=fbData.email=fbData.imageUrl=fbData.name=fbData.loginWith=fbData.phone="";
        fbData.msg="Login Cancelled By User";
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),email&access_token=${facebookLoginResult
        .accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());
        fbData.accessToken=profile["id"].toString();
        fbData.name=fbData.fullname=profile["name"].toString();
        fbData.email=profile["email"].toString();
        fbData.imageUrl=profile['picture']['data']['url'].toString();
        fbData.msg="Login Success";
        fbData.loginWith="facebook";
        fbData.phone="phone";
        break;
    }
    return fbData;
  }

  Future<bool> fbSignOut() async{
    await facebookLogin.logOut();
  }

  Future<UserInfo> googleSignin() async{
    UserInfo info=new UserInfo();
    _googleSignIn = GoogleSignIn(scopes: ['email']);
    try{
      await _googleSignIn.signIn(); 
      info.accessToken=_googleSignIn.currentUser.id;
      info.name=info.fullname=_googleSignIn.currentUser.displayName;
      info.email=_googleSignIn.currentUser.email;
      info.imageUrl=_googleSignIn.currentUser.photoUrl;
      info.msg="Login Success";
      info.loginWith="google";
      info.phone="phone";
    }catch(e){
      info.name=info.email=info.imageUrl=info.loginWith=info.phone="";
      info.msg=e.toString();
      print(e.toString());
    }
    return info;
  }

  Future<bool> googleSingout() async{
   await _googleSignIn.signOut();
  }

  Future<dynamic> login({@required String username,@required String password,}) async {
    var url = "$backendUrl/token";
    var dataStr="username=${UserInfo.username}&password=${UserInfo.password}&grant_type=password";
    return getHeaders().then((myHeaders) {
      return _netUtil.post(this.context,url, headers:myHeaders, body:
      dataStr
      ).then((http.Response response) async {
        //print(response.statusCode);
        if(response.statusCode==200){
          var obj = json.decode(response.body);//["data"];
          UserInfo info=new UserInfo();
          if(obj==null){
            info.msg="Error occurred";
            return null; 
          }
          info=UserInfo.fromJson(obj);
          info.imageUrl=info.imageUrl==null?"imageURl":info.imageUrl;
          info.msg="Login Success";
          info.loginWith="username";
          await db.setData(info.accessToken,DataKeyValue.token);
          return info;
        }
        else{
          ErrorMessage errorMessage=new ErrorMessage();
          var obj=json.decode(response.body);
          errorMessage=ErrorMessage.fromJson(obj);
          return errorMessage; 
        }
      });
    });
  }

  Future<UserInfo> socialToken({@required String username,@required String password,String imageUrl,String loginWith}) async {
    var url = "$backendUrl/token";
    var dataStr="username=${UserInfo.username}&password=${UserInfo.password}&grant_type=password";
    return getHeaders1().then((myHeaders) {
      return _netUtil.post(this.context,url, headers:myHeaders, body:
      dataStr
      ).then((http.Response response) async {
        print(response.statusCode);
        var obj = json.decode(response.body);//["data"];
        UserInfo info=new UserInfo();
        if(obj==null){
          info.msg="Error occurred";
          return null; 
        }
        info=UserInfo.fromJson(obj);
        info.imageUrl=imageUrl;
        info.msg="Login Success";
        info.loginWith=loginWith;
        await db.setData(info.accessToken,DataKeyValue.token);
        return info;
      });
    });
  }

  Future<User> getUserInfo({String username,String password,String remember})async{
    var url="$backendUrl/api/usersubmit/user_login?user_name=$username&password=$password&remember=$remember";
    return getHeaders().then((myHeaders){
      return _netUtil.post(this.context,url, headers:myHeaders).then((http.Response response) async {
        var obj=json.decode(response.body);
        if(obj!=null){
          var jsonData=json.decode(obj);
          User user=new User();
          try{
            user=User.fromJson(jsonData);
            return user;
          }catch(ex){
            print(ex.toString());
            return null;
          }
        }
        else{
          return null;
        }
      });
    });
  }

  Future<bool> changeUserPassword({String oldpass,String newpass,int userId}){
    try{
      var url="$backendUrl/api/usersubmit/user_password_edit?old_password=$oldpass&new_password=$newpass&user_id=$userId";
      return getHeaders().then((myHeaders){
        return _netUtil.post(this.context,url, headers:myHeaders).then((http.Response response) async {
          var obj=json.decode(response.body);
          if(obj!=null){
            var data=json.decode(obj);
            if(data["status"]==0){
              return false;
            }
            else{
              return true;
            }
          }
          else{
            return false;
          }
        });
      });
    }catch(ex){
      print(ex);
      return null;
    }
  }

  Future<User> getUserInfoById({String userId})async{
    var url="$backendUrl/api/usersubmit/user_get_model_by_id?user_id=$userId";
    return getHeaders().then((myHeaders){
      return _netUtil.post(this.context,url, headers:myHeaders).then((http.Response response) async {
        var obj=json.decode(response.body);
        if(obj!=null){
          var jsonData=json.decode(obj);
          User user=new User();
          try{
            user=User.fromJson(jsonData);
            return user;
          }catch(ex){
            print(ex.toString());
            return null;
          }
        }
        else{
          return null;
        }
      });
    });
  }

  

}