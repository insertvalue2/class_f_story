import 'package:flutter/material.dart';

import 'widgets/post_detail_body.dart';

class PostDetailPage extends StatelessWidget {
  int postId;
  PostDetailPage({required this.postId, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: PostDetailBody(
          postId: postId,
        ),
      ),
    );
  }
}
