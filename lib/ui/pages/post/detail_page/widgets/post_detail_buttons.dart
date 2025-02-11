import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../../data/_vm/post_detail_view_model.dart';
import '../../../../../data/gvm/session_gvm.dart';
import '../../../../../data/model/post.dart';
import '../../../../../data/model/session_user.dart';

class PostDetailButtons extends ConsumerWidget {
  Post post;

  PostDetailButtons(this.post);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionUser sessionUser = ref.read(sessionProvider);

    // family일때는 1번으로 창고가 만들어지면, 다시 1번을 창고 만들면 SingleTone
    PostDetailViewModel vm = ref.read(postDetailProvider(post.id!).notifier);

    if (sessionUser.id == post.user!.id!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              vm.deleteById(post.id!);
            },
            icon: const Icon(CupertinoIcons.delete),
          ),
          IconButton(
            onPressed: () {
              // TODO - 업데이트 기능 직접 만들어 보기
              // 수정하는 기능 추가 (직접 만들어 보기) - 도전
            },
            icon: const Icon(CupertinoIcons.pen),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
