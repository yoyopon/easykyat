import 'dart:convert';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ypay/Page/PayMeterBill.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/MeterListPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/RequestBill.dart';
import 'package:ypay/model/User.dart';

class AllMeterList extends StatefulWidget {
  @override
  _AllMeterListState createState() => _AllMeterListState();
}

class _AllMeterListState extends State<AllMeterList> implements MeterBillListContract{
  List<String> meterTypesList=[];
  String text;
  RefreshController _refreshController =RefreshController(initialRefresh: false);
  var db=DBHelper();
  List<MeterBind> allMetersList=[];
  List<MeterBind> selectedMeterList=[];
  MeterBillListPresenter presenter;
  bool getBoundedList=false;bool onlineLoading=false;
  String norecord="";
  TextEditingController controller=TextEditingController();

  @override
  void initState() {
    presenter=MeterBillListPresenter(this, context);
    getData();
    super.initState();
  }

  getData(){
    setState(() {
      getBoundedList=true;
      onlineLoading=true;
    });
    getCachedData();
    presenter.getBoundedList(userId:User.users.id.toString());
  }

  getCachedData()async{
    String res=await db.getData(DataKeyValue.bindList);
    if(res==null||res==""){
      allMetersList=[]; 
    }
    else{
      List<dynamic> obj=json.decode(json.decode(res));
      if(obj!=null||obj.length>0){
        for (var i = 0; i < obj.length; i++) {
          allMetersList.add(MeterBind.fromJson(obj[i]));
          int unixTime=int.parse(allMetersList[i].expires.substring(6,19));
          allMetersList[i].expires=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
          meterTypesList.add(allMetersList[i].userName);
        }
        text=meterTypesList[0];
        getSelectedMeterList();
      } 
    }
  }

  getSelectedMeterList(){
    selectedMeterList=[];
    for (var i = 0; i < allMetersList.length; i++) {
      if(allMetersList[i].userName==text){
        selectedMeterList.add(allMetersList[i]);
      }
    }
    getBoundedList=false;
    setState(() {
        
    });
  }

  String popupinit(){
    String meterType=meterTypesList[0];
    setState(() {
      
    });
    return meterType;
  }

  popupChange(String text1){
    setState(() {
      getBoundedList=true;
    });
    text=text1;
    getSelectedMeterList();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {

    gotoNewPage({MeterBind meter,String text1})async{
      final res=await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PayMeterBill(invoiceNo: text1,customerId: meter.userName,)));
      if(res!=null&&res==false){
        String message=await db.getData(DataKeyValue.requestErrorMsg);
        MessageHandel.showError(context, "", message);
      }
    }

