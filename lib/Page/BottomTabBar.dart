import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:ypay/Page/AccountProfile.dart';
import 'package:ypay/Page/AllMeterList.dart';
import 'package:ypay/Page/AllPaidMeterList.dart';
import 'package:ypay/Page/AllTopUpHistory.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/Providers/BottomNavigationBarProvider.dart';
import 'package:ypay/Providers/appLanguage.dart';
import 'package:ypay/dataService/bottomBarPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/NotificationMessage.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class BottomTabBar extends StatefulWidget {
  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> with BottomBarContract{
   bool userLoading=false;bool lngLoading=false;
   BottomBarPresenter _presenter;
   int cartItemCount=0;
   var db=DBHelper();
   PageController _pageController;
   int _selectedIndex=0;
   
  @override
  void initState() {
    _presenter=new BottomBarPresenter(this, context);
    _pageController = PageController();
    getUserInfo();
    super.initState();
    getMessageCount();
  }

  getUserInfo(){
    _presenter.getUserData();
    setState(() {
      userLoading=true;
    });
  }

  getUser(){
    _presenter.getUserData();
    setState(() {
      userLoading=true;
    });
  }

  getMessageCount(){
    _presenter.getMsgCount();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => AppLanguage(),
      child: Consumer<AppLanguage>(builder: (context, model, child){
      return MaterialApp(
        theme: PageTheme.getThemeData(),
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
        home: Scaffold(
          //body:currentTab[provider.currentIndex],
          body: 
          //UserInfo.userInfo==null?
          userLoading==true?
          SpinKitDoubleBounce(
              color: Colors.orange[500],
              size: 50.0,
            ):
          SizedBox.expand(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
              },
              children: <Widget>[
                AllMeterList(),AllPaidMeterLists(),AllTopUpHistory(),UserProfile()
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 0,left: 0,right: 0,top: 8),
            child: 
            UserInfo.hideBottomBar==false?
            BottomNavigationBar(
              showUnselectedLabels: true,
              selectedItemColor: Colors.orange[500],
              elevation: 0.7,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.animateToPage(index,duration: Duration(milliseconds: 200), curve: Curves.easeInCubic);
                });
              },
                items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.list,),
                  title: new Text("Meters",style: TextStyle(fontSize: 10),),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.attach_money,),
                  title: new Text("Paid",style: TextStyle(fontSize: 10),),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.change_history,),
                  title: new Text("TopUp",style: TextStyle(fontSize: 10),),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.person,),
                  title: new Text(AppLocalizations.of(context).translate("acc"),style: TextStyle(fontSize: 10),),
                ),
              ],
            ):Container()
          ),
        ),
      );
    }),
    );
  }

  @override
  void loadUserSuccess(UserInfo data) {
    if(data!=null){
      UserInfo.userInfo=data;
      
    }
    _presenter.getUser();
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context, "", msg.toString());
  }

  @override
  void loadUser(User data) {
    if(data!=null){
      User.users=data;
      // for (var i = 0; i < GroupId.group.length; i++) {
      //   if(User.users.groupId==GroupId.group[i].id){
      //     GroupId.groupName=GroupId.group[i].name;
      //   }
      // }
    }
    setState(() {
      userLoading=false;
    });
  }

  @override
  void msgCountSuccess(MessageCount msgCount) {
    setMsgCount(msgCount);
  }

  setMsgCount(MessageCount msg)async{
    await db.setData(msg.allCount, DataKeyValue.allmsgCount);
    await db.setData(msg.unreadCount, DataKeyValue.unreadCount);
  }
 }




