import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/Providers/appLanguage.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/userInfo.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  
  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);

    languageChange(String newlng){
      if(newlng==UserInfo.userInfo.userLanguage){
        return;
      }
      else{
        appLanguage.changeLanguage(
          newlng=='mm'?new Locale('mm'):
          (newlng=='zh'?new Locale('zh'):new Locale('en')));
        Phoenix.rebirth(context);
      }
    }

    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.6,
            title: Center(child: Text(AppLocalizations.of(context).translate("changelan"),style: TextStyle(color: Colors.black,fontSize: 15),),),
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              Navigator.pop(context);
            },),
          ),
          body: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(padding: EdgeInsets.only(top:10),),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right:10),
                      width: MediaQuery.of(context).size.width*1/7,
                      child: Image.asset('icons/flags/png/us.png', package: 'country_icons'),
                    ),
                    Text("English",style: TextStyle(fontSize: 16),),
                    Expanded(flex: 2,child: Container(),),
                    UserInfo.userInfo.userLanguage=="en"?Icon(Icons.check_box,):Icon(Icons.check_box,color: Colors.white,)
                  ],),
                ),
                onTap: (){
                  languageChange("en");
                },
              ),
              Divider(color: Colors.grey,),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right:10),
                      width: MediaQuery.of(context).size.width*1/7,
                      child: Image.asset('icons/flags/png/mm.png', package: 'country_icons')),
                    Text("မြန်မာ",style: TextStyle(fontSize: 16),),
                    Expanded(flex: 2,child: Container(),),
                    UserInfo.userInfo.userLanguage=="mm"?Icon(Icons.check_box,):Icon(Icons.check_box,color: Colors.white,)
                  ],),
                ),
                onTap: (){
                  languageChange("mm");
                },
              ),
              Divider(color: Colors.grey,),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right:10),
                      width: MediaQuery.of(context).size.width*1/7,
                      child: Image.asset('icons/flags/png/cn.png', package: 'country_icons')),
                    Text("中文",style: TextStyle(fontSize: 16),),
                    Expanded(flex: 2,child: Container(),),
                    UserInfo.userInfo.userLanguage=="zh"?Icon(Icons.check_box,):Icon(Icons.check_box,color: Colors.white,)
                  ],),
                ),
                onTap: (){
                  languageChange("zh");
                },
              ),
              Divider(color: Colors.grey,),
            ],),
          ),
        ),
      ),
    );
  }

}