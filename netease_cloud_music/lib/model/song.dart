class Song {
  int id; // 歌曲id
  String name; // 歌曲名称
  String singerName; // 演唱者
  String picUrl; // 歌曲图片
  int singerId;

  Song(this.id, {this.name, this.singerName, this.picUrl, this.singerId});

  Song.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        singerName = json['singer_name'] ?? "暂无",
        singerId = json['singer_id'],
        picUrl = json['pic_url'];

  Song.fromNetJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        singerName = json['singer_name'] ?? '暂无',
        singerId = json['singer_id'],
        picUrl = json['pic_url'];


  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'singer_name': singerName,
        'pic_url': picUrl,
        'singer_id' : singerId
      };

  @override
  String toString() {
    return 'Song{id: $id, name: $name, singerName: $singerName, picUrl: $picUrl, singerId: $singerId}';
  }


}
