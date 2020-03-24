import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/model/Singer.dart';
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
import 'package:netease_cloud_music/widgets/widget_artists.dart';
import 'package:netease_cloud_music/widgets/widget_load_footer.dart';
import 'package:netease_cloud_music/widgets/widget_music_list_item.dart';
import 'package:netease_cloud_music/widgets/widget_search_play_list.dart';
import 'package:provider/provider.dart';

typedef LoadMoreWidgetBuilder<T> = Widget Function(T data);

class SearchOtherResultPage extends StatefulWidget {
  final String type;
  final String keywords;

  SearchOtherResultPage(this.type, this.keywords);

  @override
  _SearchOtherResultPageState createState() => _SearchOtherResultPageState();
}

class _SearchOtherResultPageState extends State<SearchOtherResultPage>
    with AutomaticKeepAliveClientMixin {
  int _count = -1;

  Map<String, String> _params;
  List<Song> _songsData = []; // 单曲数据
  List<Singer> _singersData = []; // 专辑数据
  List<SongList> _songListsData = []; // 歌单数据
  EasyRefreshController _controller;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      _params = {'key': widget.keywords, 'type': widget.type};
      _request();
    });
  }

  void _request() async {
    print('_request() offset = $offset');
    _params['offset'] = offset.toString();
    offset++;
    var r = await NetUtils.searchMultiple(context, params: _params);
    if (mounted) {
      setState(() {
        switch (int.parse(widget.type)) {
          case 1: // 单曲
            _count = r.result.songs.length;
            _songsData.addAll(r.result.songs);
            break;
          case 2: // 歌单
            _count = r.result.songLists.length;
            _songListsData.addAll(r.result.songLists);
            break;
          case 3: // 歌手
            _count = r.result.singers.length;
            _singersData.addAll(r.result.singers);
            break;
          default:
            break;
        }
      });
    }
  }

  // 构建单曲页面
  Widget _buildSongsPage() {
    return Consumer<PlaySongsModel>(
      builder: (context, model, child) {
        return EasyRefresh.custom(
          slivers: [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  _playSongs(model, _songsData, 0);
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.black87,
                    ),
                    HEmptyView(10),
                    Text(
                      '播放全部',
                      style: common18TextStyle,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: VEmptyView(30),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var song = _songsData[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _playSongs(model, _songsData, index);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                      child: WidgetMusicListItem(SongItem(
                          songName: song.name,
                          id: song.id,
                          artists: song.singerName)),
                    ),
                  );
                },
                childCount: _songsData.length,
              ),
            )
          ],
          footer: LoadFooter(),
          controller: _controller,
          onLoad: () async {
            _request();
            _controller.finishLoad(noMore: _count < 15);
          },
        );
      },
    );
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

  // 构建歌手页面
  Widget _buildSingersPage() {
    return _buildLoadMoreWidget<Singer>(_singersData, (curData) {
      return SingersWidget(
        picUrl: curData.picUrl,
        name: curData.name,
        accountId: curData.id,
      );
    });
  }

  // 构建歌单页面
  Widget _buildPlayListPage() {
    return _buildLoadMoreWidget<SongList>(_songListsData, (curData) {
      return SearchPlayListWidget(
        id: curData.id,
        url: curData.picUrl,
        name: curData.name,
        playCount: curData.number,
        info: '${curData.number}首 by${curData.name}',
        width: 110,
      );
    });
  }

  Widget _buildLoadMoreWidget<T>(
      List<T> data, LoadMoreWidgetBuilder<T> builder) {
    return EasyRefresh.custom(
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return builder(data[index]);
        }, childCount: data.length))
      ],
      footer: LoadFooter(),
      controller: _controller,
      onLoad: () async {
        _request();
        _controller.finishLoad(noMore: _count < 15);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_count == -1) {
      return CupertinoActivityIndicator();
    }
    Widget result;
    switch (int.parse(widget.type)) {
      case 1: // 单曲
        result = _buildSongsPage();
        break;
      case 3: // 歌手
        result = _buildSingersPage();
        break;
      case 2: // 歌单
        result = _buildPlayListPage();
        break;
      default:
        result = Container();
        break;
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setWidth(20)),
      child: result,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
