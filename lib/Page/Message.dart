
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Page/notificationDetail.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/NotificationMessage.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var db=DBHelper();
  List<Notifications> msgLists=[];bool msgLoading=true;

  @override
  void initState() {
    getMsgCount();
    super.initState();
  }

  getMsgCount()async{
    db.getAllMsgs().then((res){
      msgLists=res;
      for (var i = 0; i < msgLists.length; i++) {
        getImageUrl(msgLists[i]);
      }
      setState(() {
        msgLoading=false;
      });
    }).catchError((msg){
      MessageHandel.showMessage(context, "", "There is no notification");
      setState(() {
        msgLoading=false;
      });
    });
    
  }

  getImageUrl(Notifications msg){
    if(msg.imageUrl.contains("File")){
        int fIndex=msg.imageUrl.indexOf('/');
        int lIndex=msg.imageUrl.lastIndexOf("'");
        String filePath=msg.imageUrl.substring(fIndex,lIndex);
        msg.imageUrl=filePath;
      }
      setState(() {
        
      });
  }

  deleteNoti(){
    setState(() {
      msgLoading=true;
    });
    db.deleteNotification().then((success){
      if(success==true){
        MessageHandel.showMessage(context, "", "Successfully Clear AllNotificaions");
      }
      else{
        MessageHandel.showError(context, "", "Deletion Error");
      }
      setState(() {
        msgLoading=true;
      });
    }).catchError((e){
      setState(() {
        msgLoading=true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void gotoDetailPage(Notifications msg){
      Navigator.push(context, MaterialPageRoute
        (builder: (context)=>NotificationDetail(messageDetail:msg)));
    }

    return WillPopScope(
      onWillPop: () async=>false,
      child: MaterialApp(
        theme: PageTheme.getThemeData(),
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.4,
              title: Center(child: Text(AppLocalizations.of(context).translate("msg"), style: TextStyle(color: Colors.black,fontSize: 15),)),
              leading: IconButton(icon: Icon(Icons.clear),onPressed: (){
               // Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomTabBar()));
              },),
              actions: <Widget>[
                Visibility(
                  visible: msgLists.length==0?false:true,
                  child: IconButton(icon: Icon(Icons.delete_outline),
                  onPressed: (){
                    deleteNoti();
                  },),
                )
              ],
            ),
            body: msgLoading==true||msgLists.length==0?
              Center(child: Text(AppLocalizations.of(context).translate("nonoti")),):
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context,i){
                        return AnimationConfiguration.staggeredList(
                          position: i,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                margin: EdgeInsets.only(bottom:5.0),
                                decoration: BoxDecoration(border: Border.all(color:msgLists[i].isRead=="false"?Colors.blue:Colors.grey,width: msgLists[i].isRead=="false"?1.5:0.8),borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      //Icon(Icons.check_circle_outline,color:msgLists[i].isRead=="false"?Colors.orange[500]:Colors.grey,size: 30,),
                                      CircleAvatar(backgroundImage: FileImage(File(msgLists[i].imageUrl)),radius: 25,),
                                      Padding(
                                        padding: const EdgeInsets.only(left:13.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                          Text(msgLists[i].action,style:msgLists[i].isRead=="false"?
                                            TextStyle(color: Colors.black):TextStyle(color: Colors.grey),),
                                          Text(msgLists[i].notiDate,style:msgLists[i].isRead=="false"?
                                            TextStyle(color: Colors.black):TextStyle(color: Colors.grey),
                                          )
                                        ],),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                    gotoDetailPage(msgLists[i]);
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: msgLists.length,
                    ),
                  ),
                ),
              )

          ),
        ),
      ),
    );
  }
}
