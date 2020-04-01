class SongCommentData {
  int code;
  List<Comment> comments = [];

  SongCommentData({
    this.code,
    this.comments,
  });

  SongCommentData.fromNetJson(Map<String, dynamic> json) {
    if(json == null) {
      return;
    }
    code = json['code'];
    var data = json['data'];
    if (data != null) {
        comments = [];
        data.forEach((v) {
          comments.add(new Comment.fromJson(v));
        });
    }

    Map<String, dynamic> toJson(){
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['code'] = code;
      if (this.comments != null) {
        data['comments'] = this.comments.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}

class Comment{
  int id;
  int userId;
  String picUrl;
  String nickname;
  int time;
  String content;

  @override
  String toString() {
    return 'Comment{id: $id, userId: $userId, picUrl: $picUrl, nickname: $nickname, time: $time, content: $content}';
  }

  Comment.name({this.userId, this.picUrl, this.nickname, this.time,
      this.content,this.id});

  Comment.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    userId = data['user_id'];
    nickname = data['nickname'];
    picUrl = data['pic_url'];
    time = data['time'];
    content = data['content'];
  }

  Comment.fromNetJson(Map<String, dynamic> json) {
    var data = json['data'];
    if(data != null) {
      id = data['id'];
      userId = data['userId'];
      nickname = data['nickname'];
      picUrl = data['pic_url'];
      time = data['time'];
      content = data['content'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['nickname'] = nickname;
    data['pic_url'] = picUrl;
    data['time'] = time;
    data['content'] = content;
    data['id'] = id;
    return data;
  }

}
