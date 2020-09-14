import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/Login/VerifyPhone.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/AccountRegisterPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class PhoneAuthfromFG extends StatefulWidget {
  PhoneAuthfromFGState createState() => PhoneAuthfromFGState();
}
//not using
class PhoneAuthfromFGState extends State<PhoneAuthfromFG> implements AccountRegisterContract{
  String pageInfo;
  TextEditingController phoneController = TextEditingController();
  AccountRegisterPresenter _presenter;
  var db=DBHelper();
  String tempUserName="";String tempPassword="";
  bool loading=false;
  String dateFormat=DateFormat('yyyyddMMhhmmssmmm').format(DateTime.now()).toString();

  @override
  void initState() {
    _presenter=AccountRegisterPresenter(this, context);
    phoneController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
          home: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
                  Navigator.pop(context);
                },),
                title: Text(AppLocalizations.of(context).translate("phoneauth"),
                    style: TextStyle(color: Colors.black,fontSize: 15)),
              ),
              body: Center(
                child: 
                loading==true?SpinKitPulse(color: Colors.cyan,):
                 Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: showList(),
                      ),
              ),
            ),
          ));
  }

  ///For ShowList
  Widget showList() {
    return ListView(
      children: <Widget>[
        mobileText(),
        SizedBox(height: 30.0),
        phoneNumber(),
        SizedBox(height: 50.0),
        nextButtom()
      ],
    );
  }

  ///For Mobile Text
  Widget mobileText() {
    return Container(
      child: Text(AppLocalizations.of(context).translate("entermobile"),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20)
      ),
    );
  }

  ///For Phone Number TextBox
  Widget phoneNumber() {
    return Container(
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone, color: Colors.orange[400]),
            hintText: AppLocalizations.of(context).translate("phone"),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }

  userTempLogin()async{
   UserRegister.userRegister.sMobile=phoneController.text;
    //User.users.mobile=phoneController.text;
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
      child: RaisedButton(
        color: Colors.orange[500],
        onPressed: () {
          userTempLogin();
          setState(() {
            loading=true;
          });
        },
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
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
    setState(() {
        loading=false;
      });
  }

  @override
  void showMessage(String msg) {
    
  }

  @override
  void getTempTokenSuccess(bool res) {
    if(res==true){
      _presenter.getPhoneCode(mobile:phoneController.text);
    } 
  }

  @override
  void getPhoneCodeSuccess(ResponseModel res) {
    print(phoneController.text);
      phoneController.clear();
      setState(() {
        loading=false;
      });
      Navigator.push(context,MaterialPageRoute(builder: (context)=>VerifyPhone()));
  }

  @override
  void codeVerifySuccess(ResponseModel res) {
    
  }

  @override
  void createAccountSuccess(ResponseModel success) {
    
  }

  @override
  void getUserRepasswordSuccess(ResponseModel success) {
    
  }

  @override
  void getuserTypeCodesuccess(ResponseModel success) {
    
  }
}


