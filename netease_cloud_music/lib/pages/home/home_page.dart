import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/constans/config.dart';
import 'package:netease_cloud_music/provider/user_model.dart';
import 'package:netease_cloud_music/route/routes.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/rounded_net_image.dart';
import 'package:netease_cloud_music/widgets/v_empty_view.dart';
import 'package:netease_cloud_music/widgets/widget_play.dart';
import 'package:netease_cloud_music/widgets/widget_round_img.dart';
import 'package:provider/provider.dart';

import '../../application.dart';
import 'discover/discover_page.dart';
import 'my/my_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  int _iconIndex = 0;
  List<IconData> _iconDataList = [Icons.search, Icons.person];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener((){
      setState(() {
        _iconIndex = _tabController.index;
    });});
  }


  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context);
    return Scaffold(
      // 设置没有高度的 appbar，目的是为了设置状态栏的颜色
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.zero,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Padding(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(150)),
                        child: TabBar(
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(fontSize: 14),
                          indicator: UnderlineTabIndicator(),
                          controller: _tabController,
                          tabs: [
                            Tab(
                              text: '发现',
                            ),
                            Tab(
                              text: '我的',
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: ScreenUtil().setWidth(20),
                        child: IconButton(
                          icon: Icon(
                            _iconDataList[_iconIndex],
                            size: ScreenUtil().setWidth(50),
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            if(_tabController.index == 0) {
                              NavigatorUtil.goSearchPage(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return MyInfoWidget(picUrl:userModel.user.picUrl, nickName: userModel.user.nickName, submitCallback:(String nickName, String password, String picUrl){
                                      Map<String,String> params = {};
                                      if(password != null && password.isNotEmpty) {
                                        params['password'] = password;
                                      }
                                      params['nickname'] = nickName;
                                      params['pic_url'] = picUrl;
                                      NetUtils.updateUserInfo(context, params: params).then((v){
                                        if(v != null && v.code == CODE_OK) {
                                          userModel.user.nickName = nickName;
                                          userModel.user.picUrl = picUrl;
                                          userModel.saveUserInfo(userModel.user);
                                          Utils.showToast('更新成功！');
                                          Navigator.of(context).pop();
                                        } else {
                                          Utils.showToast(v.msg ?? '更新失败');
                                        }
                                      });
                                    });
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  VEmptyView(20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        DiscoverPage(),
                        MyPage(),
                      ],
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(110) + Application.bottomBarHeight),
            ),
            PlayWidget(),
          ],
        ),
      ),
    );
  }
}

class MyInfoWidget extends StatefulWidget {

  final Function(String,String,String) submitCallback;

  final String nickName;

  final String picUrl;

  MyInfoWidget({this.submitCallback, this.nickName, this.picUrl});

  @override
  _MyInfoWidgetState createState() => _MyInfoWidgetState();
}

class _MyInfoWidgetState extends State<MyInfoWidget> {
  bool isPrivatePlayList = false;
  TextEditingController _editingNickNameController;
  TextEditingController _editingPasswordController;
  TextEditingController _editingPicUrlController;
  Function(String,String,String) submitCallback;

  @override
  void initState() {
    super.initState();
    _editingNickNameController = TextEditingController();
    _editingNickNameController.text = widget.nickName;
    _editingNickNameController.addListener(() {
      if (_editingNickNameController.text.isEmpty) {
        setState(() {
          submitCallback = null;
        });
      } else {
        setState(() {
          if (submitCallback == null) {
            submitCallback = widget.submitCallback;
          }
        });
      }
    });

    _editingPicUrlController = TextEditingController();
    _editingPicUrlController.text = widget.picUrl;
    _editingPicUrlController.addListener(() {
      if (_editingPicUrlController.text.isEmpty) {
        setState(() {
          submitCallback = null;
        });
      } else {
        setState(() {
          if (submitCallback == null) {
            submitCallback = widget.submitCallback;
          }
        });
      }
    });
    _editingPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '个人信息',
        style: bold16TextStyle,
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
      content: Theme(
        data: ThemeData(primaryColor: Colors.red),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _editingNickNameController,
              decoration: InputDecoration(
                labelText: "昵称",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
              maxLength: 40,
            ),
            TextField(
              controller: _editingPicUrlController,
              decoration: InputDecoration(
                suffixIcon: RoundImgWidget(
                  widget.picUrl,
                  35,
                ),
                labelText: "头像",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
            ),
            TextField(
              controller: _editingPasswordController,
              decoration: InputDecoration(
                labelText: "新密码",
                hintText: "为空则不改变",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
              maxLength: 40,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: (){
            Application.sp.remove("user");
            Navigator.pushNamedAndRemoveUntil(context, Routes.login, ModalRoute.withName('/'));
            },
          child: Text('注销登录'),
          textColor: Colors.red,
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('取消'),
          textColor: Colors.red,
        ),
        FlatButton(
          onPressed: submitCallback == null
              ? null
              : () {
            submitCallback(_editingNickNameController.text, _editingPasswordController.text, _editingPicUrlController.text);
          },
          child: Text('提交'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
