import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/MeterListPresenter.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/AmountStatement.dart';
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/PaidBill.dart';
import 'package:ypay/model/RequestBill.dart';
import 'package:ypay/model/User.dart';

class AllPaidMeterLists extends StatefulWidget {
  @override
  AllPaidMeterListsState createState() => AllPaidMeterListsState();
}

class AllPaidMeterListsState extends State<AllPaidMeterLists> implements MeterBillListContract{
  String nullResult="";
  RefreshController _refreshController =RefreshController(initialRefresh: false);
  List<AmountStatement> topupHistoryList=[];
  List<AmountStatement> sortByAmountList=[];
  List<String> sortType=["Name","Amount","Pay Date"];
  String sortName="Amount";var db=DBHelper();
  bool isShowImage;
  MeterBillListPresenter presenter;
  bool topupListLoading=false;
  bool onlineLoading=false;

  @override
  void initState() {
    presenter=MeterBillListPresenter(this, context);
    getData();
    super.initState();
  }

  getData(){
    getCacheData();
    presenter.getTopupList(userId:User.users.id.toString(),recordType: 2);
  }

  getCacheData()async{
    setState(() {
      topupListLoading=true;
      onlineLoading=true;
    });
    String res=await db.getData(DataKeyValue.paidList);
    if(res==null||res=="")
    {
      topupHistoryList=[];
    }else{
      List<dynamic> obj=json.decode(json.decode(res));
      List<AmountStatement> amtList=new List<AmountStatement>();
      if(obj!=null||obj.length>0){
        for (var i = 0; i < obj.length; i++) {
          amtList.add(AmountStatement.fromJson(obj[i]));
          int unixTime=int.parse(amtList[i].addTime.substring(6,19));
          amtList[i].addTime=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
        }
      }
      topupHistoryList=amtList;
      getSortTypeName();
    }
    
  }

  getSortTypeName()async{
    String sortType=await db.getData(DataKeyValue.sortTypeName1);
    sortName=sortType==null?sortName:sortType;
    setState(() {
      
    });
    sortItems(sortName);
  }

  sortItems(String sname){
    switch (sname) {
      case "Name":
        topupHistoryList.sort((a, b) => a.userName.compareTo(b.userName));
        sortByAmountList=topupHistoryList.toList();
        setState(() {
          
        });break;

      case "Pay Date":
        topupHistoryList.sort((a, b) => a.addTime.compareTo(b.addTime));
        sortByAmountList=topupHistoryList.reversed.toList();
        setState(() {
          
        });break;
      
      default:
      topupHistoryList.sort((a, b) => a.value.compareTo(b.value));
      sortByAmountList=topupHistoryList.reversed.toList();
      setState(() {
        
      });
    }
    setState(() {
        topupListLoading=false;
    });
  }