    openNewPage(MeterBind meterBind){
      showDialog(context: context,
      // barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: Center(child: Text("Enter Invoice No",style: TextStyle(fontFamily: "pyidaungsu"),),),
            content: Container(
              padding: EdgeInsets.only(bottom:20,top:10),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.search,color: Colors.orange[500],),
                hintText: "Enter Invoice No",
                labelText: "Invoice No",
                labelStyle: TextStyle(fontFamily: "pyidaungsu",fontSize: 13,color: Colors.grey),
                hintStyle: TextStyle(fontFamily: "pyidaungsu"),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange[500])
                )
                ),
                onSubmitted: (text){
                  if(text!=null&&text!=""){
                    Navigator.pop(context);
                    gotoNewPage(meter: meterBind,text1: text);
                  }
                },  
              ),
            ),
          );
      });
      
    }

    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.7,
            leading: IconButton(icon: Text("Ypay",
              style: TextStyle(fontSize: 18,color: Colors.orange[500],fontStyle: FontStyle.italic),),
              onPressed: (){},
            ),
            title: Text(AppLocalizations.of(context).translate("allmeters"),style: TextStyle(fontSize: 17),),
            actions: <Widget>[
            getBoundedList==true||allMetersList.length==0?Icon(Icons.play_circle_filled,color: Colors.white,):
            PopupMenuButton(
              child:Center(child: Container(
                padding: EdgeInsets.only(right:5),
                child: Text(text,style: TextStyle(fontSize: 13),))),
              //initialValue: popupinit(),
              itemBuilder: (BuildContext context){
                return meterTypesList.map((meter){
                  return PopupMenuItem(
                    value: meter,
                    child: Text(meter));
                }).toList();
              },
              onSelected: (newmeter){
                popupChange(newmeter);
              },
            )
          ],),
          body: //Center(child: Text(text),),
            getBoundedList==true?Container():
            Container(child: Column(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical:8),
                  padding: EdgeInsets.all(10),
                  child: Text("Meter : "+text,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
                ),
                Expanded(flex: 2,child: Container(),),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text("${selectedMeterList.length} records"))
              ],),
              onlineLoading==true?
              Center(child: SpinKitCircle(color: Colors.grey,size: 15,),):Container(),
              allMetersList.length==0||selectedMeterList.length==0?
              Container(child: Text(norecord),):
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropMaterialHeader(color: Colors.orange[500],),
                    footer: CustomFooter(
                      builder: (BuildContext context,LoadStatus mode){
                        Widget body ;
                        if(mode==LoadStatus.idle){
                          body =  Text("pull up load");
                        }
                        else if(mode==LoadStatus.loading){
                          body =  CupertinoActivityIndicator();
                        }
                        else if(mode == LoadStatus.failed){
                          body = Text("Load Failed!Click retry!");
                        }
                        else if(mode == LoadStatus.canLoading){
                            body = Text("release to load more");
                        }
                        if(allMetersList.length==0||allMetersList.length==allMetersList.length){
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child:body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context,i){
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,
                              border: Border.all(color:Colors.grey)),
                            margin: EdgeInsets.only(bottom:7),
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width*3/4,
                            child: Row(children: <Widget>[
                              IconButton(
                                icon:CircleAvatar(child:Text("M",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold),),
                                  radius: 25,backgroundColor: Colors.grey[300],),
                                onPressed: (){},),
                              Container(
                                margin: EdgeInsets.only(left:5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: "Meter: ",style: TextStyle(color: Colors.black,fontFamily: "pyidaungsu")),
                                        TextSpan(text: selectedMeterList[i].userName,style: TextStyle(color: Colors.red,fontFamily: "pyidaungsu",fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical:5),
                                    width: MediaQuery.of(context).size.width*2/3,
                                    child: Text(selectedMeterList[i].oauthOpenid,style: TextStyle(fontSize: 13),)),
                                  // Text("Expires in "+selectedMeterList[i].expires,style: TextStyle(fontSize: 13),)
                                ],),
                              ),
                              Expanded(flex: 2,child: Container(),),
                              Icon(Icons.details,size: 15,)
                            ],),
                          ),
                          onTap: (){
                            openNewPage(selectedMeterList[i]);
                          },
                        );
                      },
                      // itemExtent: 10.0,
                      itemCount: selectedMeterList.length,
                    ),
                  ),
                ),
              )
            ],),)
        ),
      ),
    );
  }

  @override
  void getAmountStatementSuccess(result) {
    
  }

  @override
  void getBoundedListSuccess(List<MeterBind> boundedList) {
    if(boundedList!=null){
      allMetersList=[];
      allMetersList=boundedList;
      meterTypesList=[];
      for (var i = 0; i < allMetersList.length; i++) {
        int unixTime=int.parse(allMetersList[i].expires.substring(6,19));
        allMetersList[i].expires=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
        meterTypesList.add(allMetersList[i].userName);
      }
      text=meterTypesList[0];
      getSelectedMeterList();
    }
    else{
      allMetersList=[];
      norecord="You have no meter bounded";
    }
    setState(() {
      getBoundedList=false;
      onlineLoading=false;
    });
  }

  @override
  void saveBindSuccess(MeterBind saveBind) {
    
  }

  @override
  void searchBoundListSuccess(MeterBind searchBound) {
    
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context, "", msg);
    setState(() {
      getBoundedList=false;
      onlineLoading=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }

  @override
  void requestMeterSuccess(RequestBill bill) {
    
  }

  @override
  void payMeterSuccess(result) {
    
  }
}