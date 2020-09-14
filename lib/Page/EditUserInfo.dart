import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/EditUserInfoPresenter.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:ypay/model/userInfo.dart';

class EditPhone extends StatefulWidget {
  @override
  _EditPhoneState createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> implements EditUserInfoContract{

  TextEditingController phoneController=TextEditingController();
  User newUser=User();bool deviceInfoLoading=true;bool locationLoading=true;bool editLoading=false;
  String deviceId;
  String gpsLocation;
  EditUserInfoPresenter presenter;
  String userId;

  @override
  void initState() {
    presenter=EditUserInfoPresenter(this, context);
    newUser=User.users;
    userId=newUser.id.toString();
    getCurrentLocationData().then((s){
      setState(() {
        locationLoading=false;
      });
    });
    getDeviceDetails().then((s){
      setState(() {
        deviceInfoLoading=false;
      });
    });
    super.initState();
  }

  Future<void> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceId = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor;//UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    setState(() {});
  }

  //getLocation
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Future<void> getCurrentLocationData() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
        gpsLocation="${_locationData.latitude.toString()},${_locationData.longitude.toString()}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.6,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              Navigator.pop(context);
            },),
            title: Center(child: Text(AppLocalizations.of(context).translate("editphone"),style: TextStyle(fontSize: 15),),),
          ),
          body: SingleChildScrollView(
            child: 
            locationLoading==true||deviceInfoLoading==true||editLoading==true?
            Center(child: SpinKitChasingDots(color: Colors.orange[500])):
            Container(
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical:20),
                  child: Text(AppLocalizations.of(context).translate("entermobile1"))),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*2/3,
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
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*1/20,),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(vertical:20),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.orange[500]),
                    child: InkWell(
                      child: Text(AppLocalizations.of(context).translate("updatephone"),style: TextStyle(color: Colors.white),),
                      onTap: (){
                        editUser();
                      },
                    ),
                  ),
                ),
                //Text("device id:$deviceId \nlocationData:$gpsLocation")
              ],),
            ),
          ),
        ),
      ),
    );
  }

  editUser(){
    newUser.gpsLocation=gpsLocation;
    newUser.deviceId=deviceId;
    newUser.mobile=phoneController.text;
    newUser.useLang=UserInfo.userInfo.userLanguage;
    newUser.area="Myanmar";
    newUser.address="Myanmar";
    print(newUser);
    presenter.editUserInfo(user1: newUser);
  }

  @override
  void editUserInfoSuccess(ResponseModel1 model) {
    phoneController.clear();
    presenter.getUserInfo(uid:userId);
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context, "", msg);
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }

  @override
  void getUserInfoByIdSuccess(User user) {
    if(user!=null){
      User.users=user;
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => BottomTabBar()));
    }
  }
}