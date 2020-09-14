import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/userInfo.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Color gradientStart = Colors.blue[400]; //Change start gradient color here
  Color gradientEnd = Colors.orange[500]; //Change end gradient color here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.6,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
            title: Center(
              child: Text(AppLocalizations.of(context).translate("myprofile"),
                  style: TextStyle(color: Colors.black,fontSize: 15),),
            ),
          ),
          body: Column(
            children: <Widget>[
              ClipPath(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*1/3,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [gradientStart, gradientEnd],
                        begin: const FractionalOffset(1, 0.0),
                        end: const FractionalOffset(0.0, 1),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Center(
                      child: Stack(
                        alignment: const Alignment(0.5, 0.5),
                        children: [
                          UserInfo.fileImage!=null?
                          Container(
                            width: MediaQuery.of(context).size.width*1/2.5,
                            height: MediaQuery.of(context).size.height*1/5,
                            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),
                            child: Image.file(UserInfo.fileImage,fit: BoxFit.fill,),
                          ):
                          CircleAvatar(
                            backgroundImage: 
                            (UserInfo.userInfo.imageUrl=="imageURl"||UserInfo.userInfo.imageUrl==""?AssetImage('images/default-avatar.jpg'):NetworkImage(UserInfo.userInfo.imageUrl)),
                            radius: 70,
                          ),
                        ],
                      ),
                    )
                ),
                clipper: CustomClipPath(),
              ),
              // userName(),
              // email(),
              // phonenumber(),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: EdgeInsets.only(top:10),
                child: Table(children: [
                  TableRow(children: [
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context).translate("fullName")+":",textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(UserInfo.userInfo.fullname),
                    ),)
                  ]),
                  TableRow(children: [
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context).translate("email")+":",textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(UserInfo.userInfo.email),
                    ),)
                  ]),
                  TableRow(children: [
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context).translate("username")+":",textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(UserInfo.userInfo.phone),
                    ),)
                  ])
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///For Username Text
  userName() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height*1/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(AppLocalizations.of(context).translate("fullName"),)),
              Container(
                child: Text(UserInfo.userInfo.name),
              )
            ],
          ),
        ),
      );

  ///For Email Text
  email() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
         // height: MediaQuery.of(context).size.height*1/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(AppLocalizations.of(context).translate("email"))),
              Container(
                child: Text(UserInfo.userInfo.email),
              )
            ],
          ),
        ),
      );

  ///For Phone Number Text
  phonenumber() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Container(
         width: MediaQuery.of(context).size.width,
         // height: MediaQuery.of(context).size.height*1/7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(AppLocalizations.of(context).translate("username"))),
              Container(
                child: Text(UserInfo.userInfo.phone),
              )
            ],
          ),
        ),
      );

  ///For Horizonal Divider
  horizonaldivider() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
         width: MediaQuery.of(context).size.width,
          color: Colors.black,
        ),
      );

}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
