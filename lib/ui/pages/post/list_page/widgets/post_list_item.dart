import 'package:flutter/material.dart';

import '../../../../../_core/utils/m_http.dart';
import '../../../../../data/model/post.dart';

class PostListItem extends StatelessWidget {
  Post post;

  PostListItem(this.post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text("${post.title}", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        "${post.content}",
        style: TextStyle(color: Colors.black45),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(50), // 네모난 이미지를 동그랗게 만들기 위한 값 설정
        // child: Image.network('$baseUrl${post.user!.imgUrl}'), // 서버에 이미지가 없음 네모난 이미지
        child: Image.asset('assets${post.user!.imgUrl}'), // 동그란 이미지
      ),
    );
  }
}
