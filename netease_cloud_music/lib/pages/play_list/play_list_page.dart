import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/constans/config.dart';
import 'package:netease_cloud_music/model/comment_head.dart';
import 'package:netease_cloud_music/model/music.dart';
import 'package:netease_cloud_music/model/play_list.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/model/song.dart';
import 'package:netease_cloud_music/pages/comment/comment_type.dart';
import 'package:netease_cloud_music/pages/play_list/play_list_desc_dialog.dart';
import 'package:netease_cloud_music/provider/play_list_model.dart';
import 'package:netease_cloud_music/provider/play_songs_model.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';
import 'package:netease_cloud_music/widgets/v_empty_view.dart';
import 'package:netease_cloud_music/widgets/widget_footer_tab.dart';
import 'package:netease_cloud_music/widgets/widget_music_list_item.dart';
import 'package:netease_cloud_music/widgets/widget_play.dart';
import 'package:netease_cloud_music/widgets/widget_round_img.dart';
import 'package:netease_cloud_music/widgets/widget_play_list_app_bar.dart';
import 'package:netease_cloud_music/widgets/widget_play_list_cover.dart';
import 'package:netease_cloud_music/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

import '../../application.dart';

class PlayListPage extends StatefulWidget {
  final SongList data;

  PlayListPage(this.data);

  @override
  _PlayListPageState createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  double _expandedHeight = ScreenUtil().setWidth(530);
  SongList _data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom:
                    ScreenUtil().setWidth(110) + Application.bottomBarHeight),
            child: CustomScrollView(
              slivers: <Widget>[
                PlayListAppBarWidget(
                    sigma: 20,
                    playOnTap: (model) {
                      playSongs(model, 0);
                    },
                    content: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(35),
                          right: ScreenUtil().setWidth(35),
                          top: ScreenUtil().setWidth(120),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                PlayListCoverWidget(
                                  '${widget.data.picUrl}?param=200y200',
                                  width: 250,
                                  playCount: widget.data.number,
                                ),
                                HEmptyView(20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        widget.data.name,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: mWhiteBoldTextStyle,
                                      ),
                                      VEmptyView(10),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: _data == null
                                                ? Container()
                                                : Text(
                                                    '作者:${_data.ownerNickName}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        commonWhite70TextStyle,
                                                  ),
                                          )
                                        ],
                                      ),
                                      VEmptyView(10),
                                      _data != null && _data.intro != null
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    _data.intro,
                                                    style:
                                                        smallWhite70TextStyle,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            VEmptyView(15),
                          ],
                        ),
                      ),
                    ),
                    expandedHeight: _expandedHeight,
                    backgroundImg: widget.data.picUrl,
                    title: widget.data.name,
                    count: _data == null ? null : _data.number,
                    isCollected: widget.data.isCollected,
                    clickCollect: (){
                      NetUtils.collectPlaylist(context, params: {'songlist_id': widget.data.id}).then((v){
                        if(v != null && v.code == CODE_OK){
                          setState(() {
                            if(widget.data.isCollected) {
                              Utils.showToast('取消收藏歌单');
                              Provider.of<PlayListModel>(context).delCollectPlayList(widget.data.id);
                            } else {
                              Utils.showToast('收藏此歌单');
                              Provider.of<PlayListModel>(context).addCollectPlayList(widget.data);
                            }
                          });
                        }
                      });
                    },),
                CustomSliverFutureBuilder<SongList>(
                  futureFunc: NetUtils.getSongListDetail,
                  params: {'song_list_id': widget.data.id},
                  builder: (context, data) {
                    setData(data);
                    return Consumer<PlaySongsModel>(
                        builder: (context, model, child) {
                      return SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        var d = data.songs[index];
                        return WidgetMusicListItem(
                          SongItem(
                            id: d.id,
                            index: index + 1,
                            songName: d.name,
                            artists: d.singerName,
                          ),
                          onTap: () {
                            playSongs(model, index);
                          },
                        );
                      }, childCount: data.songs.length));
                    });
                  },
                ),
              ],
            ),
          ),
          PlayWidget(),
        ],
      ),
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      _data.songs,
      index: index,
    );
    NavigatorUtil.goPlaySongsPage(context);
  }

  void setData(SongList data) {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    });
  }
}
