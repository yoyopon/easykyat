
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/Login/RecoverPassword.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/AccountRegisterPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/userInfo.dart';

class ForgetPassword extends StatefulWidget{
  ForgetPasswordState createState()=>ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> implements AccountRegisterContract{
  ///yym
  final phoneController=new TextEditingController();
  String userName="";
  AccountRegisterPresenter _presenter;
  var db=DBHelper();
  String tempUserName="";String tempPassword="";
  bool loading=false;
  String dateFormat=DateFormat('yyyyddMMhhmmssmmm').format(DateTime.now()).toString();

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  void initState() {
    _presenter=AccountRegisterPresenter(this, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
            title:  Center(
              child: Text(AppLocalizations.of(context).translate("find"),style: TextStyle(color: Colors.black,fontSize: 15),
              ),
            ),
          ),
          body: loading == true
                    ? Center(
                      child: SpinKitRotatingCircle(
                          color: Colors.orange[500],
                          size: 50.0,
                        ),
                    )
                    : SingleChildScrollView(
                      child: showList(),
                    ),
        ),
      ),
    );
  }

  ///For ShowList
Widget showList(){
  return Center(
    child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height*1/10),
        phoneNumber(),
        SizedBox(height: 50.0),
        nextButtom(),
      ],
    ),
  );
}

///For Phone Number TextBox
  Widget phoneNumber() {
    return Container(
      width: MediaQuery.of(context).size.width*3.5/5,
      child: TextFormField(
        controller: phoneController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_box, color: Colors.orange[500]),
            prefixStyle: TextStyle(color: Colors.grey),
            hintText: AppLocalizations.of(context).translate("username"),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }

  userTempLogin()async{
    await db.setData(dateFormat, DataKeyValue.xtimeStamp);
    await db.setData(getMD5val(), DataKeyValue.xsign);
    _presenter.getTempToken(username: tempUserName,password: tempPassword);
  }

  String getMD5val(){
    var bytes = utf8.encode("pretoken0101");
    tempUserName=base64.encode(bytes);
    var bytes1 = utf8.encode("kk!QAZ2wsx123");
    tempPassword=base64.encode(bytes1);
    String text=findEvenDigits(dateFormat)+":"+tempUserName+":"+tempPassword;
    String md5Res=md5.convert(utf8.encode(text)).toString();
    print("timestamp:"+dateFormat+"username:"+tempUserName+"--password:"+tempPassword+"--xsign:"+md5Res);
    return md5Res;
  }

  String findEvenDigits(String name){
    String evenDigits="";
    for (var i = 0; i < name.length; i++) {
      if(i%2==1){
        evenDigits=evenDigits+name[i];
      }
    }
    return evenDigits;
  }

  ///For Next Buttom
  Widget nextButtom() {
    return Container(
      width: MediaQuery.of(context).size.width*3/5,
      child: RaisedButton(
        color: Colors.orange[500],
        onPressed: () {
          if(phoneController.text!=""){
            userTempLogin();
            setState(() {
              loading=true;
            });
          }
        },//phoneSubmit(),
        child: Text(AppLocalizations.of(context).translate("next"),
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  @override
  void codeVerifySuccess(ResponseModel res) {
    
  }

  @override
  void createAccountSuccess(ResponseModel success) {
    
  }

  @override
  void getPhoneCodeSuccess(ResponseModel res) {
    
  }

  @override
  void getTempTokenSuccess(bool res) {
    setState(() {
      userName=phoneController.text;
    });
    _presenter.getUserTypeCode(username:phoneController.text,type: "mobile");
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
    setState(() {
      loading=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }

  @override
  void getUserRepasswordSuccess(ResponseModel success) {
    
  }

  @override
  void getuserTypeCodesuccess(ResponseModel success) {
    setState(() {
      loading=false;
    });
    print(phoneController.text);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>RecoverPassword(username:userName)));
    phoneController.clear();
  }
}