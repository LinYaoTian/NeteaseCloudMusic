class User{
  int _code;
  int _userId;
  String _userName;
  String _nickName;

  User({
    int code,
    int userId,
    String userName,
    String nickName,}){
    this._code = code;
    this._userId = userId;
    this._userName = userName;
    this._nickName = nickName;
  }

  int get code => _code;

  set code(int value) {
    _code = value;
  }

  User.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _userId = json['id'];
    _userName = json['username'];
    _nickName = json['nickName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = _code;
    data['id'] = _userId;
    data['username'] = _userName;
    data['nickName'] = _nickName;
    return data;
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