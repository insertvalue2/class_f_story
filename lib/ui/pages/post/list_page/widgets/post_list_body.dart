import 'package:class_f_story/data/_vm/post_list_view_model.dart';
import 'package:class_f_story/data/model/post_list.dart';
import 'package:class_f_story/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:class_f_story/ui/pages/post/list_page/widgets/post_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../_core/utils/logger.dart';

class PostListBody extends ConsumerStatefulWidget {
  const PostListBody({super.key});

  @override
  ConsumerState<PostListBody> createState() => _PostListBodyState();
}

class _PostListBodyState extends ConsumerState<PostListBody> {
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose(); // 화면이 사라질 때 RefreshController 해제
    super.dispose();
  }

  // ConsumerStatefulWidget 변경 하였기 때문에
  // ref.listen() 더이상 메서드가 필요 없음
  @override
  Widget build(BuildContext context) {
    logger.d('PostListBody 를 재 갱신 처리');
    PostList? model = ref.watch(postListProvider);
    PostListViewModel vm = ref.read(postListProvider.notifier);

    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SmartRefresher(
        controller: _refreshController, // RefreshController를 View에서 관리
        enablePullUp: true,
        enablePullDown: true,
        onRefresh: () async {
          await vm.init();
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          await vm.nextList();
          _refreshController.loadComplete();
        },
        child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostDetailPage(postId: model.posts[index].id!),
                      ),
                    );
                  },
                  child: PostListItem(model.posts[index]),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: model.posts.length),
      );
    }
  }
}
