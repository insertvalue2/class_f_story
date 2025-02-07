import 'package:class_f_story/ui/pages/post/write_page/widgets/post_write_body.dart';
import 'package:flutter/material.dart';

class PostWritePage extends StatelessWidget {
  const PostWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostWriteBody(),
    );
  }
}
