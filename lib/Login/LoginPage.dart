import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/Login/LoginLoadingPage.dart';
import 'package:ypay/Login/SocialLoginUserInfo.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/Providers/appLanguage.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/dataService/loginPresenter.dart';
import 'package:ypay/designUI/EyeIcon.dart';
import 'package:ypay/Login/CreateAcc.dart';
import 'package:ypay/Login/ForgetPassword.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/model/Languages.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget{
  LoginPageState createState()=>LoginPageState();
}

class LoginPageState extends State<LoginPage> with LoginContract{

  bool loginLoading=false;
  GlobalKey<FormState> formKey=new GlobalKey<FormState>();
  TextEditingController _userIdentity=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  bool _obscureText = true;
  LoginPresenter _presenter;
  String rdnLanguage;
  static Locale styleLocale;
  var db=DBHelper();

  List<Languages> lgnList=[
    Languages(flag: Image.asset('icons/flags/png/mm.png', package: 'country_icons'), name:"MM - Burmese"),
    Languages(flag:Image.asset('icons/flags/png/cn.png', package: 'country_icons'),name: "CN - Chinese"),
    Languages(flag:Image.asset('icons/flags/png/us.png', package: 'country_icons'),name: "EN - English"),
  ];

  @override
  void initState() {
    getLocale();
    getHeaders().then((res){
      print(res);
    });
    _presenter=new LoginPresenter(this, context);
    super.initState();
  }

