import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netease_cloud_music/utils/navigator_util.dart';
import 'package:netease_cloud_music/utils/utils.dart';
import 'package:netease_cloud_music/widgets/widget_round_img.dart';

import 'common_text_style.dart';
import 'h_empty_view.dart';

class SingersWidget extends StatelessWidget {
  final String picUrl;
  final String name;
  final int accountId;

  const SingersWidget({Key key, this.picUrl, this.name, this.accountId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
      child: InkWell(
        child: Row(
          children: <Widget>[
            RoundImgWidget(
              '$picUrl?param=150y150',
              120,
              fit: BoxFit.cover,
            ),
            HEmptyView(10),
            Text(name),
          ],
        ),
        onTap: (){
          NavigatorUtil.goSingerPage(context, singerId: accountId);
        },
      ),
    );
  }
}
