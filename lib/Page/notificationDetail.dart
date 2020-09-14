import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/NotificationMessage.dart';

class NotificationDetail extends StatefulWidget {
  final Notifications messageDetail;
  NotificationDetail({this.messageDetail}):super();
  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  File image;var db=DBHelper();bool updateLoading=true;
  getImageUrl(){
    if(widget.messageDetail.imageUrl.contains("File")){
        int fIndex=widget.messageDetail.imageUrl.indexOf('/');
        int lIndex=widget.messageDetail.imageUrl.lastIndexOf("'");
        String filePath=widget.messageDetail.imageUrl.substring(fIndex,lIndex);
        image=File(filePath);
      }
      else{
       // image=File(widget.messageDetail.imageUrl);
      }
      setState(() {
        
      });
  }
  @override
  void initState() {
    getImageUrl();
    updateReadCount();
    super.initState();
  }

  void updateReadCount(){
     db.updateMessageRead(widget.messageDetail.msgid,"true").then((res){
       if(res==false){
         MessageHandel.showError(context,"", "An error occurred");
       }
     }).catchError((e){
       MessageHandel.showError(context,"", e.toString());
     });
     setState(() {
       updateLoading=false;
     });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(AppLocalizations.of(context).translate("notidetail"),style: TextStyle(color: Colors.black,fontSize: 15),)),
          leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context);
        },),),
        body: SingleChildScrollView(
          child: 
          updateLoading==true?SpinKitCubeGrid(color: Colors.orange[500],):
          Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:30),
              height: MediaQuery.of(context).size.height*1/4,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: 
              image!=null?
              Image.file(image,fit:BoxFit.fill):
              Image.file(File(widget.messageDetail.imageUrl),fit:BoxFit.fill)
              ),
            Container(
              height: MediaQuery.of(context).size.height*1/10,
              padding: EdgeInsets.all(10.0),child: Text(widget.messageDetail.title,style: TextStyle(fontSize: 20),),),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Table(
                children: [
                  TableRow(children: [
                    Container(child: Text("Processing Action : ",textAlign: TextAlign.end,),padding: EdgeInsets.all(5.0),),
                    Container(child: Text(widget.messageDetail.action,),padding: EdgeInsets.all(5.0),)
                  ]),
                  TableRow(children: [
                    Container(child: Text("Message : ",textAlign: TextAlign.end,),padding: EdgeInsets.all(5.0),),
                    Container(child: Text(widget.messageDetail.contents,),padding: EdgeInsets.all(5.0),)
                  ]),
                  TableRow(children: [
                    Container(child: Text("Processing Date : ",textAlign: TextAlign.end,),padding: EdgeInsets.all(5.0),),
                    Container(child: Text(widget.messageDetail.notiDate,),padding: EdgeInsets.all(5.0),)
                  ]),
                ],
              ),
            )
          ],),
        ),
      ),),
    );
  }
}