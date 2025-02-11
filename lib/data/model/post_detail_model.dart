// 게시글 상세보기 담기 위한 모델
import 'package:class_f_story/data/model/post.dart';

class PostDetail {
  Post post;

  PostDetail({required this.post}); // 포함관계 설계

  PostDetail copyWith({Post? post}) {
    return PostDetail(post: post ?? this.post);
  }

  PostDetail.fromMap(Map<String, dynamic> map) : post = Post.fromMap(map);
}
