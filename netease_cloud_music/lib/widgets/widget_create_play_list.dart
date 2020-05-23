import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';

import 'common_text_style.dart';

typedef SubmitCallback = Function(String name, String intro, String imageUrl);

class CreatePlayListWidget extends StatefulWidget {
  final SubmitCallback submitCallback;

  CreatePlayListWidget({@required this.submitCallback});

  @override
  _CreatePlayListWidgetState createState() => _CreatePlayListWidgetState();
}

class _CreatePlayListWidgetState extends State<CreatePlayListWidget> {
  bool isPrivatePlayList = false;
  TextEditingController _editingTitleController;
  TextEditingController _editingIntroController;
  TextEditingController _editingImageUrlController;
  SubmitCallback submitCallback;

  @override
  void initState() {
    super.initState();
    _editingTitleController = TextEditingController();
    _editingTitleController.addListener(() {
      if (_editingTitleController.text.isEmpty) {
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
    _editingIntroController = TextEditingController();
    _editingImageUrlController = TextEditingController();
    _editingImageUrlController.text = "http://p1.music.126.net/GASFmKgo4lA3INFN5Az-6w==/109951164155929328.jpg";
    _editingImageUrlController.addListener((){
      if(_editingImageUrlController.text.isEmpty){
        setState(() {
          submitCallback = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '新建歌单',
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
              controller: _editingTitleController,
              decoration: InputDecoration(
                hintText: "请输入歌单标题",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
              maxLength: 40,
            ),
            TextField(
              controller: _editingIntroController,
              decoration: InputDecoration(
                hintText: "请输入歌单简介",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
              maxLength: 40,
            ),
            TextField(
              controller: _editingImageUrlController,
              decoration: InputDecoration(
                hintText: "请输入歌单封面",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('取消'),
          textColor: Colors.red,
        ),
        FlatButton(
          onPressed: submitCallback != null ? () {
            if(submitCallback != null) {
              submitCallback(_editingTitleController.text, _editingIntroController.text, _editingImageUrlController.text);
            } else {
              Utils.showToast('歌单名不能为空！');
            }
          } : null,
          child: Text('提交'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
