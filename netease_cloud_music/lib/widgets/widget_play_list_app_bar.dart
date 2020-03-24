import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/utils/net_utils.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/widget_music_list_header.dart';

import 'flexible_detail_bar.dart';

class PlayListAppBarWidget extends StatelessWidget {
  final double expandedHeight;
  final Widget content;
  final String backgroundImg;
  final String title;
  final double sigma;
  final PlayModelCallback playOnTap;
  final int count;
  final bool isCollected;
  final Function() clickCollect;

  PlayListAppBarWidget({
    @required this.expandedHeight,
    @required this.content,
    @required this.title,
    @required this.backgroundImg,
    this.sigma = 5,
    this.playOnTap,
    this.count,
    @required this.isCollected,
    @required this.clickCollect
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      expandedHeight: expandedHeight,
      pinned: true,
      elevation: 0,
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      bottom: MusicListHeader(
        onTap: playOnTap,
        count: count,
        tail: CollectWidget(isCollected: isCollected, clickCollect: clickCollect,),
      ),
      flexibleSpace: FlexibleDetailBar(
        content: content,
        background: Stack(
          children: <Widget>[
            backgroundImg.startsWith('http')
                ? Utils.showNetImage(
                    '$backgroundImg?param=200y200',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    backgroundImg,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: sigma,
                sigmaX: sigma,
              ),
              child: Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectWidget extends StatefulWidget{

  bool isCollected = false;

  Function() clickCollect;

  CollectWidget({this.isCollected, this.clickCollect});

  @override
  State<StatefulWidget> createState() {
    return _CollectState();
  }}

class _CollectState extends State<CollectWidget>{

  bool isCollected = false;

  @override
  void initState() {
    super.initState();
    isCollected = widget.isCollected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
        child: Image.asset(
            isCollected ? 'images/like.png' : 'images/dislike.png',
            height: ScreenUtil().setWidth(60),
            width: ScreenUtil().setWidth(60)),),
      onTap: (){
        widget.clickCollect();
        setState((){
          isCollected = !isCollected;
        });
      },
    );
  }

}
