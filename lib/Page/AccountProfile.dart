import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/Login/ResetPassword.dart';
import 'package:ypay/Login/SocialLoginUserInfo.dart';
import 'package:ypay/Page/AllMeterTypes.dart';
import 'package:ypay/Page/ChangeLanguage.dart';
import 'package:ypay/Page/EditUserInfo.dart';
import 'package:ypay/Page/Message.dart';
import 'package:ypay/Page/MyProfile.dart';
import 'package:ypay/Page/ProfilePhotoChange.dart';
import 'package:ypay/Providers/AppLocalization.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/dataService/userProfilePresenter.dart';
import 'package:ypay/designUI/TextStyle.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';
import '../designUI/TextStyle.dart';
import '../main.dart';
import '../model/userInfo.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with UserProfileContract{
  RefreshController _refreshController =RefreshController(initialRefresh: false);
  Widget orangeSection;Widget firstBlock;Widget secondBlock;Widget thirdBlock;
  UserProfilePresenter _presenter;
  bool loadingLogOut=false;String allmsg="0";String unreadMsg="0";
  Image languageImage;//Languages currentLanguage;
  bool usersLoading=false;
  var db=DBHelper();
  String gpName="";

  getLocale(){
    switch (UserInfo.userInfo.userLanguage) {
      case 'mm':languageImage=Image.asset('images/mmRound.png');break;
      case 'zh':languageImage=Image.asset('images/chinaRound.png');break;
      default:languageImage=Image.asset('images/usaRound.png');break;
    }
  }

  getImageUrl(){
    if(UserInfo.userInfo.imageUrl.contains("File")){
        int fIndex=UserInfo.userInfo.imageUrl.indexOf('/');
        int lIndex=UserInfo.userInfo.imageUrl.lastIndexOf("'");
        String filePath=UserInfo.userInfo.imageUrl.substring(fIndex,lIndex);
        UserInfo.fileImage=File(filePath);
      }
  }

  void _onRefresh() async{
    getUnreadMsgCount();
    await Future.delayed(Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    _presenter=new UserProfilePresenter(this, context);
    getUnreadMsgCount();
    getLocale();
    getImageUrl();
    super.initState();
    for (var i = 0; i < GroupId.group.length; i++) {
      if(GroupId.group[i].id==User.users.groupId){
        gpName=GroupId.group[i].name;
      }
    }
    setState(() {
      
    });
  }

  getUnreadMsgCount()async{
    allmsg=await db.getData(DataKeyValue.allmsgCount);
    unreadMsg=await db.getData(DataKeyValue.unreadCount);
    setState(() {
      
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(languageImage.image, context);
    precacheImage(Image.asset('images/default-avatar.jpg').image, context);
    if(UserInfo.fileImage!=null)precacheImage(Image.file(UserInfo.fileImage).image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: PageTheme.getThemeData(),
      home: SafeArea(
        child: Scaffold(
        body: 
        loadingLogOut==true||usersLoading==true?
        SpinKitChasingDots(
            color: Colors.orange[500],
            size: 50.0,
          ):
        SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(color: Colors.orange[500],),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
               child: Column(
                children: <Widget>[

                Container(
                  color: Colors.blue[400],
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height*1/4,
                        padding: const EdgeInsets.only(left: 20,top: 20,bottom: 15),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePhotoChange()));
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height*1/7,
                                width: MediaQuery.of(context).size.width*1/3,
                                child: 
                                User.users.avatar==""?
                                (UserInfo.fileImage!=null?
                                  Container(
                                    height: MediaQuery.of(context).size.height*1/7,
                                    child: Image.file(UserInfo.fileImage,)):
                                  (UserInfo.userInfo.imageUrl=="imageURl"||UserInfo.userInfo.imageUrl==""||UserInfo.userInfo.imageUrl==null?
                                  Image.asset('images/default-avatar.jpg',)
                                  :NetworkImage(UserInfo.userInfo.imageUrl))):
                                CachedNetworkImage(imageUrl: backendUrl+User.users.avatar,)
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left:20.0),),
                            Container(
                              margin: EdgeInsets.only(top:5),
                              height: MediaQuery.of(context).size.height*1/6,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                Text(UserInfo.userInfo.fullname,style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
                                Text(AppLocalizations.of(context).translate("member")+
                                  gpName,style:TextStyle(color: Colors.white)),
                                Text(AppLocalizations.of(context).translate("growth")+" : "+
                                (User.users!=null&&User.users.point!=null?User.users.point.toString():"0"),
                                style:TextStyle(color: Colors.white))
                              ],),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.orange[500],
                        child: Padding(
                          padding: EdgeInsets.only(top: 7,left: 10,bottom: 7,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10),
                                child: Container(
                                  child: Column(children: <Widget>[
                                    Text(AppLocalizations.of(context).translate("balance"),style:TextStyle(color: Colors.white)),
                                    Text((User.users!=null&&User.users.amount!=null?User.users.amount.toString():"0"),
                                    style:TextStyle(color: Colors.white))
                                  ],),
                                ),
                              ),
                              Container(height: MediaQuery.of(context).size.height*1/20, child: VerticalDivider(color: Colors.white)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10),
                                child: InkWell(
                                  child: Container(
                                    child: Column(children: <Widget>[
                                      Text(AppLocalizations.of(context).translate("point"),style: TextStyle(color: Colors.white)),
                                      Text(User.users!=null&&User.users.point!=null?User.users.point.toString():"0",style: TextStyle(color: Colors.white))
                                    ],),
                                  ),
                                  onTap: ()async{
                                    //Navigator.push(context,MaterialPageRoute(builder: (context)=>Test1()));
                                  },
                                ),
                              ),
                              // Container(height: MediaQuery.of(context).size.height*1/20, child: VerticalDivider(color: Colors.white)),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal:10),
                              //   child: Container(
                              //     child: InkWell(
                              //       child: Column(children: <Widget>[
                              //         Text(AppLocalizations.of(context).translate("order"),style: TextStyle(color: Colors.white)),
                              //         Text("000",style: TextStyle(color: Colors.white))
                              //       ],),
                              //       onTap: (){
                                     
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Container(height:MediaQuery.of(context).size.height*1/20, child: VerticalDivider(color: Colors.white)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:10),
                                child: Container(
                                  child: InkWell(
                                    child: Column(children: <Widget>[
                                      Text(AppLocalizations.of(context).translate("noti"),style: TextStyle(color: Colors.white),),
                                      Text(allmsg,style: TextStyle(color: Colors.white),),
                                    ],),
                                    onTap: (){
                                      //UserInfo.prevFormsgPage="acc";
                                      //Navigator.push(context,MaterialPageRoute(builder: (context)=>Test()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Padding(padding: EdgeInsets.only(left:10,right: 10,top: 5),
                  child: Column(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.circular(5.0)),
                      child: Column(children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(AppLocalizations.of(context).translate("searchprinter"),style: TextStyle(color: Colors.black)),
                        //       Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                        //       IconButton(icon:Icon(Icons.keyboard_arrow_right,),onPressed: (){
                        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>PrinterSearch()));
                        //       },)
                        //     ],
                        //   ),
                        // ),
                        //Divider(color: Colors.grey,),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                            child: Row(
                              children: <Widget>[
                                Text(AppLocalizations.of(context).translate("changelan"),style: TextStyle(color: Colors.black)),
                                Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                                IconButton(
                                    icon: languageImage!=null?languageImage:Container(),
                                    onPressed: (){
                                      
                                    },
                                  )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>ChangeLanguage()));
                          },
                        ),
                        Divider(color: Colors.grey,),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                            child: Row(
                              children: <Widget>[
                                Text(AppLocalizations.of(context).translate("msg"),style: TextStyle(color: Colors.black)),
                                Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                                int.parse(unreadMsg)==0?
                                IconButton(icon: Icon(Icons.notifications_none),onPressed: (){},):
                                IconButton(
                                  icon: Badge(
                                    badgeColor: Colors.red,
                                    animationDuration: Duration(milliseconds: 300),
                                    animationType: BadgeAnimationType.slide,
                                    badgeContent: Text('$unreadMsg',style: TextStyle(color: Colors.white),),
                                    child: Icon(Icons.notifications,)),
                                  onPressed: (){},
                                  )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>MessagePage()));
                          },
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text("Dynamic Table",style: TextStyle(color: Colors.black)),
                        //       Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                        //       IconButton(icon:Icon(Icons.keyboard_arrow_right,),onPressed: (){
                        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>DynamicTable()));
                        //       },)
                        //     ],
                        //   ),
                        // ),
                        Divider(color: Colors.grey,),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                            child: Row(
                              children: <Widget>[
                                Text(AppLocalizations.of(context).translate("meterBill"),style: TextStyle(color: Colors.black)),
                                Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                                IconButton(icon:Icon(Icons.keyboard_arrow_right,),onPressed: (){
                                  //_scan();
                                  
                                },)
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>AllMeterType()));
                          },
                        ),
                        // Divider(color: Colors.grey,),
                        // Padding(
                        //   padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(AppLocalizations.of(context).translate("recharge"),style: TextStyle(color: Colors.black)),
                        //       Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                        //       IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>TopUpBalance()));
                        //       },)
                        //     ],
                        //   ),
                        // )
                      ],),
                    )
                  ],),
                  ),
                ),
                // Container(
                //   child: Padding(padding: EdgeInsets.only(left:10,right: 10,top: 5),
                //   child: Column(children: <Widget>[
                //     Container(
                //       decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.circular(5.0)),
                //       child: Column(children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                //           child: Row(
                //             children: <Widget>[
                //               Text(AppLocalizations.of(context).translate("manage"),style: TextStyle(color: Colors.black)),
                //               Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                //               IconButton(icon:Icon(Icons.keyboard_arrow_right,),onPressed: (){
                //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageOrder()));
                //               },)
                //             ],
                //           ),
                //         ),
                //         Divider(color: Colors.grey,),
                //         Padding(
                //           padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                //           child: Row(
                //             children: <Widget>[
                //               Text(AppLocalizations.of(context).translate("close"),style: TextStyle(color: Colors.black)),
                //               Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                //               IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>CloseOrder()));
                //               },)
                //             ],
                //           ),
                //         ),
                //         Divider(color: Colors.grey,),
                //         Padding(
                //           padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                //           child: Row(
                //             children: <Widget>[
                //               Text(AppLocalizations.of(context).translate("recharge"),style: TextStyle(color: Colors.black)),
                //               Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                //               IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                //                 Navigator.push(context, MaterialPageRoute(builder: (context)=>TopUpBalance()));
                //               },)
                //             ],
                //           ),
                //         )
                //       ],),
                //     )
                //   ],),
                //   ),
                // ),
                Container(
                  child: Padding(padding: EdgeInsets.only(left:10,right: 10,top: 5),
                  child: Column(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.circular(5.0)),
                      child: Column(children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                            child: Row(
                              children: <Widget>[
                                Text(AppLocalizations.of(context).translate("myprofile"),style: TextStyle(color: Colors.black)),
                                Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                                IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                                  
                                },)
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                          },
                        ),
                        Divider(color: Colors.grey,),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                            child: Row(
                              children: <Widget>[
                                Text(UserInfo.userInfo.loginWith=="google"||UserInfo.userInfo.loginWith=="facebook"?
                                  AppLocalizations.of(context).translate("editphone"):AppLocalizations.of(context).translate("changepass"),
                                  style: TextStyle(color: Colors.black)),
                                Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                                IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                                  
                                },)
                              ],
                            ),
                          ),
                          onTap: (){
                            // var prefs = await SharedPreferences.getInstance();
                                  // prefs.setString("previousPage", "AccountProfile");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    UserInfo.userInfo.loginWith=="google"||UserInfo.userInfo.loginWith=="facebook"?
                                    EditPhone():ResetPassword()
                                    //MyApp()
                                  ));
                          },
                        ),
                        // Divider(color: Colors.grey,),
                        // Padding(
                        //   padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text("Messenger",style: TextStyle(color: Colors.black)),
                        //       Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                        //       IconButton(icon:Icon(Icons.keyboard_arrow_right),onPressed: (){
                        //         Navigator.push(context, MaterialPageRoute(builder: (context)=>InstantMessagePage()));
                        //       },)
                        //     ],
                        //   ),
                        // ),
                      ],),
                    )
                  ],),
                  ),
                ),
                Container(
                  child: Padding(padding: EdgeInsets.only(left:10,right: 10,top: 5),
                  child: Column(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(border: Border.all(color:Colors.grey),borderRadius: BorderRadius.circular(5.0)),
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:0,bottom:0,left:10),
                          child: 
                          InkWell(
                            child: Row(
                            children: <Widget>[
                              Text(AppLocalizations.of(context).translate("logout"),style: TextStyle(color: Colors.black)),
                              Expanded(child: SizedBox(width: MediaQuery.of(context).size.width*1/3)),
                              IconButton(icon:Icon(Icons.exit_to_app),onPressed: (){},)
                            ],
                          ),
                            onTap: (){
                              openAlertBox();
                            },
                          )
                        )
                      ],),
                    )
                  ],),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );


  }

  ///For Alert Dialog Box
  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.power_settings_new,
                        size: 70.0,
                        color: Colors.orange[500],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text(
                          AppLocalizations.of(context).translate("logoutalert"),style: TextStyle(fontFamily: "pyidaungsu"),)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[500],
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.5),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(() {
                              UserInfo.hideBottomBar=true;
                            });
                            logout();
                          },
                          child: Text(
                            AppLocalizations.of(context).translate("logout"),
                            style: TextStyle(color: Colors.white,fontFamily: "pyidaungsu")
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.5),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                             AppLocalizations.of(context).translate("cancel"),style: TextStyle(fontFamily: "pyidaungsu"),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // void _scan()async{
  //   final DateFormat formatter = DateFormat('MM/yyyy');
  //   final String formatted = formatter.format(DateTime.now());
  //   // String formatted='07/2020';
  //   String barcode = await scanner.scan();
  //   String customerId = barcode;
  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>MeterBillRead(currentDate: formatted,customerId: customerId,)));
  // }

  void logout(){
    if(UserInfo.userInfo.loginWith=="google"){
      _presenter.signOutFromGoogle();
    }
    if(UserInfo.userInfo.loginWith=="facebook"){
      _presenter.signOutFromFacebook();
    }
    if(UserInfo.userInfo.loginWith=="username"){
      _presenter.logOut();
    }
    setState(() {
      loadingLogOut=true;
    });
  }

  @override
  void logOutSuccess() {
     _presenter.deleteFromDB();
  }

  @override
  void showError(String msg) {
    //Navigator.of(context).pop();
    MessageHandel.showError(context, "", msg);
    setState(() {
      usersLoading=false;
    });
  }

  @override
  void showMessage() {
  }

  removeKeys()async{
    UserInfo.fileImage=null;
    UserInfo.userInfo=UserInfo.username=UserInfo.password=UserInfo.fileImage=null;
    await db.setData("",DataKeyValue.token);
    await db.setData("",DataKeyValue.xsign);
    await db.setData("",DataKeyValue.xtimeStamp);
    await db.setData("",DataKeyValue.username);
    await db.setData("",DataKeyValue.password);
    await db.setData("",DataKeyValue.imgUrl);
    await db.setData("",DataKeyValue.fullname);
    await db.setData("",DataKeyValue.sortTypeName);
    await db.setData("",DataKeyValue.sortTypeName1);
    await db.setData("",DataKeyValue.allmsgCount);
    await db.setData("",DataKeyValue.topupList);
    await db.setData("",DataKeyValue.bindList);
    await db.setData("",DataKeyValue.paidList);
  }

  @override
  void deleteSuccess(){
    _presenter.deleteFromDB1();    
  }

  @override
  void removeSuccess() {
    _presenter.deleteMessageTable();
  }

  @override
  void notideleteSuccess() {
    removeKeys();
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
  }
}

