import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:ping_discover_network/ping_discover_network.dart';

class MessageHandel{


 static showMessage(BuildContext context,String title,String msg){
   Flushbar(
     flushbarPosition:FlushbarPosition.TOP,
     flushbarStyle: FlushbarStyle.FLOATING,
     margin: EdgeInsets.only(top: 300.0,left: 10.0,right: 10.0),
     message: msg,
     duration:  Duration(seconds: 3),
     backgroundColor:Colors.black38,
     icon: Icon(
       Icons.info,
       color: Colors.white,
     ),
   )..show(context);
 }

 static showNotificationMessage(BuildContext context,String title,String msg){
   Flushbar(
     flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(20),
      borderRadius: 8,
      duration:  Duration(seconds: 3),
      backgroundGradient: LinearGradient(
        colors: [Colors.orange.shade800, Colors.orange.shade700],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: title,
      message: msg,
    )..show(context);
 }

 static hideDialog(BuildContext context){

    

 }
 static showError(BuildContext context,String title,String msg){
   Flushbar(
     flushbarPosition:FlushbarPosition.TOP,
     flushbarStyle: FlushbarStyle.FLOATING,
     margin: EdgeInsets.only(top: 200.0,left: 10.0,right: 10.0),
     message: msg,
     duration:  Duration(seconds: 3),
     backgroundColor:Colors.red.withOpacity(0.9),
     icon: Icon(
       Icons.info,
       color: Colors.white,
     ),
   )..show(context);

 }

}