  sortRadioDialog(){
    showGeneralDialog(context: context,
    barrierColor: Colors.black.withOpacity(0.7),
      transitionBuilder: (context, a1, a2, widget){
      return WillPopScope(
        onWillPop: () async=>false,
        child: Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right:5),
                    child: Icon(Icons.sort,color: Colors.orange[500],)),
                  Text("Sort By",style:TextStyle(fontFamily: "pyidaungsu",)),
                ],
              ),
              content: StatefulBuilder(
                builder:(BuildContext context,StateSetter setState){
                  return Container(
                  height: MediaQuery.of(context).size.width*1/2,
                  child: Column(children: <Widget>[
                    InkWell(
                      onTap: (){Navigator.pop(context);},
                      child: RadioListTile(
                        value: sortType[0],
                        groupValue: sortName,
                        title: Text(sortType[0],style: TextStyle(color: Colors.black,fontFamily: "pyidaungsu",),),
                        onChanged:(newName){
                          setState(() {
                            sortName=newName;
                          });
                          db.setData(sortName, DataKeyValue.sortTypeName1);
                          Navigator.pop(context);sortItems(sortName);
                        } ,
                        selected: sortName==sortType[0],
                        activeColor: Colors.orange[500],
                      ),
                    ),
                    InkWell(
                      onTap: (){Navigator.pop(context);},
                      child: RadioListTile(
                        value: sortType[1],
                        groupValue: sortName,
                        title: Text(sortType[1],style: TextStyle(color: Colors.black,fontFamily: "pyidaungsu",),),
                        onChanged:(newName){
                          setState(() {
                            sortName=newName;
                          });
                          db.setData(sortName, DataKeyValue.sortTypeName1);
                          Navigator.pop(context);sortItems(sortName);
                        } ,
                        selected: sortName==sortType[1],
                        activeColor: Colors.orange[500],
                      ),
                    ),
                    InkWell(
                      onTap: (){Navigator.pop(context);},
                      child: RadioListTile(
                        value: sortType[2],
                        groupValue: sortName,
                        title: Text(sortType[2],style: TextStyle(color: Colors.black,fontFamily: "pyidaungsu",),),
                        onChanged:(newName){
                          setState(() {
                            sortName=newName;
                          });
                          db.setData(sortName, DataKeyValue.sortTypeName1);
                          Navigator.pop(context);sortItems(sortName);
                        } ,
                        selected: sortName==sortType[2],
                        activeColor: Colors.orange[500],
                      ),
                    )
                  ],)
                );
                } 
              ),
            ),
          ),
        ),
      );
      },
    transitionDuration: Duration(milliseconds: 300),
    barrierDismissible: false,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {});
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
            title: Text(AppLocalizations.of(context).translate("paidhist"),style: TextStyle(fontSize: 17),),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.filter_list,color: Colors.black,),onPressed: (){
                sortRadioDialog();
              },)
            ],
          ),
          body: 
            topupListLoading==true?
              Center(child: SpinKitChasingDots(color: Colors.orange[500],),):
            Container(child: Column(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical:10),
                  padding: EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context).translate("paidhist1"),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey)),
                ),
                Expanded(flex: 2,child: Container(),),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("${topupHistoryList.length} records"))
              ],),
              onlineLoading==true?
              Center(child: SpinKitCircle(color: Colors.grey,size: 15,),):Container(),
              topupHistoryList.length==0?
              Center(child: Container(
                margin: EdgeInsets.only(top:40),
                child: Text(nullResult)),):
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
                        if(sortByAmountList.length==0||sortByAmountList.length==topupHistoryList.length){
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
                      itemBuilder: (context,i){
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,
                            border: Border.all(color:Colors.grey)),
                          margin: EdgeInsets.only(bottom:7),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width*3/4,
                          child: Row(children: <Widget>[
                            IconButton(
                              icon: 
                              CircleAvatar(child: Icon(Icons.attach_money,color: Colors.orange[500],),radius: 25,backgroundColor: Colors.transparent,),
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
                                        TextSpan(text: sortByAmountList[i].userName,style: TextStyle(color: Colors.blue,fontFamily: "pyidaungsu",fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                Container(
                                  margin: EdgeInsets.only(top:5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Pay Time",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      Text(sortByAmountList[i].addTime.toString(),style: TextStyle(fontSize: 13),)
                                    ],
                                )),
                              ],),
                            ),
                            Expanded(flex: 2,child: Container(),),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Pay Amount",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                Text(sortByAmountList[i].value.toString()+" Ks",style: TextStyle(color: Colors.red,)),
                              ],
                            ),
                          ],),
                        );
                      },
                      // itemExtent: 10.0,
                      itemCount: sortByAmountList.length,
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
    if(result!=null){
      topupHistoryList=result;
      for (var i = 0; i < topupHistoryList.length; i++) {
        int unixTime=int.parse(topupHistoryList[i].addTime.substring(6,19));
        topupHistoryList[i].addTime=DateFormat('dd/MM/yyyy').add_jm().format(DateTime.fromMillisecondsSinceEpoch(unixTime)).toString();
      }
      getSortTypeName();
    }
    else{
      topupHistoryList=[];
      nullResult="There is no paid meter in your account";
    }
    setState(() {
      onlineLoading=false;
      topupListLoading=false;
    });
  }

  @override
  void getBoundedListSuccess(List<MeterBind> boundedList) {
    
  }

  @override
  void payMeterSuccess(PaidBillRecord result) {
    
  }

  @override
  void requestMeterSuccess(RequestBill bill) {
    
  }

  @override
  void saveBindSuccess(MeterBind saveBind) {
    
  }

  @override
  void searchBoundListSuccess(MeterBind searchBound) {
    
  }

  @override
  void showError(String msg) {
    MessageHandel.showError(context,"", msg);
    setState(() {
      topupListLoading=false;
      onlineLoading=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context,"", msg);
  }
}
