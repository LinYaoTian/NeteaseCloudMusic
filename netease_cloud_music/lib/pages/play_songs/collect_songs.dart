import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/constans/config.dart';
import 'package:netease_cloud_music/utils/fluro_convert_utils.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/common_text_style.dart';
import 'package:netease_cloud_music/widgets/h_empty_view.dart';
class CollectSongsWidget extends StatefulWidget{

  final CheckBoxSongListData _checkBoxSongListData;

  final int _songId;

  CollectSongsWidget(this._checkBoxSongListData, this._songId);

  @override
  State<StatefulWidget> createState() {
    return _CollectSongsState();
  }
}

class _CollectSongsState extends State<CollectSongsWidget>{

  List<CheckBoxSongList> _checkBoxSongLists;

  @override
  void initState() {
    super.initState();
    _checkBoxSongLists = widget._checkBoxSongListData._checkBoxSongLists ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '收藏此歌曲到歌单',
        style: bold16TextStyle,
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
      content: Theme(
        data: ThemeData(primaryColor: Colors.red),
        child: Container(
          width: ScreenUtil().setWidth(300),
          height: ScreenUtil().setWidth(600),
          child: ListView.builder(
              itemCount: _checkBoxSongLists.length,
              itemExtent: ScreenUtil().setWidth(70),
              itemBuilder: (context, index){
                return _buildCheckBoxSongList(_checkBoxSongLists[index]);
              }),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('取消'),
          textColor: Colors.red,
        ),
        FlatButton(
          onPressed: (){
            NetUtils.postSongCollectStatus(
              context,
              params: {'song_id': widget._songId},
              data: {
                "data": widget._checkBoxSongListData.toJson()
              }).then((v){
              Utils.showToast(v != null && v.code == CODE_OK ? "操作成功！" : "操作失败！");
              Navigator.of(context).pop();
            });
          },
          child: Text('确认'),
          textColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildCheckBoxSongList(CheckBoxSongList data){
    return  GestureDetector(
      onTap: () {
        setState(() {
          data.isCollected = !data.isCollected;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(13),
            bottom: ScreenUtil().setWidth(13),
            right: ScreenUtil().setWidth(10),
            left: ScreenUtil().setWidth(10)
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: Checkbox(
                  activeColor: Colors.red,
                  value: data.isCollected,
                  onChanged: (v) {
                    setState(() {
                      data.isCollected = v;
                    });
                  },
                  materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap),
            ),
            HEmptyView(4),
            Expanded(
              child: Text(
                data.name,
                overflow: TextOverflow.ellipsis,
                style: common15GrayTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

}

class CheckBoxSongListData{
  List<CheckBoxSongList> _checkBoxSongLists;

  CheckBoxSongListData(this._checkBoxSongLists);

  CheckBoxSongListData.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return;
    }
    var data = json['data'];
    if(data == null) {
      return;
    }
    _checkBoxSongLists = new List<CheckBoxSongList>();
    data.forEach((v){
      _checkBoxSongLists.add(CheckBoxSongList.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(_checkBoxSongLists != null){
      data['checkBoxSongLists'] = this._checkBoxSongLists.map((v){
        return v.toJson();
      }).toList();
    }
    return data;
  }


  @override
  String toString() {
    return 'CheckBoxSongListData{_checkBoxSongLists: $_checkBoxSongLists}';
  }

  List<CheckBoxSongList> get checkBoxSongLists => _checkBoxSongLists;

  set checkBoxSongLists(List<CheckBoxSongList> value) {
    _checkBoxSongLists = value;
  }

}

class CheckBoxSongList{
  int _id;
  String _name;
  bool _isCollected;

  CheckBoxSongList(this._id, this._isCollected, this._name);


  @override
  String toString() {
    return 'CheckBoxSongList{_id: $_id, _name: $_name, _isCollected: $_isCollected}';
  }

  CheckBoxSongList.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return;
    }
    _id = json['id'];
    _name = json['name'];
    _isCollected = json['is_collected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['is_collected'] = this._isCollected;
    return data;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool get isCollected => _isCollected;

  set isCollected(bool value) {
    _isCollected = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}