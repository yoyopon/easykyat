import 'dart:core';
import 'dart:io';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Page/notificationDetail.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/EditUserInfoPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/NotificationMessage.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class ProfilePhotoChange extends StatefulWidget {
  @override
  _ProfilePhotoChangeState createState() => _ProfilePhotoChangeState();
}

class _ProfilePhotoChangeState extends State<ProfilePhotoChange> implements EditUserInfoContract {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;ImagePicker picker=ImagePicker();DBHelper db=DBHelper();String prev;
  Notifications msg1=new Notifications();int prevmsgCount=0;
  EditUserInfoPresenter presenter;
  User newUser=new User();
  String userId;
  bool updateLoading=false;

  void takePhoto()async{
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image=File(pickedFile.path);
    });
    if(_image!=null){
      cropImage(_image);
    }
  }

  void choosePhoto()async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image=File(pickedFile.path);
    });
    if(_image!=null){
      cropImage(_image);
    }
  }

  updatePhoto(){
    db.updatePhoto(UserInfo.userInfo, _image).then((success){
      if(success==true){
        newUser.avatar=_image.path;
        presenter.editUserInfo(user1: newUser);
      }
    }).catchError((e){
      MessageHandel.showError(context, "Profile Change Failed", e.toString());
    });
    
    setState(() {
      updateLoading=true;
    });
  }

  saveMessage(){
    String curDate=DateFormat.yMMMMd('en_US').add_jm().format(DateTime.now()).toString();
    msg1=new Notifications(
      msgid: prevmsgCount++,action: "New Profile Change",title: "New Account Profile Change",
      contents: "Successfully Changed Account Profile Picture",notiDate: curDate,imageUrl: _image.toString(),isRead: "false");
    db.setMessageData(msg1).then((success){
      if(success==true){
        Notifications.notifications=new Notifications();
        Notifications.notifications=msg1;
        showNotification();
      }
    }).catchError((msg){
      MessageHandel.showError(context,"", msg);
    });
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX:300.0,ratioY:150.0),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    );
    if(croppedFile!=null){
      _image=croppedFile;
      UserInfo.fileImage=_image;
      _scaffoldKey.currentState.hideCurrentSnackBar();
      updatePhoto();
    }
    //MessageHandel.showNotificationMessage(context, "YPAY", "Change Profile Picture Success");
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabBar()));
    setState(() {
      
    });
   // _showDailyAtTime();
  // scheduleNotification();
  }

  //flutter notification plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    presenter=EditUserInfoPresenter(this, context);
    newUser=User.users;
    userId=newUser.id.toString();
    super.initState();
    prev="";
    getMsgCount();
    initNotification();
  }

  getMsgCount()async{
    String msg=await db.getData(DataKeyValue.allmsgCount);
    prevmsgCount=int.parse(msg);
    setState(() {
      
    });
  }

  initNotification(){
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    //var android = new AndroidInitializationSettings('@mipmap/ypay)icon');
    var android = new AndroidInitializationSettings('ypay_icon');
    var iOS = new IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Ok'),
                onPressed: ()  {
                  Navigator.pop(context);
                },
              )
            ],
          ),
    );
  }

  Future onSelectNotification(String payload) async{
    if(prev==""){}
    else{
      Navigator.push(context, MaterialPageRoute
          (builder: (context)=>NotificationDetail(messageDetail:Notifications.notifications)));
    }
  }

  showNotification() async {
    var android= AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High,playSound: true, ticker: 'ticker');
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    var result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    await flutterLocalNotificationsPlugin.show(
        0, 'YPAY', msg1.title, platform,
        payload: 'Default_Sound');
    prev="show";
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      styleInformation: MediaStyleInformation(),importance: Importance.Max, priority: Priority.High, ticker: 'ticker'
    );
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
    prev="media";
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("flutter_devs"),
        largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
        contentTitle: 'flutter devs',
        htmlFormatContentTitle: true,
        summaryText: 'summaryText',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
    prev="pic";
  }

  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'flutter_devs',importance: Importance.Max, priority: Priority.High, ticker: 'ticker',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    prev="schedule";
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
  Future<void> _showDailyAtTime() async {
    var time = Time(14, 28, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
        time,
        platformChannelSpecifics);
    prev="daily";
  }
  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabBar()));
              Navigator.pop(context);
            },),
            title: Center(child: Text(AppLocalizations.of(context).translate("pic"),style:TextStyle(color: Colors.black,fontSize: 15),))
            ,),
            body: SingleChildScrollView(
              child: 
              updateLoading==true?
              Center(child: SpinKitChasingDots(color: Colors.orange[500],),):
              Container(child: Column(
                children: <Widget>[
                Padding(padding: EdgeInsets.only(top:50),),
                Center(
                  child: Container(
                    //width: MediaQuery.of(context).size.width*7/10,
                    padding: EdgeInsets.symmetric(horizontal:10.0),
                    height: MediaQuery.of(context).size.height*2/5,
                    //decoration: BoxDecoration(border: Border.all(color:Colors.black)),
                    child: 
                    UserInfo.fileImage!=null?Image.file(UserInfo.fileImage):
                    Image(
                      image: 
                      (UserInfo.userInfo.imageUrl=="imageURl"||UserInfo.userInfo.imageUrl==""||UserInfo.userInfo.imageUrl==null?
                      AssetImage('images/default-avatar.jpg')
                      :NetworkImage(UserInfo.userInfo.imageUrl)),
                      //ExactAssetImage(_image.path),
                      fit: BoxFit.fill,  
                    )
                  ),
                ),
                Padding(padding: EdgeInsets.only(top:50),),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(AppLocalizations.of(context).translate("changepic"),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                  onPressed: (){
                    final snackBar = SnackBar(
                      duration: Duration(minutes: 10),
                      content: Container(
                        height: MediaQuery.of(context).size.height*1.3/5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                          InkWell(child: Container(
                            height: MediaQuery.of(context).size.height*1/15,
                            width: MediaQuery.of(context).size.width,
                            child: Center(child: Text(AppLocalizations.of(context).translate("takepic"),style: TextStyle(fontFamily: "pyidaungsu",color: Colors.white),))),
                          onTap: (){takePhoto();},
                          ),
                          Divider(color: Colors.white,),
                          InkWell(child: Container(
                            height: MediaQuery.of(context).size.height*1/15,width: MediaQuery.of(context).size.width,
                            child: Center(child: Text(AppLocalizations.of(context).translate("choosepic"),style: TextStyle(fontFamily: "pyidaungsu",color: Colors.white),))),
                          onTap: (){choosePhoto();},
                          ),
                          Divider(color: Colors.white,),
                          InkWell(child: Container(
                            height: MediaQuery.of(context).size.height*1/15,width: MediaQuery.of(context).size.width,
                            child: Center(child: Text(AppLocalizations.of(context).translate("cancel"),style: TextStyle(fontFamily: "pyidaungsu",color: Colors.white),))),
                          onTap: (){_scaffoldKey.currentState.hideCurrentSnackBar();},
                          ),
                        ],),
                      )
                    );

                    _scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  color: Colors.orange[400],
                )
              ],),),
            ),
        ),
      ),
    );
  }

  @override
  void editUserInfoSuccess(ResponseModel1 model) {
    saveMessage();
    presenter.getUserInfo(uid:userId);
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    if(user!=null){
      User.users=user;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => BottomTabBar()));
    }
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context, "", msg);
    setState(() {
      updateLoading=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }
}