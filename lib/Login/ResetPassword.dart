import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/Login/LoginAfterReset.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/loginPresenter.dart';
import 'package:ypay/dataService/userProfilePresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/EyeIcon.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class ResetPassword extends StatefulWidget{
  ResetPasswordState createState()=>ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> implements LoginContract,UserProfileContract{

  var db=DBHelper();
  LoginPresenter _presenter;
  UserProfilePresenter _userProfilePresenter;
  final resetformKey=new GlobalKey<FormState>();
  final _oldpassword=new TextEditingController();
  final _password=new TextEditingController();
  final _conpassword=new TextEditingController();
  bool _obscureText=true;
  bool _obscureText1=true;
  bool _obscureText2=true;
  bool changepassLoading=false;
  String username;

  @override
  void initState() {
    username=User.users.userName;
    _presenter=LoginPresenter(this,context);
    _userProfilePresenter=UserProfilePresenter(this,context);
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
            title:  Center(child: Text(AppLocalizations.of(context).translate("resetpass"),style: TextStyle(color: Colors.black,fontSize: 15))),
          ),
          body: Center(
            child:
            changepassLoading==true?SpinKitDoubleBounce(color: Colors.grey,):
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Form(
                key: resetformKey,
                child: showList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///For ShowList
  Widget showList()
  {
    return ListView(
      children: <Widget>[
        mobileText(),
        SizedBox(height: MediaQuery.of(context).size.height*1/20),
        oldpassword(),
        SizedBox(height: MediaQuery.of(context).size.height*1/30),
        password(),
        SizedBox(height:MediaQuery.of(context).size.height*1/30),
        conPassword(),
        SizedBox(height: MediaQuery.of(context).size.height*1/20),
        confirmButtom(),
      ],
    );
  }

  ///For Text
  Widget mobileText()
  {
    return Container(
      child:  Text(AppLocalizations.of(context).translate("pleaseenter1"),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18)),

    );
  }

  ///for toggle
  void toggle(){
    setState(() {
      _obscureText=!_obscureText;

    });
  }

  ///For Password TextBox
  Widget oldpassword(){
    return Container(
      child: TextFormField(
        controller: _oldpassword,
        obscureText: _obscureText2,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange[500]),
            hintText: AppLocalizations.of(context).translate("pass"),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              onPressed: toggle2,
              icon: _obscureText2?Icon(MyFlutterApp.eye_slash_solid,size: 17,color: Colors.orange[400]):
              Icon(Icons.remove_red_eye,color: Colors.orange[500]),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            )
        ),
      ),
    );
  }

  Widget password(){
    return Container(
      child: TextFormField(
        controller: _password,
        textInputAction: TextInputAction.next,
        obscureText: _obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange[500]),
            hintText: AppLocalizations.of(context).translate("newpass"),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              onPressed: toggle,
              icon: _obscureText?Icon(MyFlutterApp.eye_slash_solid,size: 17,color: Colors.orange[400]):
              Icon(Icons.remove_red_eye,color: Colors.orange[500]),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            )
        ),
      ),
    );
  }

  void toggle2(){
    setState(() {
      _obscureText2=!_obscureText2;

    });
  }

  ///for toggle
  void toggle1(){
    setState(() {
      _obscureText1=!_obscureText1;

    });
  }

  ///For ConfirmPassword TextBox
  Widget conPassword(){
    return Container(
      child: TextFormField(
        controller: _conpassword,
        obscureText: _obscureText1,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange[400]),
            hintText: AppLocalizations.of(context).translate("confirmPass"),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              onPressed: toggle1,
              icon: _obscureText1?Icon(MyFlutterApp.eye_slash_solid,size: 17,color: Colors.orange[400]):
              Icon(Icons.remove_red_eye,color: Colors.orange[500]),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            )
        ),
      ),
    );
  }

  ///For Confirm Buttom
  Widget confirmButtom(){
    return Container(
      child: RaisedButton(
        color: Colors.orange[500],
        onPressed: (){
          if(_password.text.length==0||_oldpassword.text.length==0||_conpassword.text.length==0){
            MessageHandel.showError(context,"","Please enter your password");
            _password.clear();_oldpassword.clear();_conpassword.clear();
          }else{
            if(_password.text!=_conpassword.text){
              MessageHandel.showError(context,"","Your password should be the same with confirm password");
              _password.clear();_oldpassword.clear();_conpassword.clear();
            }else{
              _presenter.changePassword(oldpass:_oldpassword.text,newpass: _password.text,userId: User.users.id);
              setState(() {
                changepassLoading=true;
              });
            }
          }
        },
        child: Text(AppLocalizations.of(context).translate("confirm"),
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ) ,
    );
  }

  @override
  void loginSuccess(UserInfo data) async{
    
  }

  @override
  void showError(String msg) {
    print(msg);
    MessageHandel.showError(context, "","Error changin password");
    setState(() {
        changepassLoading=false;
      });
    _oldpassword.clear();_password.clear();_conpassword.clear();
  }

  @override
  void showMessage() {
    
  }

  @override
  void userInfogetSuccess(User user) {

  }

  @override
  void changePassSuccess(bool res) {
    if(res==true){
      _userProfilePresenter.logOut();
    }
  }

  @override
  void deleteSuccess() {
    _userProfilePresenter.deleteFromDB1(); 
  }

  @override
  void logOutSuccess() {
    _userProfilePresenter.deleteFromDB();
  }

  removeKeys()async{
    UserInfo.fileImage=null;
    User.users=null;
    UserInfo.userInfo=UserInfo.username=UserInfo.password=UserInfo.fileImage=null;
    await db.setData("",DataKeyValue.token);
    await db.setData("",DataKeyValue.xsign);
    await db.setData("",DataKeyValue.xtimeStamp);
    await db.setData("",DataKeyValue.allmsgCount);
  }

  @override
  void removeSuccess() {
    _userProfilePresenter.deleteMessageTable();
  }

  @override
  void socialLoginSuccess(UserInfo data) {
    
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    
  }

  @override
  void notideleteSuccess() {
    removeKeys(); 
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginAfterReset(username: username,password: _password.text),));
    setState(() {
        changepassLoading=false;
    });
  }

  
}