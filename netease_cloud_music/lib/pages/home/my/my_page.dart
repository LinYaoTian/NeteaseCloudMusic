import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/model/play_list.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/pages/home/my/playlist_title.dart';
import 'package:netease_cloud_music/provider/play_list_model.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/rounded_net_image.dart';
import 'package:netease_cloud_music/widgets/widget_create_play_list.dart';
import 'package:netease_cloud_music/widgets/widget_play_list_menu.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  bool selfPlayListOffstage = false;
  bool collectPlayListOffstage = false;
  PlayListModel _playListModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playListModel = Provider.of<PlayListModel>(context);
        _playListModel.requestSelfPlaylistData(context);
      }
    });
  }

  /// 构建「我创建的歌单」「收藏的歌单」
  Widget _buildPlayListItem(List<SongList> data) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var curPlayList = data[index];
          return ListTile(
            onTap: () {
              NavigatorUtil.goPlayListPage(context, data: curPlayList);
            },
            contentPadding: EdgeInsets.zero,
            title: Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(5)),
              child: Text(curPlayList.name),
            ),
            subtitle: Text(
              '${curPlayList.number}首',
              style: smallGrayTextStyle,
            ),
            leading: RoundedNetImage(
              '${curPlayList.picUrl}?param=150y150',
              width: 110,
              height: 110,
              radius: ScreenUtil().setWidth(12),
            ),
            trailing: SizedBox(
              height: ScreenUtil().setWidth(50),
              width: ScreenUtil().setWidth(70),
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                onPressed: () {
                  showModalBottomSheet<SongList>(
                      context: context,
                      builder: (context) {
                        return PlayListMenuWidget(curPlayList, _playListModel,
                            () {
                          NetUtils.deletePlaylist(context,
                                  params: {'songlist_id': curPlayList.id})
                              .then((v) {
                            if (v != null && v.statusCode == 200) {
                              setState(() {
                                _playListModel
                                    .delSelfCreatePlayList(curPlayList);
                              });
                              Navigator.pop(context);
                            } else
                              Utils.showToast('删除失败，请重试');
                          });
                        });
                      },
                      backgroundColor: Colors.transparent);
                },
                padding: EdgeInsets.zero,
              ),
            ),
          );
        },
        itemCount: data.length);
  }

  Widget _realBuildPlayList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PlaylistTitle(
            "创建的歌单",
            _playListModel.selfCreatePlayList.length,
                 () {
                setState(() {
                  selfPlayListOffstage = !selfPlayListOffstage;
                });
              },
                () {},
            trailing: SizedBox(
              height: ScreenUtil().setWidth(50),
              width: ScreenUtil().setWidth(70),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black87,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CreatePlayListWidget(
                          submitCallback: (name, intro) {
                            _createPlaylist(name, intro);
                          },
                        );
                      });
                },
                padding: EdgeInsets.zero,
              ),
            )),
        Offstage(
          offstage: selfPlayListOffstage,
          child: _buildPlayListItem(_playListModel.selfCreatePlayList),
        ),
        PlaylistTitle(
          "收藏的歌单",
          _playListModel.collectPlayList.length,
          () {
            setState(() {
              collectPlayListOffstage = !collectPlayListOffstage;
            });
          },
          () {},
        ),
        Offstage(
          offstage: collectPlayListOffstage,
          child: _buildPlayListItem(_playListModel.collectPlayList),
        ),
      ],
    );
  }

  /// 构建歌单
  Widget _buildPlayList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: _realBuildPlayList(),
    );
  }

  /// 创建歌单
  void _createPlaylist(String name, String intro) async {
    NetUtils.createPlaylist(context, params: {
      'name': name,
      'intro': intro,
      'user_id': _playListModel.user.userId
    }).catchError((e) {
      Utils.showToast('创建失败');
    }).then((result) {
      Utils.showToast('创建成功');
      Navigator.of(context).pop();
      setState(() {
        _playListModel.addSelfCreatePlayList(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xfff5f5f5),
              height: ScreenUtil().setWidth(25),
            ),
            _playListModel == null
                ? Container(
                    height: ScreenUtil().setWidth(400),
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  )
                : _buildPlayList(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
