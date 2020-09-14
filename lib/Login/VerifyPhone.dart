import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:ypay/Login/LoginAfterReset.dart';
import 'package:ypay/dataService/AccountRegisterPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class VerifyPhone extends StatefulWidget {
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> implements AccountRegisterContract{
  String codeText="";
  AccountRegisterPresenter _presenter;
  bool loading=false;
  var db=DBHelper();

  @override
  void initState() {
    _presenter=AccountRegisterPresenter(this,context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
          title: Center(child: Text("Verify Phone",style: TextStyle(fontSize: 15),)),
        ),
        body: SingleChildScrollView(child: Container(
          child: Center(
            child: 
            loading==true?SpinKitPulse(color: Colors.cyan,):
            Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:20),
                padding: EdgeInsets.all(10),
                child: Text("Enter verification code send to your phone"),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                padding: EdgeInsets.all(10),
                child: new VerificationCodeInput(
                  itemDecoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.orange))),
                  keyboardType: TextInputType.number,
                  length: 6,
                  onCompleted: (String value) {
                    print(value);
                    codeText=value;
                  },
                ),
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(top:20),
                  padding: EdgeInsets.all(10),
                  child: Text("Didn't receive?Send Again"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),color: Colors.orange[500]
                ),
                child: InkWell(
                  child: Text("Register Your Account",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    if(codeText!=""&&codeText.length==6){
                      //_presenter.codeVerify(mobile:User.users.mobile,code:codeText);
                      _presenter.codeVerify(mobile:UserRegister.userRegister.sMobile,code:codeText);
                      setState(() {
                        loading=true;
                      });
                    }
                  },
                ),
              )
            ],),
          ),
        ),),
      ),),
    );
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
    setState(() {
      loading=false;
    });
    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>CreateAcc()));
  }

  @override
  void showMessage(String msg) {
    
  }

  @override
  void getTempTokenSuccess(bool res) {
    
  }

  @override
  void getPhoneCodeSuccess(ResponseModel res) {
    
  }

  @override
  void codeVerifySuccess(ResponseModel res) {
    _presenter.createAccount();
  }

  void removeTempKeys()async{
    await db.setData("",DataKeyValue.token);
    await db.setData("",DataKeyValue.xsign);
    await db.setData("",DataKeyValue.xtimeStamp);
  }

  @override
  void createAccountSuccess(ResponseModel success) {
    MessageHandel.showMessage(context, "","Create Account Success");
      removeTempKeys();
      setState(() {
        loading=false;
      });
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
        LoginAfterReset(username: UserRegister.userRegister.sUserName,password: UserRegister.userRegister.sPassword),));
       // LoginAfterReset(username: User.users.userName,password: User.users.password),));
  }

  @override
  void getUserRepasswordSuccess(ResponseModel success) {
    
  }

  @override
  void getuserTypeCodesuccess(ResponseModel success) {
    
  }
}