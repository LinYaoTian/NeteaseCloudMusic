import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/application.dart';
import 'package:netease_cloud_music/model/play_list.dart';
import 'package:netease_cloud_music/model/song.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/provider/play_list_model.dart';
import 'package:netease_cloud_music/provider/play_songs_model.dart';
import 'package:netease_cloud_music/provider/user_model.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/widget_edit_play_list.dart';
import 'package:provider/provider.dart';

class PlayingSongsMenuWidget extends StatefulWidget {
  final PlaySongsModel _model;

  PlayingSongsMenuWidget(this._model);

  @override
  _PlayingSongsMenuWidgetState createState() => _PlayingSongsMenuWidgetState();
}

class _PlayingSongsMenuWidgetState extends State<PlayingSongsMenuWidget> {
  Widget _buildMenuItem(bool isPlaying, Song song,
      {VoidCallback onTap, VoidCallback onDelete}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setWidth(110),
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40)
              ),
              child: isPlaying
                  ? Padding(
                padding: EdgeInsets.only(right:ScreenUtil().setWidth(10)), child: Icon(
                Icons.volume_up,
                color: Colors.red,
                size: ScreenUtil().setWidth(50),))
                  : null,
            ),
            Expanded(
              child: Text(
                "${song.name} - ${song.singerName}",
                style: TextStyle(
                    fontSize: 15,
                    color: isPlaying ? Colors.red : Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Builder(builder: (context){
              return !isPlaying ? InkWell(
                onTap: onDelete,
                child: Container(
                  width: ScreenUtil().setWidth(80),
                  child: Align(
                    child: Icon(
                      Icons.clear,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ) : Container();
            })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(40)),
              topRight: Radius.circular(ScreenUtil().setWidth(40))),
          color: Colors.white),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(100),
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              alignment: Alignment.centerLeft,
              child: Text(
                '播放歌曲列表 - ${widget._model.allSongs.length} 首',
                style: bold16RedTextStyle,
              ),
            ),
            Container(
              height: ScreenUtil().setWidth(0.5),
              color: Colors.black26,
            ),
            Container(
              height: ScreenUtil().setWidth(700),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return _buildMenuItem(index == widget._model.curIndex,
                      widget._model.allSongs[index], onTap: () {
                    setState(() {
                      widget._model.playSongByIndex(index);
                    });
                  }, onDelete: () {
                    setState(() {
                      widget._model.removeSongByIndex(index);
                    });
                  });
                },
                itemCount: widget._model.allSongs.length,
              ),
            ),
          ],
      ),
    );
  }
}
