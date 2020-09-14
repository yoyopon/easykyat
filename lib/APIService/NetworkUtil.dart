import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ypay/designUI/MessageHandel.dart';

class NetworkUtil {

  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;
  Future<http.Response> get(BuildContext context,String url, Map headers) async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{
          return http.get(url, headers: headers).then((http.Response response) {
            return handleResponse(context,response);
          });
        }catch(ex){
          showError(context, "Check your internet connection");
        }
      }
    } on SocketException catch (_) {
      showError(context, "Check your internet connection");
    }
  }

  Future<http.Response> post(BuildContext context,String url, {Map headers, body,encoding}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          return http
              .post(url, body: body, headers: headers,encoding: encoding)
              .then((http.Response response) {
            return handleResponse(context, response);
          });
        }catch(ex){
          showError(context, "Check your internet connection");
        }
      }
    } on SocketException catch (_) {
      showError(context, "Check your internet connection");
    }
  }

  Future<http.Response> delete(BuildContext context,String url, {Map headers}) async {

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{
          return http
              .delete(
            url,
            headers: headers,
          )
              .then((http.Response response) {
            return handleResponse(context,response);
          });
        }catch(ex){
          showError(context, "Check your internet connection");
        }
      }
    } on SocketException catch (_) {
      showError(context, "Check your internet connection");
    }
  }

  Future<http.Response> put(BuildContext context,String url, {Map headers, body, encoding}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        try{
          return http
              .put(url, body: body, headers: headers, encoding: encoding)
              .then((http.Response response) {
            return handleResponse(context, response);
          });
        }catch(ex){
          showError(context, "Check your internet connection");
        }
      }
    } on SocketException catch (_) {
      showError(context, "Check your internet connection");
    }


  }

  http.Response handleResponse(BuildContext context,http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode == 401) {
      showError(context,"sys_unauthrized");
      return null;
    }
    if (statusCode == 403) {
      //throw new Exception("403");
      return response;
    }
    if (statusCode == 404) {
      showError(context,"Not found");
      return null;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    if (statusCode == 405) {
      showError(context,"Access right limited");
      return null;
      //throw new Exception("Unauthorized or Logout then login again");
    }
    else if (statusCode == 400) {
      String msg="";
      if(response.body==null || response.body.toString()==""){
        showError(context,"server error");
        return null;
      }
      var body = json.decode(response.body);

      msg=body["error_description"];

       msg=msg==null||msg==""?body["Message"]:msg;
      if(msg!=null && msg.isNotEmpty) {
        showError(context,msg);
        return null;

      }
      if(msg==null){
        showError(context,"sys_usernameOrPasswordIncorrect");
        return null;
      }
      showError(context,"sys_errorFeachData");
    }
    else if (statusCode != 200) {
      var body = json.decode(response.body);
      String msg=body["error_description"];
      msg=msg==null||msg==""?body["Message"]:msg;
      if(msg!=null && msg.isNotEmpty) {
        showError(context,msg);
        return null;
      }
      showError(context,"sys_errorFeachData");
      return null;
    }

    return response;
  }



  void showError(BuildContext context,String errorMsg){
    //throw new Exception(errorMsg);
    // Scaffold.of(context).showSnackBar(new SnackBar(
    //   content: new Text(errorMsg),
    //   duration: new Duration(seconds: 5),
    // ));
    MessageHandel.showError(context, "", errorMsg);
  }
  
}