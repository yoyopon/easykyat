class Notifications {
  int msgid;
  String action;
  String title;
  String contents;
  String notiDate;
  String imageUrl;
  String isRead;

  static Notifications notifications;

  Notifications(
      {this.msgid,
      this.action,
      this.title,
      this.contents,
      this.notiDate,
      this.imageUrl,
      this.isRead});

  Notifications.fromJson(Map<String, dynamic> json) {
    msgid = json['msgid'];
    action = json['action'];
    title = json['title'];
    contents = json['contents'];
    notiDate = json['notiDate'];
    imageUrl = json['imageUrl'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msgid'] = this.msgid;
    data['action'] = this.action;
    data['title'] = this.title;
    data['contents'] = this.contents;
    data['notiDate'] = this.notiDate;
    data['imageUrl'] = this.imageUrl;
    data['isRead'] = this.isRead;
    return data;
  }
}

class MessageCount{
  String allCount;
  String unreadCount;
  MessageCount({this.allCount,this.unreadCount});
}