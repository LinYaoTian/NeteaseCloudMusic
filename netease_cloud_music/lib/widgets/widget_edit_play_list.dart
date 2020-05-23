import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/model/play_list.dart';
import 'package:netease_cloud_music/model/songlists.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';

import 'common_text_style.dart';

typedef SubmitCallback = Function(String name, String desc, String picUrl);

class EditPlayListWidget extends StatefulWidget {


  final SubmitCallback submitCallback;
  final SongList playlist;

  EditPlayListWidget({@required this.submitCallback, @required this.playlist});

  @override
  _EditPlayListWidgetState createState() => _EditPlayListWidgetState();

}

class _EditPlayListWidgetState extends State<EditPlayListWidget> {
  bool isPrivatePlayList = false;
  TextEditingController _nameTextController;
  TextEditingController _descTextController;
  TextEditingController _editingImageUrlController;
  SubmitCallback _submitCallback;

  @override
  void initState() {
    super.initState();
    _submitCallback = widget.submitCallback;
    _nameTextController = TextEditingController(text: widget.playlist.name);
    _descTextController = TextEditingController(text: widget.playlist.intro ?? "");
    _nameTextController.addListener((){
      if(_nameTextController.text.isEmpty){
        setState(() {
          _submitCallback = null;
        });
      }else{
        if(_submitCallback == null){
          setState(() {
            _submitCallback = widget.submitCallback;
          });
        }
      }
    });
    _editingImageUrlController = TextEditingController();
    _editingImageUrlController.text = widget.playlist.picUrl;
    _editingImageUrlController.addListener((){
      if(_editingImageUrlController.text.isEmpty){
        setState(() {
          _submitCallback = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '更改歌单信息',
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
              controller: _nameTextController,
              decoration: InputDecoration(
                hintText: "请输入歌单标题",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
              maxLength: 40,
            ),
            TextField(
              controller: _descTextController,
              decoration: InputDecoration(
                hintText: "输入歌单描述",
                hintStyle: common14GrayTextStyle,
              ),
              style: common14TextStyle,
            ),
            TextField(
              controller: _editingImageUrlController,
              decoration: InputDecoration(
                hintText: "输入歌单封面",
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
          onPressed: () {
            if(_submitCallback != null){
              _submitCallback(_nameTextController.text, _descTextController.text, _editingImageUrlController.text);
            } else {
              Utils.showToast('歌单名不能为空！');
            }
          },
          child: Text('提交'),
          textColor: Colors.red,
        ),
      ],
    );
  }
}
