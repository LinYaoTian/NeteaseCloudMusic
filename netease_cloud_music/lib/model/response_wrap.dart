/// code : -1
/// msg : "参数错误！"
/// data : null

class ResponseWrap {
  int _code;
  String _msg;
  dynamic _data;

  int get code => _code;
  String get msg => _msg;
  dynamic get data => _data;

  ResponseWrap(this._code, this._msg, this._data);

  ResponseWrap.fromJson(Map<String, dynamic> json) {
    if(json != null) {
      this._code = json["code"];
      this._msg = json["msg"];
      this._data = json["data"];
    }
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["code"] = _code;
    map["msg"] = _msg;
    map["data"] = _data;
    return map;
  }

}