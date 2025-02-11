import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../_core/constants/size.dart';

class PostDetailBody extends StatelessWidget {
  final int postId;
  const PostDetailBody({required this.postId});

  @override
  Widget build(BuildContext context) {
    // Future, Stream, State, Notifier
    //PostDetailModel? model = ref.watch(postDetailProvider(postId));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            '게시글 1 (temp)',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          const SizedBox(height: largeGap),
          ListTile(
            title: Text("사용자 이름"),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/1.png', fit: BoxFit.cover),
            ),
          ),
          // 권한 처리 (sessionUser.id == post.user.id ) 같다면 보여 주기
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  // 권한이 있다면 삭제 기능
                },
                icon: Icon(Icons.delete),
              ),
              IconButton(
                onPressed: () {
                  // 수정하기 화면으로 이동 처리
                },
                icon: Icon(CupertinoIcons.pen),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: largeGap),
          SingleChildScrollView(
            child: Text('게시글 내용 표시하기'),
          )
        ],
      ),
    );
  }
}
