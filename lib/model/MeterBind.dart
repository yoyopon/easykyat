class MeterBind {
  int id;
  int userId;
  String userName;
  String oauthName;
  String oauthAccessToken;
  String oauthOpenid;
  String addTime;
  String oauthSecret;
  String endPoint;
  String issued;
  String expires;
  String lastAccess;
  int categoryId;
  int siteId;
  int channelId;
  String timestamp;

  MeterBind(
      {this.id,
      this.userId,
      this.userName,
      this.oauthName,
      this.oauthAccessToken,
      this.oauthOpenid,
      this.addTime,
      this.oauthSecret,
      this.endPoint,
      this.issued,
      this.expires,
      this.lastAccess,
      this.categoryId,
      this.siteId,
      this.channelId,
      this.timestamp});

  MeterBind.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    oauthName = json['oauth_name'];
    oauthAccessToken = json['oauth_access_token'];
    oauthOpenid = json['oauth_openid'];
    addTime = json['add_time'];
    oauthSecret = json['oauth_secret'];
    endPoint = json['end_point'];
    issued = json['issued'];
    expires = json['expires'];
    lastAccess = json['last_access'];
    categoryId = json['category_id'];
    siteId = json['site_id'];
    channelId = json['channel_id'];
    timestamp = json['Timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['user_id'] = this.userId.toString();
    data['user_name'] = this.userName;
    data['oauth_name'] = this.oauthName;
    data['oauth_access_token'] = this.oauthAccessToken;
    data['oauth_openid'] = this.oauthOpenid;
    data['add_time'] = this.addTime;
    data['oauth_secret'] = this.oauthSecret;
    data['end_point'] = this.endPoint;
    data['issued'] = this.issued;
    data['expires'] = this.expires;
    data['last_access'] = this.lastAccess;
    data['category_id'] = this.categoryId.toString();
    data['site_id'] = this.siteId.toString();
    data['channel_id'] = this.channelId.toString();
    data['Timestamp'] = this.timestamp;
    return data;
  }
}