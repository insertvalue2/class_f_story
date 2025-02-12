import 'package:class_f_story/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/exception_handler.dart';
import '../model/post_list.dart';
import '../repository/post_repository.dart';

// AutoDisposeNotifier를 사용하여 ViewModel이 자동 해제되도록 설정
class PostListViewModel extends AutoDisposeNotifier<PostList?> {
  final mContext = navigatorkey.currentContext!;
  final PostRepository postRepository = const PostRepository();

  @override
  PostList? build() {
    // 초기 데이터 로드
    init();
    return null;
  }

  // 게시글 목록을 초기화
  Future<void> init() async {
    try {
      Map<String, dynamic> resBody = await postRepository.findAll();
      if (!resBody['success']) {
        ExceptionHandler.handleException(
            resBody['errorMessage'], StackTrace.current);
        return;
      }

      // 상태 업데이트
      state = PostList.fromMap(resBody['response']);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('게시글 목록 로딩 중 오류', stackTrace);
    }
  }

  // 페이징 처리 (다음 게시글 목록 불러오기)
  Future<void> nextList() async {
    if (state == null) return;

    if (state!.isLast) {
      await Future.delayed(Duration(milliseconds: 500));
      return;
    }

    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody['success']) {
      ScaffoldMessenger.of(mContext).showSnackBar(
        SnackBar(content: Text('게시글을 못 불러 왔어요')),
      );
      return;
    }

    PostList prevModel = state!;
    PostList nextModel = PostList.fromMap(responseBody['response']);
    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
  }
}

// Provider 설정 (AutoDisposeNotifier 유지)
final postListProvider =
    NotifierProvider.autoDispose<PostListViewModel, PostList?>(
  () => PostListViewModel(),
);
