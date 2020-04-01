class User{
  int _code;
  int _userId;
  String _userName;
  String _nickName;
  String _picUrl;

  User({
    int code,
    int userId,
    String userName,
    String nickName,
  String picUrl}){
    this._code = code;
    this._userId = userId;
    this._userName = userName;
    this._nickName = nickName;
    this._picUrl = picUrl;
  }

  User.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _userId = json['id'];
    _userName = json['username'];
    _nickName = json['nickname'];
    _picUrl = json['pic_url'];
  }

  User.fromNetJson(Map<String, dynamic> json) {
    _code = json['code'];
    var data = json['data'];
    _userId = data['id'];
    _userName = data['username'];
    _nickName = data['nickname'];
    _picUrl = data['pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = _code;
    data['id'] = _userId;
    data['username'] = _userName;
    data['nickname'] = _nickName;
    data['pic_url'] = _picUrl;
    return data;
  }

  String get picUrl => _picUrl;

  set picUrl(String value) {
    _picUrl = value;
  }

  int get code => _code;

  set code(int value) {
    _code = value;
  }

  int get userId => _userId;

  set userId(int value) {
    _userId = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get nickName => _nickName;

  set nickName(String value) {
    _nickName = value;
  }

}