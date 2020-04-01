import 'package:netease_cloud_music/model/song.dart';

class SingerData {
  int code;
  Singer singer;
  List<Song> songs = [];

  SingerData.name(this.code, this.singer, this.songs);

  @override
  String toString() {
    return 'SingerData{code: $code, singer: $singer, songs: $songs}';
  }

  SingerData.fromNetJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    code = json['id'];
    var data = json['data'];
    if (data != null) {
      singer = Singer.fromJson(data['singer']);
      songs = [];
      data['songs'].forEach((v){
        songs.add(Song.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['singer'] = singer.toJson();
    data['songs'] = songs.map((v){
      return v.toJson();
    }).toList();
    return data;
  }

}

class Singer{
  int _id;
  String _name;
  int _songsNumber;
  String _intro;
  String _picUrl;

  Singer.create(this._id, this._name, this._songsNumber, this._intro,
      this._picUrl);

  Singer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _songsNumber = json['songs_number'];
    _intro = json['intro'];
    _picUrl = json['pic_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['songs_number'] = songsNumber;
    data['intro'] = intro;
    data['pic_url'] = picUrl;
    return data;
  }

  String get picUrl => _picUrl;

  set picUrl(String value) {
    _picUrl = value;
  }

  String get intro => _intro;

  set intro(String value) {
    _intro = value;
  }

  int get songsNumber => _songsNumber;

  set songsNumber(int value) {
    _songsNumber = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}