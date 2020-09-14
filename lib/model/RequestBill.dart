class RequestBill {
  int id;
  String holdNo;
  String subscriberId;
  String currency;
  String totalAmount;
  String subscriberStatus;
  String productType;
  String udf1;
  String udf2;
  String udf3;
  String billInfo;
  String invoiceNo;
  String responseStatus;
  String responseDesc;
  String addTime;
  String errorMsg;

  RequestBill(
      {this.id,
      this.holdNo,
      this.subscriberId,
      this.currency,
      this.totalAmount,
      this.subscriberStatus,
      this.productType,
      this.udf1,
      this.udf2,
      this.udf3,
      this.billInfo,
      this.invoiceNo,
      this.responseStatus,
      this.responseDesc,
      this.addTime,
      this.errorMsg});

  RequestBill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holdNo = json['hold_no'];
    subscriberId = json['subscriber_id'];
    currency = json['currency'];
    totalAmount = json['total_amount'];
    subscriberStatus = json['subscriber_status'];
    productType = json['product_type'];
    udf1 = json['udf1'];
    udf2 = json['udf2'];
    udf3 = json['udf3'];
    billInfo = json['bill_info'];
    invoiceNo = json['invoice_no'];
    responseStatus = json['response_status'];
    responseDesc = json['response_desc'];
    addTime = json['add_time'];
    errorMsg = json['ErrorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hold_no'] = this.holdNo;
    data['subscriber_id'] = this.subscriberId;
    data['currency'] = this.currency;
    data['total_amount'] = this.totalAmount;
    data['subscriber_status'] = this.subscriberStatus;
    data['product_type'] = this.productType;
    data['udf1'] = this.udf1;
    data['udf2'] = this.udf2;
    data['udf3'] = this.udf3;
    data['bill_info'] = this.billInfo;
    data['invoice_no'] = this.invoiceNo;
    data['response_status'] = this.responseStatus;
    data['response_desc'] = this.responseDesc;
    data['add_time'] = this.addTime;
    data['ErrorMsg'] = this.errorMsg;
    return data;
  }
}

class BillInfo{
  String billno;
  int amount;
  String billdate;
  String duedate;

  BillInfo({this.billno,this.amount,this.billdate,this.duedate});

  BillInfo.fromJson(Map<String, dynamic> json) {
    billno = json['bill_no'];
    amount = json['amount'];
    billdate = json['bill_date'];
    duedate = json['due_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_no'] = this.billno;
    data['amount'] = this.amount;
    data['bill_date'] = this.billdate;
    data['due_date'] = this.duedate;
    return data;
  }
}