  getLocale() async{
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      styleLocale=prefs.getString("language_code")==null?Locale('en'):Locale(prefs.getString("language_code"));
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    //final navigatorKey = GlobalKey<NavigatorState>();
    Languages languages;

    void popupChange(Languages newlng){
      setState(() {
        languages=newlng;
        appLanguage.changeLanguage(
          languages.name=='MM - Burmese'?new Locale('mm'):
          (languages.name=='CN - Chinese'?new Locale('zh'):new Locale('en')));
        print(languages.name);
        Phoenix.rebirth(context);
      });
    }

    Languages getInitialLanguage(){
      Languages languages=new Languages();
      if(styleLocale==Locale('mm')){
        languages=lgnList[0];
      }
      if(styleLocale==Locale('zh')){
        languages=lgnList[1];
      }
      if(styleLocale==Locale('en')){
        languages=lgnList[2];
      }
      return languages;
    }

    Widget img=Padding(
      padding: EdgeInsets.all(13),
    child:  
    styleLocale==Locale('zh')?
    Image.asset('images/chinaRound.png',):
    (styleLocale==Locale('mm')?Image.asset('images/mmRound.png'):Image.asset('images/usaRound.png'))
    );

    return MaterialApp(
      theme: PageTheme.getThemeData(),
      //navigatorKey: navigatorKey,
       home:styleLocale==null?CircularProgressIndicator():
        SafeArea(
          child: Scaffold(
          appBar: AppBar(
            elevation: 0.9,
            actions: <Widget>[
             Visibility(
               visible: !loginLoading,
              child: PopupMenuButton(
                    child: img,
                     initialValue: getInitialLanguage(),
                     itemBuilder: (BuildContext context){
                       return lgnList.map((Languages lng){
                         return PopupMenuItem(
                           value: lng,
                           child: Row(children: <Widget>[
                             Padding(
                               padding: const EdgeInsets.only(right:5),
                               child: Container(
                                 width: MediaQuery.of(context).size.width*1/10,
                                 height: MediaQuery.of(context).size.height*1/20,
                                 child: lng.flag),
                             ),
                             Text(lng.name,)
                           ],),
                         );
                       }).toList();
                     },
                     onSelected: (Languages newlng){
                       popupChange(newlng);
                     },
                   ),
             ),
          ],),
          body: 
          loginLoading==true?
            Center(
              child: SpinKitChasingDots(
                color: Colors.orange[500],
                size: 50.0,
              ),
            ):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:20.0,vertical:10.0),
              child: Form(
                key: formKey,
                child: showList(),
              ),
            ),
          ),
      ),
        )
    );
  }

  Widget showList(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height*1/7,
          child: Center(
            child: Text(AppLocalizations.of(context).translate("welcome"),
              style: TextStyle(color: Colors.black45,fontSize: 23),
              ),
          ),
        ),
        userName(),
        password(),
        SizedBox(height: MediaQuery.of(context).size.height*1/15,),
        loginButton(),
        SizedBox(height: MediaQuery.of(context).size.height*1/35,),
        nextLinksText(),
        orDivider(),
        openWithButton()
      ],
    );
  }

  ///For UserName TextBox
  Widget userName(){
    return Container(
      height: MediaQuery.of(context).size.height*1/10,
      child: TextFormField(
        controller: _userIdentity,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_box,color: Colors.orange[400]),
            hintText: AppLocalizations.of(context).translate("username"),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)
            )
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  ///For Password TextBox
  Widget password(){
    return Container(
      height: MediaQuery.of(context).size.height*1/10,
      child: TextFormField(
        controller: _password,
        obscureText: _obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange[400]),
            hintText: AppLocalizations.of(context).translate("pass"),
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              onPressed: _toggle,
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

  ///For Login Buttom
  Widget loginButton(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*1/13,
      child: RaisedButton(
        onPressed:() async {
          if(_userIdentity.text==""||_password.text==""||_userIdentity.text.length==0||_password.text.length==0)
          {
            MessageHandel.showError(context,"",AppLocalizations.of(context).translate("loginerror"),);
            _password.clear();
          }
          else
          {
            userLogin();
          }

        },
        color: Colors.orange[500],
        child: Text(AppLocalizations.of(context).translate("login"),style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 15.0),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(32.0),
            side: BorderSide(color:Colors.orange[500],)
        ),
      ),
    );
  }

  // String getTimeStamp(){
  //   String dateFormat=DateFormat('yyyyddMMhhmmssmmm').format(DateTime.now()).toString();
  //   return dateFormat;
  // }
  String dateFormat=DateFormat('yyyyddMMhhmmssmmm').format(DateTime.now()).toString();

  String findEvenDigits(String name){
    String evenDigits="";
    for (var i = 0; i < name.length; i++) {
      if(i%2==1){
        evenDigits=evenDigits+name[i];
      }
    }
    return evenDigits;
  }

  String getMD5val(){
    //getTimeStamp();
    var bytes = utf8.encode(_userIdentity.text);
    var username =UserInfo.username= base64.encode(bytes);
    var bytes1 = utf8.encode(_password.text);
    var password = UserInfo.password=base64.encode(bytes1);
    String text=findEvenDigits(dateFormat)+":"+username+":"+password;
    String md5Res=md5.convert(utf8.encode(text)).toString();
    print("timestamp:"+dateFormat+"username:"+username+"--password:"+password+"--xsign:"+md5Res);
    return md5Res;
  }

  userLogin()async{
    await db.setData(dateFormat, DataKeyValue.xtimeStamp);
    await db.setData(getMD5val(), DataKeyValue.xsign);
    _presenter.loginWithUserName(username: _userIdentity.text,password: _password.text);
    setState(() {
      loginLoading=true;
    });
  }

  ///For Forget Password Link @ Create New Account
  Widget nextLinksText(){
    return Container(
      height: MediaQuery.of(context).size.height*1/14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
                AppLocalizations.of(context).translate("forgetpass"),
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>ForgetPassword(),)
              );
            },
          ),
          Text('|'),
          FlatButton(
            child: Text(
              AppLocalizations.of(context).translate("createbtn"),
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAcc()));
            },
          ),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

  ///For 'OR' Text Divider
  Widget orDivider() {
    Size size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      height: MediaQuery.of(context).size.height*1/15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              AppLocalizations.of(context).translate("or"),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  ///For Open With FaceBook & Google & WeChat
  Widget openWithButton()
  {
    return Container(
      height: MediaQuery.of(context).size.height*1/10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
              onTap: (){
                setState(() {
                  loginLoading=true;
                });
                _presenter.loginWithFacebook();
              },
              child: Container(
               // margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color:Colors.grey
                  ),
                ),
                child: Image(image: AssetImage('images/faces.jpg'),
                  height:MediaQuery.of(context).size.height*1/20 ,),
              )
          ),
          GestureDetector(
              onTap: (){
                
              },
              child: Container(
               // margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color:Colors.grey
                  ),
                ),
                child: Image(image: AssetImage('images/wechat.png'),
                  height:MediaQuery.of(context).size.height*1/25,),
              )
          ),
          GestureDetector(
              onTap: (){
                _presenter.loginWithGoogleAcc();
                setState(() {
                  loginLoading=true;
                });
              },
              child: Container(
               // margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color:Colors.grey
                  ),
                ),
                child: Image(image: AssetImage('images/google.jpg'),
                  height:MediaQuery.of(context).size.height*1/25,),
              )
          )
        ],
      ),
    );
  }

  socialLogin(String userName,String password,{String fullName,String imageUrl,String loginWith})async{
    await db.setData(dateFormat, DataKeyValue.xtimeStamp);
    await db.setData(md5ForSocial(userName,password), DataKeyValue.xsign);
    await db.setData(fullName, DataKeyValue.fullname);
    await db.setData(imageUrl, DataKeyValue.imgUrl);
    _presenter.getSocialToken(imageUrl: imageUrl,loginWith: loginWith);
    setState(() {
      loginLoading=true;
    });
  }

  String md5ForSocial(String uname,String upass){
    var bytes = utf8.encode(uname);
    var username =UserInfo.username= base64.encode(bytes);
    var bytes1 = utf8.encode(upass);
    var password = UserInfo.password=base64.encode(bytes1);
    String text=findEvenDigits(dateFormat)+":"+username+":"+password;
    String md5Res=md5.convert(utf8.encode(text)).toString();
    print("timestamp:"+dateFormat+"username:"+username+"--password:"+password+"--xsign:"+md5Res);
    return md5Res;
  }

  @override
  void loginSuccess(UserInfo data) async{
    if(data!=null){
      if(data.loginWith=="username"){
        UserInfo.userInfo=data;
        await db.setData(_userIdentity.text,DataKeyValue.username);
        await db.setData(_password.text,DataKeyValue.password);
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => LoginLoading()));
      }
      if(data.loginWith=="google"){
        socialLogin(data.email, "ggid@${data.accessToken}",fullName: data.fullname,imageUrl: data.imageUrl,loginWith: data.loginWith);
      }
      if(data.loginWith=="facebook"){
        socialLogin(data.email, "fbid@${data.accessToken}",fullName: data.fullname,imageUrl: data.imageUrl,loginWith: data.loginWith);
      }
    }
    loginLoading=false;
    setState(() {
      
    });
  }

  @override
  void dispose() {
    _userIdentity.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void showError(String msg) {
    print(msg);
    MessageHandel.showError(context, "", msg);
    setState(() {
        loginLoading=false;
      });
    _userIdentity.clear();_password.clear();
  }

  @override
  void showMessage() {
  }

  @override
  void userInfogetSuccess(User user) {
    
  }

  @override
  void changePassSuccess(bool res) {
    
  }

  @override
  void socialLoginSuccess(UserInfo data) async{
    UserInfo.userInfo=data;
    // await db.setData(data.name,DataKeyValue.username);
    // await db.setData(_password.text,DataKeyValue.password);
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => SocialLoginUserInfo(userId: data.userId,)));
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    
  }
}

