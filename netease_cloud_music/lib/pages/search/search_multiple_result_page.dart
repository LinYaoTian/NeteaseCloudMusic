import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/model/search_result.dart';
import 'package:netease_cloud_music/model/singer.dart';
import 'package:netease_cloud_music/model/music.dart';
import 'package:netease_cloud_music/model/song.dart' as prefix0;
import 'package:netease_cloud_music/model/song.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/provider/play_songs_model.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';
import 'package:netease_cloud_music/widgets/v_empty_view.dart';
import 'package:netease_cloud_music/widgets/widget_singer.dart';
import 'package:netease_cloud_music/widgets/widget_future_builder.dart';
import 'package:netease_cloud_music/widgets/widget_music_list_item.dart';
import 'package:netease_cloud_music/widgets/widget_search_play_list.dart';
import 'package:provider/provider.dart';

/// 综合搜索结果页
class SearchMultipleResultPage extends StatefulWidget {
  final String keywords;
  final ValueChanged onTapMore; // 点击更多的时候需要跳转到哪一个 tab 页
  final ValueChanged onTapSimText;

  SearchMultipleResultPage(this.keywords,
      {@required this.onTapMore, @required this.onTapSimText});

  @override
  _SearchMultipleResultPageState createState() =>
      _SearchMultipleResultPageState();
}

class _SearchMultipleResultPageState extends State<SearchMultipleResultPage>
    with AutomaticKeepAliveClientMixin {
  // 构建模块基础模板
  Widget _buildModuleTemplate(String title,
      {@required List<Widget> contentWidget,
      Widget titleTrail,
      String moreText,
      VoidCallback onMoreTextTap}) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: bold18TextStyle,
            ),
            Spacer(),
            titleTrail ?? Container(),
          ],
        ),
        VEmptyView(20),
        ...contentWidget,
        moreText != null ? VEmptyView(10) : Container(),
        moreText != null
            ? _buildMoreText(moreText, onMoreTextTap)
            : Container(),
      ],
    );
  }

  // 构建单曲模块
  Widget _buildSearchSongs(List<Song> songs) {
    return Consumer<PlaySongsModel>(
      builder: (context, model, child) {
        List<Widget> children = [];
        for (int i = 0; i < songs.length; i++) {
          children.add(WidgetMusicListItem(
            SongItem(
                songName: songs[i].name,
                id: songs[i].id,
                picUrl: songs[i].picUrl,
                artists: songs[i].singerName),
            onTap: () {
              _playSong(model, songs[i]);
            },
          ));
        }
        return _buildModuleTemplate("单曲",
            contentWidget: [
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: children,
              ),
            ],
            titleTrail: GestureDetector(
              onTap: () {
                _playSongs(model, songs, 0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15),
                    vertical: ScreenUtil().setWidth(5)),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xfff2f2f2)),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.black87,
                    ),
                    HEmptyView(2),
                    Text(
                      '播放全部',
                      style: common14TextStyle,
                    ),
                  ],
                ),
              ),
            ),
            moreText: '查看更多', onMoreTextTap: () {
          widget.onTapMore(1);
        });
      },
    );
  }

  // 构建歌单模块
  Widget _buildSearchPlayList(List<SongList> songLists) {
    return _buildModuleTemplate('歌单',
        contentWidget: <Widget>[
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: songLists.map((p) {
              return SearchPlayListWidget(
                id: p.id,
                name: p.name,
                url: p.picUrl,
                playCount: p.number,
                info: '${p.number}首 by${p.ownerNickName}',
              );
            }).toList(),
          ),
        ],
        moreText: "查看更多", onMoreTextTap: () {
      widget.onTapMore(2);
    });
  }

  //构建歌手模块
  Widget _buildSearchSingers(List<Singer> singers) {
    return _buildModuleTemplate('歌手',
        contentWidget: [
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: singers.map((a) {
              return SingersWidget(
                  picUrl: a.picUrl, name: a.name, accountId: a.id);
            }).toList(),
          ),
        ],
        moreText: '查看更多', onMoreTextTap: () {
      widget.onTapMore(3);
    });
  }

  // 构建更多文字
  Widget _buildMoreText(String text, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              text,
              style: common14GrayTextStyle,
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  void _playSong(PlaySongsModel model, Song song) {
    model.playSong(song);
    NavigatorUtil.goPlaySongsPage(context);
  }

  void _playSongs(PlaySongsModel model, List<Song> data, int index) {
    model.playSongs(
      data
          .map((r) => prefix0.Song(
                r.id,
                name: r.name,
                picUrl: r.picUrl,
                singerName: r.singerName,
              ))
          .toList(),
      index: index,
    );
    NavigatorUtil.goPlaySongsPage(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomFutureBuilder<SearchMultipleData>(
      futureFunc: NetUtils.searchMultiple,
      params: {'key': widget.keywords, 'type': -1, 'offset': 0},
      builder: (context, data) {
        return ListView(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20),
              vertical: ScreenUtil().setWidth(20)),
          children: <Widget>[
            _buildSearchSongs(data.result.songs),
            VEmptyView(20),
            _buildSearchPlayList(data.result.songLists),
            VEmptyView(20),
            _buildSearchSingers(data.result.singers),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
