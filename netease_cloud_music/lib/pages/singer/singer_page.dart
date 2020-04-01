import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/constans/config.dart';
import 'package:netease_cloud_music/model/music.dart';
import 'package:netease_cloud_music/model/singer.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/provider/play_list_model.dart';
import 'package:netease_cloud_music/provider/play_songs_model.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';
import 'package:netease_cloud_music/widgets/v_empty_view.dart';
import 'package:netease_cloud_music/widgets/widget_music_list_item.dart';
import 'package:netease_cloud_music/widgets/widget_play.dart';
import 'package:netease_cloud_music/widgets/widget_play_list_app_bar.dart';
import 'package:netease_cloud_music/widgets/widget_play_list_cover.dart';
import 'package:netease_cloud_music/widgets/widget_round_img.dart';
import 'package:netease_cloud_music/widgets/widget_singer_detail_app_bar.dart';
import 'package:netease_cloud_music/widgets/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

import '../../application.dart';

class SingerPage extends StatefulWidget {
  final int singerId;

  SingerPage(this.singerId);

  @override
  _SingerPageState createState() => _SingerPageState();
}

class _SingerPageState extends State<SingerPage> {
  double _expandedHeight = ScreenUtil().setWidth(530);
  SingerData _data;

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
                SingerInfoAppBarWidget(
                  sigma: 20,
                  playOnTap: (model) {
                    playSongs(model, 0);
                  },
                  content: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: _data == null
                          ? null
                          : Align(
                        alignment: Alignment.bottomLeft,
                              child: Text(
                                _data.singer.intro,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: smallWhite70TextStyle,
                              ),
                            ),
                    ),
                  ),
                  expandedHeight: _expandedHeight,
                  backgroundImg: _data == null ? '' : _data.singer.picUrl,
                  title: _data == null ? '' : _data.singer.name,
                  count: _data == null ? 0 : _data.songs.length,
                ),
                CustomSliverFutureBuilder<SingerData>(
                  futureFunc: NetUtils.getSingerData,
                  params: {'singer_id': widget.singerId},
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
                            artists: data.singer.name,
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

  void setData(SingerData data) {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    });
  }
}
