import 'package:netease_cloud_music/model/song.dart';
import 'package:netease_cloud_music/model/songlists.dart';

import 'singer.dart';

class SearchMultipleData {
  Result result;
  int code;

  SearchMultipleData({
    this.result,
    this.code,
  });

  SearchMultipleData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result = Result.fromNetJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    if(result != null) {
      data['data'] = result.toJson();
    }
    return data;
  }
}

class Result{
  List<Song> songs;
  List<Singer> singers;
  List<SongList> songLists;

  Result.fromNetJson(Map<String, dynamic> json) {
    if (json['songs'] != null) {
      songs = new List<Song>();
      json['songs'].forEach((v) {
        songs.add(new Song.fromNetJson(v));
      });
    }
    if (json['singers'] != null) {
      singers = new List<Singer>();
      json['singers'].forEach((v) {
        singers.add(new Singer.fromJson(v));
      });
    }
    if (json['songlists'] != null) {
      songLists = new List<SongList>();
      json['songlists'].forEach((v) {
        songLists.add(new SongList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songs != null) {
      data['songs'] = this.songs.map((v) => v.toJson()).toList();
    }
    if (this.singers != null) {
      data['singers'] = this.singers.map((v) => v.toJson()).toList();
    }
    if (this.songLists != null) {
      data['songLists'] = this.songLists.map((v) => v.toJson()).toList();
    }
    return data;
  }

}