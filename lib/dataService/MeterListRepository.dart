import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ypay/APIService/loginToken.dart';
import 'package:ypay/dbHelper/DataKeyValue.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/designUI/MessageHandel.dart';
import 'package:ypay/model/AmountStatement.dart';
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/RequestBill.dart';

class MeterBillListRepository{
    BuildContext context;
    MeterBillListRepository(this.context);
    var db=DBHelper();

    Future<String> getToken()async{
      String token=await db.getData(DataKeyValue.token);
      return token;
    }

    Future<dynamic> getBoundedListSub(String url,String token,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: {"Authorization": token},
      encoding: encoding
      );
    if(request.statusCode==200){
      setTempBindList(request.body);
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        List<MeterBind> meterBind=new List<MeterBind>();
          for (var i = 0; i < obj1.length; i++) {
             meterBind.add(MeterBind.fromJson(obj1[i]));
          }
          return meterBind;
      }else{
        if(request.statusCode==201){
          setTempBindList("");
          var obj=json.decode(request.body);
          MessageHandel.showError(context, "", obj["response_desc"]);
          return null;
        }
      }
  }
  setTempBindList(String responseString)async{
    await db.setData(responseString, DataKeyValue.bindList);
  }

    Future<dynamic> getBoundedList({String userId})async{
    var url="$backendUrl/api/paybill/get_bound_list?user_id=$userId";
    return getToken().then((tt){
      return getBoundedListSub(url, tt).then((res){
        return res;
      });
    });
  }

  Future<dynamic> searchToBind({String userCondition,String userId})async{
    var url="$backendUrl/api/paybill/search_bind_list?userCondition=$userCondition&user_id=$userId";
    return getToken().then((tt){
      return searchBindList(url, tt).then((res){
        return res;
      });
    });
  }
  Future<dynamic> searchBindList(String url,String token,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: {"Authorization": token},
      encoding: encoding
      );
    if(request.statusCode==200){
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        MeterBind meterBind=new MeterBind();
        meterBind=MeterBind.fromJson(obj1[0]);
        return meterBind;
      }else{
        var obj=json.decode(request.body);
        MessageHandel.showError(context, "", obj["response_desc"]);
        return null;
      }
  }

  Future<dynamic> saveBind({MeterBind meterBind})async{
    var url="$backendUrl/api/paybill/save_bind";
    var body=meterBind.toJson();
    return getToken().then((tt){
      return saveMeter(url, tt,body: body).then((res){
        return res;
      });
    });
  }
  Future<dynamic> saveMeter(String url,String token,{dynamic body,dynamic encoding})async{
    var request=await http.post(
      url,
      headers: { 
              "Content-Type": "application/x-www-form-urlencoded",
              "Accept": "application/json",
              "Authorization": token},
      body: body,
      encoding: Encoding.getByName("utf-8")
      );
      if(request.statusCode==200){
        var obj=json.decode(request.body);
        var obj1=json.decode(obj);
        MeterBind meter=new MeterBind();
        meter=MeterBind.fromJson(obj1);
        return meter;
      }
  }

  Future<dynamic> getAmountStatement({String userId}){
    var url="$backendUrl/api/payment/amount_statement?user_id=$userId";
    return getToken().then((tt){
      return amountStateMentPost(url, tt).then((res){
        return res;
      });
    });
  }
  Future<List<AmountStatement>> amountStateMentPost(String url,String token,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: {"Authorization": token},
      encoding: encoding
      );
      if(request.statusCode==200){
        setTempValue(request.body);
        var obj=json.decode(request.body);
        List<dynamic> obj1=json.decode(obj);
        List<AmountStatement> amountStatement=new List<AmountStatement>();
        for (var i = 0; i < obj1.length; i++) {
          amountStatement.add(AmountStatement.fromJson(obj1[i]));
        }
        return amountStatement;
      }
      else{
        return null;
      }
  }
  setTempValue(String responseString)async{
    await db.setData(responseString, DataKeyValue.topupList);
  }

  Future<dynamic> requestBillPay({String customerNo,String invoiceNo,String userId}){
    var url="$backendUrl/api/paybill/req_bill?customer_no=$customerNo&invoice_no=$invoiceNo&user_id=$userId";
    return getToken().then((tt){
      return requestPost(url, tt).then((res){
        return res;
      });
    });
  }
  Future<RequestBill> requestPost(String url,String token,{dynamic encoding})async{
    var request=await http.post(
      url,
      headers: {"Authorization": token},
      encoding: encoding
      );
      if(request.statusCode==200){
        var obj=json.decode(request.body);
        dynamic obj1=json.decode(obj);
        RequestBill requestBill=new RequestBill();
        requestBill=RequestBill.fromJson(obj1);
        if(requestBill.subscriberStatus=="valid"){
          return requestBill;
        }
        else{
          setResponseMessage("Invalid Invoice No");
          Future.delayed(Duration(milliseconds: 200));
          return null;
        }
      }
      else{
        if(request.body!=null){
          var obj=json.decode(request.body);
          setResponseMessage(obj["response_desc"]);
          Future.delayed(Duration(milliseconds: 200));
        }
        return null;
      }
  }
  setResponseMessage(String bodyText)async{
    await db.setData(bodyText, DataKeyValue.requestErrorMsg);
  }

  Future<dynamic> payMeterBill({String paymount,String customerNo,String invoiceNo,String userId}){
    var url="$backendUrl/api/paybill/pay_bill?pay_amount=$paymount&customer_no=$customerNo&invoice_no=$invoiceNo&user_id=$userId";
    return getToken().then((tt){
      return payPost(url, tt).then((res){
        return res;
      });
    });
  }
  Future<RequestBill> payPost(String url,String token,{dynamic encoding})async{
    var request=await http.post(url,headers: {"Authorization": token},encoding: encoding);
      if(request.statusCode==200){
        var obj=json.decode(request.body);
        dynamic obj1=json.decode(obj);
        RequestBill requestBill=new RequestBill();
        requestBill=RequestBill.fromJson(obj1);
        if(requestBill.subscriberStatus=="valid"){
          return requestBill;
        }
        else{
          setResponseMessage("Invalid Invoice No");
          Future.delayed(Duration(milliseconds: 200));
          return null;
        }
      }
      else{
        if(request.body!=null){
          var obj=json.decode(request.body);
          setResponseMessage(obj["response_desc"]);
          Future.delayed(Duration(milliseconds: 200));
        }
        return null;
      }
  }
}
