import 'dart:io';

class UserInfo{
  String accessToken;
  String userId;
  String name;
  String fullname;
  String email;
  String imageUrl;
  String msg;
  String loginWith;
  String phone;
  String userLanguage;

  UserInfo({this.accessToken,this.userId,this.name,this.fullname,this.email,this.imageUrl,this.msg,this.loginWith,this.phone,this.userLanguage});

  //static String prevFormsgPage;
  static UserInfo userInfo;
  static File fileImage;
  static bool hideBottomBar=false;
  static String locationData;
  static String deviceId;
  static String username="";
  static String password="";

  Map<String, dynamic> toJson() {
  var map = Map<String, dynamic>();
  map['access_token'] = accessToken;
  map['user_id']=userId;
  map['userName'] = name;
  map['fullName']=fullname;
  map['email'] = email;
  map['img_url'] = imageUrl;
  map['msg'] = msg;
  map['loginWith'] = loginWith;
  map['phone'] = phone;
  return map;
}

UserInfo.fromJson(Map<String, dynamic> map)
    : accessToken = map['access_token'],
      userId = map['user_id'],
      name = map['userName'],
      fullname = map['fullName'],
      email = map['email'],
      imageUrl = map['img_url'],
      msg = map['msg'],
      loginWith = map['loginWith'],
      phone = map['phone'];

}

class ResponseModel{
  String status;
  String time;
  String msg;

  ResponseModel({this.status,this.time,this.msg});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    time = json['time'].toString();
    msg = json['msg'].toString();
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data["time"]=this.time;
    data["msg"]=this.msg;
    return data;
   }
}

class ResponseModel1 {
  int status;
  String msg;

  ResponseModel1({this.status, this.msg});

  ResponseModel1.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }
}

class ErrorMessage {
  String error;
  String errorDescription;

  ErrorMessage({this.error, this.errorDescription});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorDescription = json['error_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['error_description'] = this.errorDescription;
    return data;
  }
}