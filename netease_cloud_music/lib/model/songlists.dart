
import 'package:flutter/foundation.dart';
import 'package:netease_cloud_music/model/song.dart';

class SongListData {
  int _code;
  List<SongList> _songLists;

  SongListData(
      {int code,
        List<SongList> recommend}) {
    this._code = code;
    this._songLists = recommend;
  }

  SongListData.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    if (json['data'] != null) {
      _songLists = new List<SongList>();
      json['data'].forEach((v) {
        _songLists.add(new SongList.fromJson(v));
      });
    }
  }

  SongListData.fromNetJson(Map<String, dynamic> json) {
    _code = json['code'];
    if (json['data'] != null) {
      _songLists = new List<SongList>();
      json['data'].forEach((v) {
        _songLists.add(new SongList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    if (this._songLists != null) {
      data['data'] = this._songLists.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int get code => _code;
  set code(int code) => _code = code;
  List<SongList> get songLists => _songLists;
  set songLists(List<SongList> recommend) => _songLists = recommend;
}

class SongList {
  int _id;
  String _name;
  int _number;
  int _ownerId;
  String _ownerNickName;
  String _ownerPicUrl;
  String _intro;
  String _picUrl;
  bool _isCollected = false;
  List<Song> _songs;

  SongList({int id, String name, int number, int ownerId, String intro,
      String picUrl, String ownerNickName, List<Song> songs, bool isCollected, String ownerPicUrl}){
    _id = id;
    _name = name;
    _number = number;
    _ownerId = ownerId;
    _intro = intro;
    _picUrl = picUrl;
    _ownerNickName = ownerNickName;
    _songs = songs;
    _isCollected = isCollected;
    _ownerPicUrl = ownerPicUrl;
  }

  @override
  String toString() {
    return 'SongList{_id: $_id, _name: $_name, _number: $_number, _ownerId: $_ownerId, _ownerNickName: $_ownerNickName, _ownerPicUrl: $_ownerPicUrl, _intro: $_intro, _picUrl: $_picUrl, _isCollected: $_isCollected, _songs: $_songs}';
  }

  SongList.fromNetJson(Map<String, dynamic> json) {
    var data = json['data'];
    if(data['song_list_info'] != null) {
      var info = data['song_list_info'];
      _name = info['name'];
      _number = info['number'];
      _ownerId = info['owner_id'];
      _intro = info['intro'];
      _picUrl = info['pic_url'];
      _ownerNickName = info['owner_nickname'];
      _ownerPicUrl = info['owner_pic_url'];
      _id = info['id'];
      if(info['is_collected'] != null) {
        _isCollected =  info['is_collected'];
      }
    }
    if (data['songs'] != null) {
      _songs = new List<Song>();
      data['songs'].forEach((v) {
        _songs.add(new Song.fromNetJson(v));
      });
    }
  }

  SongList.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return;
    }
    _id = json['id'];
    _name = json['name'];
    _number = json['number'];
    _ownerId = json['owner_id'];
    _intro = json['intro'];
    _picUrl = json['pic_url'];
    _ownerNickName = json['owner_nickname'];
    _ownerPicUrl = json['owner_pic_url'];
    if(json['is_collected'] != null) {
      _isCollected =  json['is_collected'];
    }
    if (json['songs'] != null) {
      _songs = new List<Song>();
      json['songs'].forEach((v) {
        _songs.add(new Song.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['pic_url'] = this._picUrl;
    data['number'] = this._number;
    data['owner_id'] = this._ownerId;
    data['intro'] = this._intro;
    data['owner_nickname'] = this._ownerNickName;
    data['owner_pic_url'] = this._ownerPicUrl;
    data['is_collected'] = this._isCollected;
    if (this._songs != null) {
      data['songs'] = this.songs.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String get ownerPicUrl => _ownerPicUrl;

  set ownerPicUrl(String value) {
    _ownerPicUrl = value;
  }

  String get ownerNickName => _ownerNickName;

  set ownerNickName(String value) {
    _ownerNickName = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get number => _number;

  set number(int value) {
    _number = value;
  }

  int get ownerId => _ownerId;

  set ownerId(int value) {
    _ownerId = value;
  }

  String get intro => _intro;

  set intro(String value) {
    _intro = value;
  }

  String get picUrl => _picUrl;

  set picUrl(String value) {
    _picUrl = value;
  }

  List<Song> get songs => _songs;

  set songs(List<Song> value) {
    _songs = value;
  }

  bool get isCollected => _isCollected;

  set isCollected(bool value) {
    _isCollected = value;
  }


}
