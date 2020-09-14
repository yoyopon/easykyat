import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/TextStyle.dart';

class AllPaidMeterLists extends StatefulWidget {
  @override
  AllPaidMeterListsState createState() => AllPaidMeterListsState();
}

class AllPaidMeterListsState extends State<AllPaidMeterLists> {

  RefreshController _refreshController =RefreshController(initialRefresh: false);
  List<MeterBillList> topupHistoryList=[];
  List<MeterBillList> sortByAmountList=[];
  List<String> sortType=["Name","Amount","Pay Date"];
  String sortName="Amount";var db=DBHelper();
  bool isShowImage;

  @override
  void initState() {
    getListStyle();
    getData();
    super.initState();
  }

  getListStyle()async{
    String isShow=await db.getData(DataKeyValue.hideMeterpic);
    isShowImage=isShow=="false"?false:true;
    setState(() {
      
    });
  }

  getData(){
    //topupHistoryList=MeterBillList.paidBillList;
    for (var i = 0; i < MeterBillList.paidBillList.length; i++) {
      if(MeterBillList.paidBillList[i].ispaid==true){
        topupHistoryList.add(MeterBillList.paidBillList[i]);
      }
    }
    getSortTypeName();
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
        topupHistoryList.sort((a, b) => a.address.compareTo(b.address));
        sortByAmountList=topupHistoryList.toList();
        setState(() {
          
        });break;

      case "Pay Date":
        topupHistoryList.sort((a, b) => a.payDate.compareTo(b.payDate));
        sortByAmountList=topupHistoryList.reversed.toList();
        setState(() {
          
        });break;
      
      default:
      topupHistoryList.sort((a, b) => a.amountToPay.compareTo(b.amountToPay));
      sortByAmountList=topupHistoryList.reversed.toList();
      setState(() {
        
      });
    }
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
          body: //Center(child: Text("All Topup History"),),
            Container(child: Column(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical:10),
                  padding: EdgeInsets.all(10),
                  child: Text(AppLocalizations.of(context).translate("paidhist1"),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey)),
                ),
                Expanded(flex: 2,child: Container(),),
                Container(
                  padding: EdgeInsets.only(top:10,bottom: 10,right: 3),
                  child: IconButton(
                    icon: isShowImage==true?Icon(Icons.apps,color: Colors.grey,):Icon(Icons.list,color: Colors.grey,),
                    onPressed: ()async{
                      await db.setData(isShowImage==true?"false":"true",DataKeyValue.hideMeterpic);
                      isShowImage=isShowImage==true?false:true;
                      setState(() {
                        
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text("${topupHistoryList.length} records"))
              ],),
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
                              isShowImage==false?
                              CircleAvatar(child: Icon(Icons.attach_money,color: Colors.white,),radius: 25,backgroundColor: Colors.orange[500],):
                              CircleAvatar(radius: 25,backgroundColor: Colors.transparent,backgroundImage: sortByAmountList[i].meterImage==""||sortByAmountList[i].meterImage==null?AssetImage("images/nophoto.png"):NetworkImage(sortByAmountList[i].meterImage)),
                              onPressed: (){},),
                            Container(
                              margin: EdgeInsets.only(left:5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                Text(sortByAmountList[i].meterNo+" ("+sortByAmountList[i].address+")"),
                                Text(sortByAmountList[i].lastMonthUnit+" - "+sortByAmountList[i].readUnit+" = "+sortByAmountList[i].unitsToPay),
                                Text(sortByAmountList[i].payDate.toString(),style: TextStyle(fontSize: 13),)
                              ],),
                            ),
                            Expanded(flex: 2,child: Container(),),
                            Text(sortByAmountList[i].amountToPay.toString()+" Ks",style: TextStyle(color: Colors.red),)
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
}

class MeterBillList{
  String meterNo;
  double amountToPay;
  String lastMonthUnit;
  String readUnit;
  String unitsToPay;
  String payDate;
  String consumerName;
  bool ispaid;
  String address;
  String meterImage;

  MeterBillList({this.meterNo,this.amountToPay,this.lastMonthUnit,this.readUnit,this.unitsToPay,this.payDate,this.consumerName,this.ispaid,this.address,this.meterImage});

  static List<MeterBillList> paidBillList=[
    new MeterBillList(meterNo:"Meter No1",amountToPay:1800,lastMonthUnit:"1300",readUnit:"1500",unitsToPay:"200",payDate: "2020-09-01",consumerName: "Cole",ispaid: true,address: "18th street cafe",meterImage: ""),
    new MeterBillList(meterNo:"Meter No2",amountToPay:2000,lastMonthUnit:"2000",readUnit:"2500",unitsToPay:"300",payDate: "",consumerName: "Cole",ispaid: false,address: "22th street house",meterImage: ""),
    new MeterBillList(meterNo:"Meter No3",amountToPay:2150,lastMonthUnit:"2000",readUnit:"2600",unitsToPay:"400",payDate: "",consumerName: "Cole",ispaid: false,address: "19th street office",meterImage: ""),
    new MeterBillList(meterNo:"Meter No2",amountToPay:2300,lastMonthUnit:"3200",readUnit:"3400",unitsToPay:"150",payDate: "2020-09-02",consumerName: "Cole",ispaid: true,address: "22th street house",meterImage: ""),
  ];
}
