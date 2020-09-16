import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ypay/Login/LoginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/Providers/BottomNavigationBarProvider.dart';
import 'package:ypay/Providers/appLanguage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'dbHelper/DatabaseHelper.dart';
import 'model/userInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(
    Phoenix(
      child: MyApp(appLanguage: appLanguage)
    )
  );
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;
  MyApp({this.appLanguage});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider<AppLanguage>(create: (_) => AppLanguage(),),
      ChangeNotifierProvider<BottomNavigationBarProvider>(create: (_) => BottomNavigationBarProvider(),),
      ],
      child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
           supportedLocales: [
             Locale('en', 'US'),
             Locale('mm', 'MM'),
             Locale('zh', 'CN'),

           ],
           localizationsDelegates: [
             AppLocalizations.delegate,
             GlobalMaterialLocalizations.delegate,
             GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate
           ],
           title: 'Flutter Demo',
           debugShowCheckedModeBanner: false,
           theme: ThemeData(
             primarySwatch: Colors.blue,
           ),
           home: //LoginPage()
           //userInfo!=null?BottomTabBar():LoginPage(),
           Splashscreen()
            );
        }
      ),
    );  
  }
}

class Splashscreen extends StatefulWidget {

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  UserInfo info;
  void getUserInfo()async{
    var dbHelper = DBHelper();
    dbHelper.getUserInfo().then((res){
      info=res;
    });
  }

  @override
  void initState() {
    UserInfo.hideBottomBar=false;
    getUserInfo();
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => 
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => 
            info!=null?BottomTabBar():LoginPage()
        ))
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Text("YPAY",style: TextStyle(fontSize: 30,color: Colors.orange[500])),
            SpinKitFadingFour(color: Colors.orange[400],size: 30.0,),
          ],)
        ),
      ),
    );
  }
}




