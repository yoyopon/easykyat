import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ypay/Login/PhoneAuthfromF&G.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/EyeIcon.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';

class CreateAcc extends StatefulWidget{
  CreateAccState createState()=>CreateAccState();
}

class CreateAccState extends State<CreateAcc>{
  final _fullname=TextEditingController();
  final _password=TextEditingController();
  final _conpassword=TextEditingController();
  bool _obscureText=true;
  bool _obscureText1=true;
  var db=DBHelper();

  //getLocation
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  void getCurrentLocationData() async {
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
        UserRegister.userRegister.sGpsLocation="${_locationData.latitude.toString()},${_locationData.longitude.toString()}";
       // User.users.gpsLocation=
      });
    });
  }

  //device_info
  String deviceName;
  String deviceVersion;
  String identifier;
  String deviceBrand;
  String deviceProduct;
  Future<List<String>> getDeviceDetails() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceProduct = build.product;
        deviceBrand = build.manufacturer;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
        UserRegister.userRegister.sDeviceId = identifier;
        //User.users.deviceId=identifier;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;
        UserRegister.userRegister.sDeviceId = identifier; //UUID for iOS
       //User.users.deviceId=identifier;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    //if (!mounted) return;
    setState(() {});
    return [deviceName, deviceVersion, identifier];
  }

  @override
  void initState() {
    UserRegister.userRegister=new UserRegister();
   // User.users=new User();
    getDeviceDetails();
    getCurrentLocationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
        home: SafeArea(
          child: Scaffold(
          appBar: AppBar(
            title:  Text(AppLocalizations.of(context).translate("create"),
            style: TextStyle(color: Colors.black,fontSize: 15)
            ),
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.of(context).pop();},),
          ),
          body: Center(
            child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: showList(),
            ),
          ),
      ),
        ),
    );
  }

  ///ShowList
  Widget showList(){
    return ListView(
      children: <Widget>[
        SizedBox(height: 20.0),
        iconPerson(),
        SizedBox(height: MediaQuery.of(context).size.height*1/20,),
        fullName(),
        SizedBox(height: MediaQuery.of(context).size.height*1/30,),
        password(),
        SizedBox(height: MediaQuery.of(context).size.height*1/30,),
        conPassword(),
        SizedBox(height: MediaQuery.of(context).size.height*1/20,),
        confirmButtom(),
      ],
    );
  }

///For Header Icon
  Widget iconPerson(){
    return Container(
      child: Icon(Icons.account_circle,color: Colors.orange[400],size: 100.0,),
    );
  }

  String dropdownValue = "Standard";
  List<String> dropdownItems1 = [
    "Standard",
    "Advanced Level",
    "Intermediate Level",
    "Diamond Level"
  ];

  ///for member group
  Widget memberGroup() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Icon(Icons.people, color: Colors.orange[400]),
          Text(
            'Member Group',
            style: TextStyle(fontSize: 16),
          ),
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: dropdownItems1.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  ///For FullName TextBox
Widget fullName(){
    return Container(
      child: TextFormField(
        controller: _fullname,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box,color: Colors.orange[400]),
          hintText: AppLocalizations.of(context).translate("fullName"),
          hintStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          )
        ),
      ),
    );
}

///for toggle
  void toggle(){
    setState(() {
      _obscureText=!_obscureText;

    });
  }

  ///For Password TextBox
  Widget password(){
    return Container(
      child: TextFormField(
        controller: _password,
        obscureText: _obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key,color: Colors.orange[400]),
            hintText: AppLocalizations.of(context).translate("pass"),
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
          if (_fullname.text.length > 0 && _password.text.length > 0 && _conpassword.text.length > 0) {
            UserRegister.userRegister.sUserName=_fullname.text;
            UserRegister.userRegister.sPassword=_password.text;
            UserRegister.userRegister.iGroupId=2;
            // User.users.userName=_fullname.text;
            // User.users.password=_password.text;
            // User.users.groupId=2;
            Navigator.push(context,MaterialPageRoute(builder: (context) => PhoneAuthfromFG(),));
            _fullname.clear();_password.clear();_conpassword.clear();
          }else{
            showDialog(context: context,
              builder: (context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  contentPadding: EdgeInsets.only(top: 10.0),
                  title: Text("Please.... Enter Your Information to register your account.",style: TextStyle(fontFamily: "pyidaungsu", color: Colors.red),),
                  actions: <Widget>[
                    FlatButton(child: Text("OK",style: TextStyle(color: Colors.black),),
                      onPressed: (){Navigator.pop(context);
                        _fullname.clear();_password.clear();_conpassword.clear();
                      },
                    )
                  ],
                );
              }
            );
          }
        },
        child: Text(AppLocalizations.of(context).translate("confirm"),
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ) ,
    );
}

}