import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ypay/Login/SocialLoginUserInfo.dart';
import 'package:ypay/Page/BottomTabBar.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dataService/MeterListPresenter.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/RequestBill.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class PayMeterBill extends StatefulWidget {
  PayMeterBill({this.invoiceNo,this.customerId}):super();
  final String invoiceNo;final String customerId;
  @override
  _PayMeterBillState createState() => _PayMeterBillState();
}

class _PayMeterBillState extends State<PayMeterBill> implements MeterBillListContract{

  List<BillInfo> billinfoList=[];
  RequestBill requestBill=new RequestBill();
  MeterBillListPresenter presenter;
  bool requestLoading=false;
  bool payLoaing=false;

  @override
  Widget build(BuildContext context) {
    String invoiceno=AppLocalizations.of(context).translate("invoiceno");
    String duedate=AppLocalizations.of(context).translate("duedate");
    String paydate=AppLocalizations.of(context).translate("billdate");
    String payamount=AppLocalizations.of(context).translate("billamount");

    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Navigator.pop(context);},),
            title: requestLoading==true?Text(""):Center(child: Text("Meter "+requestBill.subscriberId,style: TextStyle(fontSize: 14),),),
          ),
          body: 
          requestLoading==true||payLoaing==true?Center(child: SpinKitChasingDots(color: Colors.orange[500],size: 20,)):
          Container(
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 2,child: Container(),),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(right:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("youremain"),style: TextStyle(fontSize: 13,color: Colors.grey),),
                        Text(User.users.amount.toString()+" "+requestBill.currency,style: TextStyle(fontSize: 17),)
                      ],
                    )
                  ),
                ],
              ),
              Row(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left:10,top:10),
                    child: CircleAvatar(child: Icon(Icons.attach_money,color: Colors.white,),radius: 30,backgroundColor: Colors.orange[500],)),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(left:3,top:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("totalTopay"),style: TextStyle(fontSize: 13),),
                        Text(requestBill.totalAmount+" "+requestBill.currency,style: TextStyle(fontSize: 20),)
                      ],
                    )
                  ),
                Expanded(flex: 2,child: Container(),),
                Container(
                  margin: EdgeInsets.only(right:20,top:10),
                  child: Text("${billinfoList.length.toString()} bills",style: TextStyle(fontSize: 13,color: Colors.grey),),)
              ],),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,i){
                        return AnimationConfiguration.staggeredList(
                          position: i, 
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.white12,
                                  border: Border.all(color:Colors.grey)),
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width*3/4,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left:5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical:5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(invoiceno,style: TextStyle(fontSize: 13,color: Colors.grey),),
                                              Text(billinfoList[i].billno,style: TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                        Container(padding: EdgeInsets.symmetric(vertical:5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(duedate,style: TextStyle(fontSize: 13,color: Colors.grey),),
                                              Text(billinfoList[i].duedate.substring(0,10),style: TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        )
                                      ],),
                                    ),
                                    Expanded(flex: 2,child: Container(),),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(padding: EdgeInsets.symmetric(vertical:5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(paydate,style: TextStyle(fontSize: 13,color: Colors.grey),),
                                              Text(billinfoList[i].billdate.substring(0,10),style: TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                      Container(padding: EdgeInsets.symmetric(vertical:5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(payamount,style: TextStyle(fontSize: 13,color: Colors.grey),),
                                              Text(billinfoList[i].amount.toString()+" "+requestBill.currency,style: TextStyle(fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                    ],),
                                  ],
                                ),
                              ),
                            ),
                          )
                        );
                      },
                      itemCount: billinfoList.length,
                    ),
                  ),
                ),
              )

            ],),
          ),
          bottomNavigationBar: 
          requestLoading==true||payLoaing==true?Container():
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.symmetric(vertical:10),
              decoration: BoxDecoration(
                color: Colors.orange[500],
                borderRadius: BorderRadius.circular(5.0)
              ),
              width: MediaQuery.of(context).size.width*2/3,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Icon(Icons.attach_money,color: Colors.white),
                  Text(AppLocalizations.of(context).translate("payall"),style: TextStyle(color: Colors.white),)
                ],),
              ),
            ),
            onTap: (){
              payBill();
            },
          ),
        ),
      ),
    );
  }

  paycheck(){
    showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.7),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
      return WillPopScope(
        onWillPop: () async=>false,
        child: Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height*0.8/2,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundColor: Colors.orange[500],child: Icon(Icons.info_outline,size: 30,color: Colors.white,),radius: 40,),
                  ),
                  Text("Error!!!",style: TextStyle(fontSize: 20,fontFamily: "pyidaungsu"),),
                  SizedBox(height: MediaQuery.of(context).size.height*1/20,),
                  Text(AppLocalizations.of(context).translate("yourbal"),style: TextStyle(fontSize: 15,fontFamily: "pyidaungsu"),),
                ],),
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right:5),
                  child: FlatButton(
                    color: Colors.orange[500],
                    child: Container(
                      width: MediaQuery.of(context).size.width*1/4,
                      padding: EdgeInsets.all(5),
                      child: Text("OK",textAlign: TextAlign.center,style: TextStyle(fontFamily: "pyidaungsu",fontSize: 15,color: Colors.white),)),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {});
  }

  payBill(){
    if(User.users.amount<double.parse(requestBill.totalAmount)){
      paycheck();
    }
    else{
      presenter.payMeter(payamount:requestBill.totalAmount,customerId:widget.customerId,invoiceId:widget.invoiceNo,userId:User.users.id.toString());
      setState(() {
        payLoaing=true;
      });
    }
  }

  payBillSuccess(){
    showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.7),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
      return WillPopScope(
        onWillPop: () async=>false,
        child: Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              content: Container(
                height: MediaQuery.of(context).size.height*0.8/2,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(backgroundColor: Colors.orange[500],child: Icon(Icons.check,size: 30,color: Colors.white,),radius: 40,),
                  ),
                  Text("Success!!!",style: TextStyle(fontSize: 20,fontFamily: "pyidaungsu"),),
                  Text(AppLocalizations.of(context).translate("paysuccess"),style: TextStyle(fontSize: 13,fontFamily: "pyidaungsu"),),
                  Container(
                    padding: EdgeInsets.symmetric(vertical:20),
                    child: Text(AppLocalizations.of(context).translate('paidamount')+": ${requestBill.totalAmount} ${requestBill.currency}",
                      style: TextStyle(fontSize: 18,fontFamily: "pyidaungsu"),),
                  ),
                ],),
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right:5),
                  child: FlatButton(
                    color: Colors.orange[500],
                    child: Container(
                      width: MediaQuery.of(context).size.width*1/4,
                      padding: EdgeInsets.all(5),
                      child: Text("Done",textAlign: TextAlign.center,style: TextStyle(fontFamily: "pyidaungsu",fontSize: 15,color: Colors.white),)),
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SocialLoginUserInfo(userId: User.users.id.toString(),)));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {});
  }

  @override
  void initState() {
    presenter=MeterBillListPresenter(this, context);
    presenter.requestMeterToPay(customerId:widget.customerId,invoiceId: widget.invoiceNo,userId: User.users.id.toString());
    setState(() {
      requestLoading=true;
    });
    super.initState();
  }

  @override
  void getAmountStatementSuccess(result) {
    
  }

  @override
  void getBoundedListSuccess(List<MeterBind> boundedList) {
    
  }

  @override
  void requestMeterSuccess(RequestBill bill) {
    if(bill!=null){
      requestBill=bill;
      var obj=requestBill.billInfo;
      List<dynamic> billInfo=json.decode(obj);
      for (var i = 0; i < billInfo.length; i++) {
        billinfoList.add(BillInfo.fromJson(billInfo[i]));
      }
      setState(() {
        requestLoading=false;
      });
    }
    else{
      Navigator.of(context).pop(false);
    }
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
      requestLoading=false;
      payLoaing=false;
    });
  }

  @override
  void showMessage(String msg) {
    MessageHandel.showMessage(context, "", msg);
  }

  @override
  void payMeterSuccess(result) {
    setState(() {
      payLoaing=false;
    });
    payBillSuccess();
  }
}