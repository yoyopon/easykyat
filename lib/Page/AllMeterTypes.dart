import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/MeterListPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/RequestBill.dart';
import 'package:ypay/model/User.dart';

class AllMeterType extends StatefulWidget {
  @override
  _AllMeterTypeState createState() => _AllMeterTypeState();
}

class _AllMeterTypeState extends State<AllMeterType> implements MeterBillListContract {

  MeterBillListPresenter presenter;
  List<MeterBind> meterBoundedList=new List<MeterBind>();
  TextEditingController meterNoText=TextEditingController();
  bool getBoundedList=false;bool searchBoundList=false;bool saveBindLoading=false;
  MeterBind newMeterToBind=new MeterBind();
  var db=DBHelper();
  bool onlineLoading=false;

  @override
  void initState() {
    presenter=MeterBillListPresenter(this, context);
    getCachedData();
    presenter.getBoundedList(userId:User.users.id.toString());
    super.initState();
  }

  getCachedData()async{
    setState(() {
      getBoundedList=true;
      onlineLoading=true;
    });
    String res=await db.getData(DataKeyValue.bindList);
    if(res==null||res==""){
      meterBoundedList=[];
    }
    else{
      List<dynamic> obj=json.decode(json.decode(res));
      if(obj!=null||obj.length>0){
        for (var i = 0; i < obj.length; i++) {
          meterBoundedList.add(MeterBind.fromJson(obj[i]));
          int unixTime=int.parse(meterBoundedList[i].expires.substring(6,19));
          meterBoundedList[i].expires=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
        }
      }
      setState(() {
        getBoundedList=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.4,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              Navigator.pop(context);
            },),
            title: Center(child: Text(AppLocalizations.of(context).translate("metertypes"),style: TextStyle(fontSize: 15),),),
          ),
          body: 
          getBoundedList==true||searchBoundList==true||saveBindLoading==true?
          Center(child: SpinKitChasingDots(color: Colors.orange[500],),):
          SingleChildScrollView(
            child: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Container(
                        //margin: EdgeInsets.symmetric(vertical:8),
                        padding: EdgeInsets.all(8),
                        child: Text(AppLocalizations.of(context).translate("yourmeters"),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                      ),
                      Expanded(flex: 2,child: Container(),),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Text("${meterBoundedList.length} Meters"))
                    ],),
                    onlineLoading==true?
                    Center(child: SpinKitCircle(color: Colors.grey,size: 15,),):Container(),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(top:7,left: 3,right: 3),
                      child: 
                      meterBoundedList.length==0?
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(AppLocalizations.of(context).translate("nobound")),):
                      AnimationLimiter(
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,
                                      border: Border.all(color:Colors.grey)),
                                    margin: EdgeInsets.only(bottom:5),
                                    padding: EdgeInsets.all(15),
                                    width: MediaQuery.of(context).size.width*3/4,
                                    child: Row(children: <Widget>[
                                      IconButton(icon: CircleAvatar(child: Text("M",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                          radius: 25,backgroundColor: Colors.orange[500],),
                                        onPressed: (){},),
                                      Container(
                                        padding: EdgeInsets.only(left:6),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(text: "Meter: ",style: TextStyle(color: Colors.black,fontFamily: "pyidaungsu")),
                                                  TextSpan(text: meterBoundedList[index].userName,style: TextStyle(color: Colors.red,fontFamily: "pyidaungsu",fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(vertical:5),
                                              width: MediaQuery.of(context).size.width*1.8/3,
                                              child: Text(meterBoundedList[index].oauthOpenid,style: TextStyle(fontSize: 13),)),
                                            Text("Expires in: "+meterBoundedList[index].expires,style: TextStyle(fontSize: 13),),
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 2,child: Container(),),
                                      Icon(Icons.more_vert)
                                    ],),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: meterBoundedList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange[500],
            child: Icon(Icons.add),
            onPressed: (){
              onlineLoading==true?printing():
              showDialog(context: context,
                builder: (context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  //contentPadding: EdgeInsets.only(top: 10.0),
                  elevation: 0.5,
                  title: Center(child: Container(
                    padding: EdgeInsets.symmetric(vertical:10),
                    child: Text(AppLocalizations.of(context).translate("addNew"),style: TextStyle(fontFamily: "pyidaungsu"),))),
                  content: Container(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.orange[500]),
                        padding: EdgeInsets.all(10),
                        child: InkWell(child: Text("Scan QR",style: TextStyle(fontFamily: "pyidaungsu",color: Colors.white),),
                          onTap: (){
                            Navigator.pop(context);
                            _scan();
                          },  
                      )),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.cyan),
                        padding: EdgeInsets.all(10),
                        child: InkWell(child: Text("Meter No",style: TextStyle(fontFamily: "pyidaungsu",color: Colors.white),),
                          onTap: (){
                            Navigator.pop(context);
                            showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                  title: Center(child: Text(AppLocalizations.of(context).translate("addNew1"),
                                    style: TextStyle(fontFamily: "pyidaungsu"),),),
                                  content: Container(
                                    padding: EdgeInsets.only(bottom:20,top:10),
                                    child: TextField(
                                      controller: meterNoText,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search,color: Colors.orange[500],),
                                        hintText: "Enter Meter No",
                                        labelText: "Meter No",
                                        labelStyle: TextStyle(fontFamily: "pyidaungsu",fontSize: 13,color: Colors.grey),
                                        hintStyle: TextStyle(fontFamily: "pyidaungsu"),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.orange[500])
                                        )
                                      ),
                                      onSubmitted: (text){
                                        if(text!=null&&text!=""){
                                          Navigator.pop(context);
                                          searchToBind(text,"meterNo");
                                        }
                                      },  
                                    ),
                                  ),
                              );
                          });
                        },  
                      ))
                    ],),),
                  );
                }
              );
            },
          ),
        ),
      ),
    );
  }

  printing(){
    print("Hello");
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    searchToBind(barcode,"customerNo");
  }

  searchToBind(String text,String type){
    print(text);
    presenter.searchToBind(userCondition:text,userId:User.users.id.toString());
    setState(() {
      searchBoundList=true;
    });
  }

  @override
  void getBoundedListSuccess(List<MeterBind> boundedList) {
    if(boundedList!=null){
      meterBoundedList=boundedList;
      for (var i = 0; i < meterBoundedList.length; i++) {
        int unixTime=int.parse(meterBoundedList[i].expires.substring(6,19));
        meterBoundedList[i].expires=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
      }
    }
    else{
      meterBoundedList=[];
    }
    setState(() {
      getBoundedList=false;
      onlineLoading=false;
    });
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context, "", msg);
    setState(() {
      getBoundedList=false;searchBoundList=false;saveBindLoading=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }

  @override
  void searchBoundListSuccess(MeterBind searchBound) {
    if(searchBound!=null){
      newMeterToBind=searchBound;
      searchBoundList=false;
      setState(() {
        
      });
      showConfirm(newMeterToBind.userName);
    }
    else{
      searchBoundList=false;
      setState(() {
        
      });
    }
  }

  showConfirm(String text){
    showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text(text.toString()),
          content: Text(AppLocalizations.of(context).translate("confirmsave")),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: (){
                Navigator.pop(context);
                presenter.saveBound(meter:newMeterToBind);
                setState(() {
                  saveBindLoading=true;
                });
              },
            )
          ],
        );
      }
    );
  }

  @override
  void saveBindSuccess(MeterBind saveBind) {
    if(saveBind!=null){
      setState(() {
        saveBindLoading=false;
      });
      Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomTabBar()));
    }
    
  }

  @override
  void getAmountStatementSuccess(result) {
    
  }

  @override
  void requestMeterSuccess(RequestBill bill) {
    
  }

  @override
  void payMeterSuccess(result) {
    
  }
}