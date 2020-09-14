import 'package:flutter/material.dart';
import 'package:ypay/dbHelper/DatabaseHelper.dart';
import 'package:ypay/model/MeterBind.dart';
import 'package:ypay/model/RequestBill.dart';
import 'MeterListRepository.dart';

abstract class MeterBillListContract{
  void showError(String msg);
  void showMessage(String msg);
  void getBoundedListSuccess(List<MeterBind> boundedList);
  void searchBoundListSuccess(MeterBind searchBound);
  void saveBindSuccess(MeterBind saveBind);
  void getAmountStatementSuccess(dynamic result);
  void requestMeterSuccess(RequestBill bill);
  void payMeterSuccess(dynamic result);
}

class MeterBillListPresenter{
  MeterBillListContract _contract;
  MeterBillListRepository _repostory;
  var db=DBHelper();

  MeterBillListPresenter(MeterBillListContract loginContract,BuildContext context){
    this._contract=loginContract;
    this._repostory=new MeterBillListRepository(context);
  }
  
  void getBoundedList({String userId}){
    _repostory.getBoundedList(userId:userId).then((res){
      _contract.getBoundedListSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void searchToBind({String userCondition,String userId}){
    _repostory.searchToBind(userCondition: userCondition,userId:userId).then((res){
      _contract.searchBoundListSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void saveBound({MeterBind meter}){
    _repostory.saveBind(meterBind:meter).then((res){
      _contract.saveBindSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void getTopupList({String userId}){
     _repostory.getAmountStatement(userId:userId).then((res){
      _contract.getAmountStatementSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void requestMeterToPay({String customerId,String invoiceId,String userId}){
    _repostory.requestBillPay(customerNo: customerId,invoiceNo: invoiceId,userId:userId).then((res){
      _contract.requestMeterSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

  void payMeter({String payamount,String customerId,String invoiceId,String userId}){
    _repostory.payMeterBill(paymount: payamount,customerNo: customerId,invoiceNo: invoiceId,userId:userId).then((res){
      _contract.payMeterSuccess(res);
    }).catchError((e){
      _contract.showError(e.toString());
    });
  }

}