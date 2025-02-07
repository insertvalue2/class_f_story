class User {
  int? id;
  String? username;
  String? imgUrl;

  // 네임드 컨스트럭터
  User.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.username = map["username"],
        this.imgUrl = map["imgUrl"];
}
