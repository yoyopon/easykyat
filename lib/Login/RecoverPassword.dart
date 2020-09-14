import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:ypay/Login/LoginAfterReset.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/AccountRegisterPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/userInfo.dart';

class RecoverPassword extends StatefulWidget {
  final String username;
  RecoverPassword({this.username}):super();
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> implements AccountRegisterContract{
  final passController=new TextEditingController();
  String codeText="";
  AccountRegisterPresenter _presenter;
  var db=DBHelper();
  bool loading=false;
  String password="";

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
            leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
            title: Center(child: Text(AppLocalizations.of(context).translate("resetpass"),style: TextStyle(fontSize: 15),),),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: 
              loading==true?SpinKitPulse(color: Colors.orange[500],):
              Column(children: <Widget>[
                Container(
                margin: EdgeInsets.only(top:30),
                padding: EdgeInsets.only(top:10,bottom: 5),
                child: Text("Enter verification code send to your phone"),
              ),
                Container(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Container(
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
                  )
                ],),),
                Container(margin: EdgeInsets.all(10),),
                Container(
                  width: MediaQuery.of(context).size.width*2/3,
                  child: TextFormField(
                    controller: passController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_box, color: Colors.orange[500]),
                        prefixStyle: TextStyle(color: Colors.grey),
                        hintText: AppLocalizations.of(context).translate("newpass"),
                        hintStyle: TextStyle(color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
                Container(margin: EdgeInsets.only(bottom:50),),
                Container(
                    width: MediaQuery.of(context).size.width*2/3,
                    child: RaisedButton(
                      color: Colors.orange[500],
                      onPressed: () {
                        if(codeText!=""&&codeText.length==6){
                          resetpassword();
                        }
                        else{
                          MessageHandel.showError(context,"", "Code must be at least six numbers");
                        }
                      },
                      child: Text(AppLocalizations.of(context).translate("next"),
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
              ],),
            ),
          ),
        ),
      ),
    );
  }

  resetpassword(){
    if(passController.text!=""){
      _presenter.userRepassword(code:codeText,password:passController.text);
      setState(() {
        password=passController.text;
        loading=true;
      });
    }
    else{
      MessageHandel.showError(context, "", "Please enter a new password");
    }
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
    
  }

  void removeTempKeys()async{
    await db.setData("",DataKeyValue.token);
    await db.setData("",DataKeyValue.xsign);
    await db.setData("",DataKeyValue.xtimeStamp);
  }

  @override
  void getUserRepasswordSuccess(ResponseModel success) {
    MessageHandel.showMessage(context, "","Password Recover Success");
      removeTempKeys();
      setState(() {
        loading=false;
      });
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
        LoginAfterReset(username: widget.username,password: password),));
    passController.clear();
  }

  @override
  void getuserTypeCodesuccess(ResponseModel success) {
    
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
    MessageHandel.showMessage(context,"", msg);
  }
}