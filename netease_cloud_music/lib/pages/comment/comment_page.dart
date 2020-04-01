import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:netease_cloud_music/constans/config.dart';
import 'package:netease_cloud_music/model/comment_head.dart';
import 'package:netease_cloud_music/model/song_comment.dart';
import 'package:netease_cloud_music/pages/comment/comment_type.dart';
import 'package:netease_cloud_music/provider/user_model.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/number_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';
import 'package:netease_cloud_music/widgets/rounded_net_image.dart';
import 'package:netease_cloud_music/widgets/v_empty_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:netease_cloud_music/widgets/widget_load_footer.dart';
import 'package:netease_cloud_music/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';

import 'comment_input_widget.dart';

class CommentPage extends StatefulWidget {
  final CommentHead commentHead;

  CommentPage(this.commentHead);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Map<String, int> params;
  List<Comment> commentData = [];
  EasyRefreshController _controller;
  FocusNode _blankNode = FocusNode();
  SongCommentData curRequestData;
  UserModel userModel;


  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      params = {
        'song_id': widget.commentHead.songId,
        'offset':0
      };
      _request();
    });
  }

  void _request() async {
    curRequestData = await NetUtils.getSongCommentData(context, params: params);
    setState(() {
      commentData.addAll(curRequestData.comments);
    });
  }

  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text('评论'),
        ),
        body: Stack(
          children: <Widget>[
            Listener(
              onPointerDown: (d){
                FocusScope.of(context).requestFocus(_blankNode);
              },
              child: EasyRefresh(
                footer: LoadFooter(),
                controller: _controller,
                onLoad: () async {
                  params['offset'] == null
                      ? params['offset'] = 2
                      : params['offset']++;
                  _request();
                  _controller.finishLoad(
                      noMore: curRequestData.comments.length < 15);
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildHead(),
                      Container(
                        height: ScreenUtil().setWidth(20),
                        color: Color(0xfff5f5f5),
                      ),
                      ListView.separated(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(30),
                              right: ScreenUtil().setWidth(30),
                              bottom: ScreenUtil().setWidth(50),
                              top: ScreenUtil().setWidth(50)),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildCommentItem(commentData[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(30)),
                              height: ScreenUtil().setWidth(1.5),
                              color: Color(0xfff5f5f5),
                            );
                          },
                          itemCount: commentData.length),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              child: CommentInputWidget((content){
                // 提交评论
                NetUtils.sendComment(context, params: {
                  'song_id': widget.commentHead.songId,
                  'content': content,
                  'time': DateTime.now().millisecondsSinceEpoch
                }).then((r){
                  Utils.showToast('评论成功！');
                  setState(() {
                    print('sendComment = $r');
                    commentData.insert(0, r);
                  });
                });
              }),
              alignment: Alignment.bottomCenter,
            )
          ],
        ));
  }

  Widget buildCommentItem(Comment data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RoundImgWidget(data.picUrl, 70),
        HEmptyView(10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    data.nickname,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Spacer(),
                  data.userId != userModel.user.userId ? Container():InkWell(
                      child: Icon(
                        Icons.delete,
                        color: Colors.black45),
                      onTap: (){
                        NetUtils.deleteComment(context, params: {'comment_id':data.id})
                            .then((v){
                            if(v != null && v.code == CODE_OK) {
                              setState(() {
                                Utils.showToast('删除成功！');
                                commentData.remove(data);
                              });
                            } else {
                              Utils.showToast(v.msg);
                            }
                        });
                      })
                ],
              ),
              VEmptyView(5),
              Text(
                DateUtil.getDateStrByMs(data.time,
                    format: DateFormat.YEAR_MONTH_DAY),
                style: smallGrayTextStyle,
              ),
              VEmptyView(20),
              Text(
                data.content,
                style:
                    TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildHead() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setWidth(20)),
      child: Row(
        children: <Widget>[
          RoundedNetImage(
            '${widget.commentHead.img}?param=200y200',
            width: 120,
            height: 120,
            radius: 4,
          ),
          HEmptyView(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.commentHead.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: commonTextStyle,
                ),
                VEmptyView(10),
                Text(
                  widget.commentHead.author,
                  style: common14TextStyle,
                )
              ],
            ),
          ),
          HEmptyView(20),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
    );
  }
}
