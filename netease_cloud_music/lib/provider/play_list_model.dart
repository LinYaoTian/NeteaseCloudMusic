import 'package:flutter/material.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/model/user.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';

class PlayListModel with ChangeNotifier {
  User user;

  List<SongList> _selfCreatePlayList = []; // 我创建的歌单
  List<SongList> _collectPlayList = []; // 收藏的歌单

  List<SongList> get selfCreatePlayList => _selfCreatePlayList;
  List<SongList> get collectPlayList => _collectPlayList;

  void addCollectPlayList(SongList songList){
    songList.isCollected = true;
    _collectPlayList.add(songList);
    _selfCreatePlayList.forEach((e){
      if(e.id == songList.id) {
        e.isCollected = true;
      }
    });
    notifyListeners();
  }

  void delCollectPlayList(int id) {
    _collectPlayList.removeWhere((e){
      return id == e.id;
    });
    _selfCreatePlayList.forEach((e){
      if(e.id == id) {
        e.isCollected = false;
      }
    });
    notifyListeners();
  }

  void addSelfCreatePlayList(SongList songList){
    _selfCreatePlayList.add(songList);
    notifyListeners();
  }

  void delSelfCreatePlayList(SongList songList) {
    _selfCreatePlayList.removeWhere((e){
      return e.id == songList.id;
    });
    _collectPlayList.removeWhere((e){
      return e.id == songList.id;
    });
    notifyListeners();
  }

  void updateSelfCreatePlayList(SongList songList) {
    if(songList == null) {
      return;
    }
    var index = _selfCreatePlayList.indexWhere((e){
      return e.id == songList.id;
    });
    if(index != -1) {
      _selfCreatePlayList[index] = songList;
    }
    notifyListeners();
  }

  void requestSelfPlaylistData(BuildContext context) async{
    var result = await NetUtils.getSelfPlaylistData(context, params: {'user_id': user.userId});
    _selfCreatePlayList = result.selfSongLists;
    _collectPlayList = result.collectSongLists;
    notifyListeners();
  }
}
