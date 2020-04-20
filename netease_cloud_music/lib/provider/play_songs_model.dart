import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:netease_cloud_music/application.dart';
import 'package:netease_cloud_music/model/song.dart';
import 'package:netease_cloud_music/utils/fluro_convert_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';

enum PlayerOrder {
  ORDER,
  RANDOM,
  CYCLE
}

class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List<Song> _songs = [];
  List<Song> _shuffle = [];
  int curIndexShuffle = 0;
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  List<Song> get allSongs => _songs;
  Song get curSong => _songs.isNotEmpty ? _songs[curIndex] : null;
  Stream<String> get curPositionStream => _curPositionController.stream;
  AudioPlayerState get curState => _curState;


  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;
      /// 先做顺序播放
      if(state == AudioPlayerState.COMPLETED){
        nextPlay();
      }
      // 其实也只有在播放状态更新时才需要通知。
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
    });
    // 当前播放进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      sinkProgress(p.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds : p.inMilliseconds);
    });
  }

  // 歌曲进度
  void sinkProgress(int m){
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }

  void shuffle() {
    var oldSong = curSong;
    _songs.shuffle();
    curIndex = _songs.indexWhere((v){
      return v.id == oldSong.id;
    });
  }

  // 播放一首歌
  void playSong(Song song) {
    if (song == null) {
      return;
    }
    int index = _songs.indexWhere((s){
      return s.id == song.id;
    });
    if(index > -1) {
      curIndex = index;
    } else {
      _songs.insert(curIndex, song);
    }
    play();
  }

  // 播放一首歌
  void playSongByIndex(int index) {
    if(index > -1 && index < _songs.length) {
      curIndex = index;
      play();
    }
  }

  // 播放很多歌
  void playSongs(List<Song> songs, {int index}) {
    if(songs == null) {
      return;
    }
    this._songs = songs;
    curIndex = index ?? 0;
    if(curIndex < 0 || curIndex > _songs.length - 1) {
      curIndex = 0;
    }
    play();
  }

  // 添加歌曲
  void addSongs(List<Song> songs) {
    if(songs != null) {
      return;
    }
    this._songs.addAll(songs);
    if(curState != AudioPlayerState.PLAYING) {
      notifyListeners();
    }
  }

  // 添加歌曲
  void removeSongByIndex(int index) {
    if (index > -1 && index < _songs.length) {
      _songs.removeAt(index);
      if(curState != AudioPlayerState.PLAYING) {
        notifyListeners();
      }
    }
  }

  /// 播放
  void play() {
    if(_songs.length == 0){
      print('PlaySongsModel call play(): _songs is Empty !');
      return;
    }
    _audioPlayer.play(
        "https://music.163.com/song/media/outer/url?id=${this._songs[curIndex].id}.mp3");
    saveCurSong();
  }

  /// 暂停、恢复
  void togglePlay(){
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      resumePlay();
    } else {
      pausePlay();
    }
  }

  // 暂停
  void pausePlay() {
    _audioPlayer.pause();
  }

  /// 跳转到固定时间
  void seekPlay(int milliseconds){
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    resumePlay();
  }

  /// 恢复播放
  void resumePlay() {
    _audioPlayer.resume();
  }

  /// 下一首
  void nextPlay(){
    if(curIndex < _songs.length - 1) {
      curIndex++;
      play();
    } else {
      Utils.showToast('歌曲列表已播放完毕！');
      print('PlaySongsModel call nextPlay(): played all songs done !');
    }
  }

  void prePlay(){
    if(curIndex <= 0){
      Utils.showToast('没有上一首歌曲！');
      print('PlaySongsModel call prePlay(): played all songs done !');
    }else{
      curIndex--;
      play();
    }
  }

  // 保存当前歌曲到本地
  void saveCurSong(){
    Application.sp.remove('playing_songs');
    Application.sp.setStringList('playing_songs', _songs.map((s) => FluroConvertUtils.object2string(s)).toList());
    Application.sp.setInt('playing_index', curIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }


}
