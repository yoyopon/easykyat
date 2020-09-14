class User {
  int id;
  int groupId;
  String userName;
  String salt;
  String password;
  String mobile;
  String email;
  String avatar;
  String nickName;
  String sex;
  String birthday;
  String telphone;
  String area;
  String address;
  String qq;
  String msn;
  double amount;
  int point;
  int exp;
  int status;
  String regTime;
  String regIp;
  String securityStamp;
  String deviceId;
  String gpsLocation;
  String useLang;

  static User users;

  User(
      {this.id,
      this.groupId,
      this.userName,
      this.salt,
      this.password,
      this.mobile,
      this.email,
      this.avatar,
      this.nickName,
      this.sex,
      this.birthday,
      this.telphone,
      this.area,
      this.address,
      this.qq,
      this.msn,
      this.amount,
      this.point,
      this.exp,
      this.status,
      this.regTime,
      this.regIp,
      this.securityStamp,
      this.deviceId,
      this.gpsLocation,
      this.useLang});

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    groupId = int.parse(json['group_id'].toString());
    userName = json['user_name'].toString();
    salt = json['salt'].toString();
    password = json['password'].toString();
    mobile = json['mobile'].toString();
    email = json['email'].toString();
    avatar = json['avatar'].toString();
    nickName = json['nick_name'].toString();
    sex = json['sex'].toString();
    birthday = json['birthday'].toString();
    telphone = json['telphone'].toString();
    area = json['area'].toString();
    address = json['address'].toString();
    qq = json['qq'].toString();
    msn = json['msn'].toString();
    amount = double.parse(json['amount'].toString());
    point = int.parse(json['point'].toString());
    exp = int.parse(json['exp'].toString());
    status = int.parse(json['status'].toString());
    regTime = json['reg_time'].toString();
    regIp = json['reg_ip'].toString();
    securityStamp = json['security_stamp'].toString();
    deviceId = json['device_id'].toString();
    gpsLocation = json['gps_location'].toString();
    useLang = json['use_lang'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['group_id'] = this.groupId.toString();
    data['user_name'] = this.userName;
    data['salt'] = this.salt;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['nick_name'] = this.nickName;
    data['sex'] = this.sex;
    data['birthday'] = this.birthday;
    data['telphone'] = this.telphone;
    data['area'] = this.area;
    data['address'] = this.address;
    data['qq'] = this.qq;
    data['msn'] = this.msn;
    data['amount'] = this.amount.toString();
    data['point'] = this.point.toString();
    data['exp'] = this.exp.toString();
    data['status'] = this.status.toString();
    data['reg_time'] = this.regTime;
    data['reg_ip'] = this.regIp;
    data['security_stamp'] = this.securityStamp;
    data['device_id'] = this.deviceId;
    data['gps_location'] = this.gpsLocation;
    data['use_lang'] = this.useLang;
    return data;
  }
}

class UserRegister {
  int iId;
  int iGroupId;
  String sUserName;
  String sSalt;
  String sPassword;
  String sMobile;
  String sEmail;
  String sAvatar;
  String sNickName;
  String sSex;
  String sBirthday;
  String sTelphone;
  String sArea;
  String sAddress;
  String sQq;
  String sMsn;
  int iAmount;
  int iPoint;
  int iExp;
  int iStatus;
  String sRegTime;
  String sRegIp;
  String sSecurityStamp;
  String sDeviceId;
  String sGpsLocation;
  String sUseLang;

  UserRegister(
      {this.iId,
      this.iGroupId,
      this.sUserName,
      this.sSalt,
      this.sPassword,
      this.sMobile,
      this.sEmail,
      this.sAvatar,
      this.sNickName,
      this.sSex,
      this.sBirthday,
      this.sTelphone,
      this.sArea,
      this.sAddress,
      this.sQq,
      this.sMsn,
      this.iAmount,
      this.iPoint,
      this.iExp,
      this.iStatus,
      this.sRegTime,
      this.sRegIp,
      this.sSecurityStamp,
      this.sDeviceId,
      this.sGpsLocation,
      this.sUseLang});

  UserRegister.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    iGroupId = json['_group_id'];
    sUserName = json['_user_name'];
    sSalt = json['_salt'];
    sPassword = json['_password'];
    sMobile = json['_mobile'];
    sEmail = json['_email'];
    sAvatar = json['_avatar'];
    sNickName = json['_nick_name'];
    sSex = json['_sex'];
    sBirthday = json['_birthday'];
    sTelphone = json['_telphone'];
    sArea = json['_area'];
    sAddress = json['_address'];
    sQq = json['_qq'];
    sMsn = json['_msn'];
    iAmount = json['_amount'];
    iPoint = json['_point'];
    iExp = json['_exp'];
    iStatus = json['_status'];
    sRegTime = json['_reg_time'];
    sRegIp = json['_reg_ip'];
    sSecurityStamp = json['_security_stamp'];
    sDeviceId = json['_device_id'];
    sGpsLocation = json['_gps_location'];
    sUseLang = json['_use_lang'];
  }

  static UserRegister userRegister;
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['_group_id'] = this.iGroupId;
    data['_user_name'] = this.sUserName;
    data['_salt'] = this.sSalt;
    data['_password'] = this.sPassword;
    data['_mobile'] = this.sMobile;
    data['_email'] = this.sEmail;
    data['_avatar'] = this.sAvatar;
    data['_nick_name'] = this.sNickName;
    data['_sex'] = this.sSex;
    data['_birthday'] = this.sBirthday;
    data['_telphone'] = this.sTelphone;
    data['_area'] = this.sArea;
    data['_address'] = this.sAddress;
    data['_qq'] = this.sQq;
    data['_msn'] = this.sMsn;
    data['_amount'] = this.iAmount;
    data['_point'] = this.iPoint;
    data['_exp'] = this.iExp;
    data['_status'] = this.iStatus;
    data['_reg_time'] = this.sRegTime;
    data['_reg_ip'] = this.sRegIp;
    data['_security_stamp'] = this.sSecurityStamp;
    data['_device_id'] = this.sDeviceId;
    data['_gps_location'] = this.sGpsLocation;
    data['_use_lang'] = this.sUseLang;
    return data;
  }
}