class PaidBillRecord {
  String holdNo;
  String customerId;
  String receiptNo;
  String payMethod;
  String amount;
  int diffreentAmount;
  String phone;
  String payDate;
  String subscriberStatus;
  String invoiceNo;

  PaidBillRecord(
      {this.holdNo,
      this.customerId,
      this.receiptNo,
      this.payMethod,
      this.amount,
      this.diffreentAmount,
      this.phone,
      this.payDate,
      this.subscriberStatus,
      this.invoiceNo});

  PaidBillRecord.fromJson(Map<String, dynamic> json) {
    holdNo = json['hold_no'];
    customerId = json['customer_id'];
    receiptNo = json['receipt_no'];
    payMethod = json['pay_method'];
    amount = json['amount'];
    diffreentAmount = json['diffreent_amount'];
    phone = json['phone'];
    payDate = json['pay_date'];
    subscriberStatus = json['subscriber_status'];
    invoiceNo = json['invoice_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hold_no'] = this.holdNo;
    data['customer_id'] = this.customerId;
    data['receipt_no'] = this.receiptNo;
    data['pay_method'] = this.payMethod;
    data['amount'] = this.amount;
    data['diffreent_amount'] = this.diffreentAmount;
    data['phone'] = this.phone;
    data['pay_date'] = this.payDate;
    data['subscriber_status'] = this.subscriberStatus;
    data['invoice_no'] = this.invoiceNo;
    return data;
  }
}