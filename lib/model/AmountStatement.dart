class AmountStatement {
  int id;
  int userId;
  String userName;
  int paymentId;
  int paymentName;
  double value;
  String remark;
  String addTime;

  AmountStatement(
      {this.id,
      this.userId,
      this.userName,
      this.paymentId,
      this.paymentName,
      this.value,
      this.remark,
      this.addTime});

  AmountStatement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    paymentId=json['payment_id'];
    paymentName=json['payment_name'];
    value = json['value'];
    remark = json['remark'];
    addTime = json['add_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['payment_id']=this.paymentId;
    data['payment_name']=this.paymentName;
    data['value'] = this.value;
    data['remark'] = this.remark;
    data['add_time'] = this.addTime;
    return data;
  }
}