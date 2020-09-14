import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/model/NotificationMessage.dart';
import 'package:ypay/model/User.dart';
import 'package:ypay/model/userInfo.dart';

class DBHelper {
    static Database _db;

    Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
    "CREATE TABLE UserInfo(id INTEGER PRIMARY KEY,access_token TEXT,user_id TEXT,userName TEXT,fullName TEXT, email TEXT, img_url TEXT,msg TEXT ,loginWith TEXT,phone TEXT )");
    print("Created table");
  }

  // Retrieving employees from Employee Tables
  Future<UserInfo> getUserInfo() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM UserInfo');
    UserInfo userInfo = new UserInfo();
    if(list.length>0){
      userInfo=UserInfo.fromJson(list[0]);
      return userInfo;
    }
    else{
      return null;
    }
  }

  Future<bool> updatePhoneNumber(UserInfo info,String phone)async{
    try{
      var dbClient = await db;
      String sql="Select * from UserInfo where user_id='${info.userId}'";
      List<Map>  list = await dbClient.rawQuery(sql);
      if(list.length>0){
        int res=await dbClient.rawUpdate("update UserInfo set phone=?",['$phone']);
          return res>0?true:false;
      }else{
        return null;
      }
    }catch(ex){
      return null;
    }

  }

  Future<bool> updatePhoto(UserInfo info,File image)async{
    try{
      var dbClient = await db;
      String sql="Select * from UserInfo where user_id='${info.userId}'";
      List<Map>  list = await dbClient.rawQuery(sql);
      if(list.length>0){
        int res=await dbClient.rawUpdate("update UserInfo set img_url=?",['$image']);
          return res>0?true:false;
      }
      return null;
    }catch(ex){
      return null;
    }
  }


  void saveUserInfo(UserInfo info) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO UserInfo(access_token,user_id, userName, fullName, email,img_url,msg, loginWith,phone) VALUES(' +
              '\'' +
              info.accessToken +'\'' +',' +'\'' +
              info.userId +'\'' +',' +'\'' +
              info.name +'\'' +',' +'\'' +
              info.fullname +'\'' +',' +'\'' +
              info.email+'\'' +',' +'\'' +
              info.imageUrl +'\'' +',' +'\'' +
              info.msg +'\'' +',' +'\'' +
              info.loginWith +'\'' +',' +'\'' +
              info.phone +'\'' +')');
    });
    print("Save user");
  }

  Future<bool> deleteUserInfo() async{
    try{
      var dbClient = await db;
      String sql="Delete From UserInfo";
      await dbClient.execute(sql);
      print("delete success");
      return true;
    }catch(ex){
      return false;
    }
  }

  Future<bool> setData(dynamic data,String keyName) async{
    var dbClient=await db;
    String sql="Select id from Data where  id ='$keyName'";

    List<Map> list;
    try {
      list = await dbClient.rawQuery(sql);
    }catch(ex){
      String sql="CREATE TABLE  Data (id  TEXT PRIMARY KEY, data TEXT)";
      await _db.execute(sql);
    }
    if(list!=null && list.length>0){
      int res=await dbClient.rawUpdate("update Data set data=?  where  id =? ",["$data","$keyName"]);
      return res>0?true:false;
    }else {
      int res = await dbClient.rawInsert(
          'INSERT INTO Data(id, data) VALUES(?, ?)',
          ["$keyName","$data"]);
      return res>0?true:false;
    }
  }

  Future<dynamic> getData(String keyName) async{
    try {

      var dbClient = await db;
      String sql="Select * from Data where  id ='$keyName'";
      List<Map>  list = await dbClient.rawQuery(sql);
      if (list.length > 0) {
        dynamic result=list[0]["data"].toString();
        if(keyName==DataKeyValue.token.toString()){
         return "Bearer "+result;
        }
        return result;
      } else {
        return null;
      }
    }catch(ex){
      return null;
    }
  }

  Future<bool> setUserInformation(User data) async{
    var dbClient=await db;
    String sql="Select id from User where id =0";
    List<Map> list;
    try {
      list = await dbClient.rawQuery(sql);
    }catch(ex){
      String sql="CREATE TABLE User(id INTEGER,group_id INTEGER,user_name TEXT,salt TEXT,password TEXT,"
            "mobile TEXT,email TEXT,avatar TEXT,nick_name TEXT,sex TEXT,birthday TEXT,telphone TEXT,area TEXT,address TEXT,"
            "qq TEXT,msn TEXT,amount REAL,point INTEGER,exp INTEGER,status INTEGER,"
            "reg_time TEXT,reg_ip TEXT,security_stamp TEXT,device_id TEXT,gps_location TEXT,use_lang TEXT)";
      await _db.execute(sql);
    }
    int delete=await dbClient.delete('User');

    var batch= await dbClient.batch();

    batch.rawInsert(
        'INSERT INTO User (id,group_id,user_name,salt,password,mobile,email,avatar,nick_name,sex,birthday,telphone,area,address,'
        'qq,msn,amount,point,exp,status,reg_time,reg_ip,security_stamp,device_id,gps_location,use_lang) VALUES'
        '(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
        [data.id,data.groupId,data.userName,data.salt,data.password,data.mobile,data.email,data.avatar,
        data.nickName,data.sex,data.birthday,data.telphone,data.area,data.address,data.qq,data.msn,
        data.amount,data.point,data.exp,data.status,data.regTime,data.regIp,data.securityStamp,
        data.deviceId,data.gpsLocation,data.useLang]
      );
    await batch.commit(noResult: true);
    bool result=true;// res==data.length?true:false;
    return result;
  }

  Future<User> getUser()async{
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    User userInfo = new User();
    if(list.length>0){
      userInfo=User.fromJson(list[0]);
      return userInfo;
    }
    else{
      return null;
    }
  }

  Future<bool> removeUser() async{
    try{
      var dbClient = await db;
      String sql="Delete From User";
      await dbClient.execute(sql);
      print("delete success");
      return true;
    }catch(ex){
      return false;
    }
  }

  Future<bool> setMessageData(Notifications data) async{
    var dbClient=await db;
    String sql="Select msgid from Notifications where msgid =0";
    List<Map> list;
    try {
      list = await dbClient.rawQuery(sql);
    }catch(ex){
      String sql="CREATE TABLE Notifications(msgid INTEGER,action TEXT,title TEXT,contents TEXT,notiDate TEXT,imageUrl TEXT,isRead TEXT)";
      await _db.execute(sql);
    }
    int result=await dbClient.rawInsert(
          'INSERT INTO Notifications(msgid, action,title,contents,notiDate,imageUrl,isRead) VALUES(?, ?,?,?,?,?,?)',
          [data.msgid,data.action,data.title,data.contents,data.notiDate,data.imageUrl,data.isRead]);

      return result>0?true:false;
  }

  Future<MessageCount> getMessageCount()async{
    var dbClient=await db;
    MessageCount messageCount;
    int unreadCount=0;int allCount=0;
    try{
      String sql="Select msgid From Notifications where isRead=?";
      List<Map> list=await dbClient.rawQuery(sql,["false"]);
      if(list.length>0){
        unreadCount=list.length;
      }
      String sql1="Select msgid From Notifications";
      List<Map> list1=await dbClient.rawQuery(sql1);
      if(list1.length>0){
        allCount=list1.length;
      }
      messageCount=new MessageCount(allCount:allCount.toString(),unreadCount:unreadCount.toString());
    }
    catch(ex){
      messageCount=new MessageCount(allCount:"0",unreadCount:"0");
    }
    return messageCount;
  }

  Future<List<Notifications>> getAllMsgs()async{
    var dbClient=await db;
    String sql="Select * from Notifications";
    List<Map> list=await dbClient.rawQuery(sql);
    List<Notifications> notiList=new List<Notifications>();
    if(list.length>0){
      for (var i = 0; i < list.length; i++) {
        notiList.add(Notifications.fromJson(list[i]));
      }
    }
    return notiList;
  }

  Future<bool> updateMessageRead(int msgid,String txt)async{
    var dbClient=await db;
    String sql="Select msgid from Notifications where msgid =$msgid";
    List<Map> list=await dbClient.rawQuery(sql);
    if(list.length>0){
      int result=await dbClient.rawUpdate("update Notifications set isRead=? where msgid=?",['$txt','$msgid']);
      return result>0?true:false;
    }
    else{
      return false;
    }
  }

  Future<bool> deleteNotification() async{
    try{
      var dbClient = await db;
      String sql="Delete From Notifications";
      await dbClient.execute(sql);
      print("delete success");
      return true;
    }catch(ex){
      return false;
    }
  }

}