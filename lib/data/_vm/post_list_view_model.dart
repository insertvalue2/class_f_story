// 게시글 목록 화면에서 사용하는 뷰 모델 클래스 이다. + 상태 관리

import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/data/model/post_list.dart';
import 'package:class_f_story/data/repository/post_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../_core/utils/logger.dart';

// 게시글 목록은 회원 가입 이동시, 로그인 페이지 이동시
// 뷰 모델 객체를 계속 가지고 있을 필요가 없다.
// AutoDisposeNotifier 를 사용해야 하는 이유를 알자 !!!!
class PostListViewModel extends AutoDisposeNotifier<PostList?> {
  // RefreshController 사용하기로 함
  final refreshController = RefreshController();
  final mContext = navigatorkey.currentContext!;
  final PostRepository postRepository = const PostRepository();

  // 리버팟 2  - (Notifier)
  @override
  PostList? build() {
    // 상태 초기화 코드
    // 해야될 일 1. -> 콜백 메서드 등록 (메모리 해제 등록)
    // onDispose 콜백 등록
    ref.onDispose(
      () {
        logger.d("PostListViewModel 파괴시 실행됨");
        refreshController.dispose(); // 가비지컬렉션이 바로 일어나지 않으니까!!
      },
    );
    // 초기 init 메서드 호출
    // API 통신 요청 처리
    init();

    return null;
  }

  Future<void> init() async {
    try {
      // findAll -  {int page = 0}
      Map<String, dynamic> resBody = await postRepository.findAll();
      if (!resBody['success']) {
        ExceptionHandler.handleException(
            resBody['errorMessage'], StackTrace.current);
        return;
      }
      // 상태 변경 (깊은 복사)
      state = PostList.fromMap(resBody['response']);

      // RefreshController 콜백 메서드 호출
      refreshController.refreshCompleted();
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('게시글 목록 로딩 중 오류', stackTrace);
    }
  }

  // 페이징 처리 하는 로직 10 개 받은 상태이다. -->
  // 1. 현재 상태값 가져오기 state
  // 2. 마지막 페이지 여부를 확인 (
  // 3. 서버에서 다음 페이지 요청 (0 --> 현재페이지 + 1)
  // 4. 서버 응답 실패, 성공 여부 처리
  // 5. 성공했다면 기존에 데이터에 + API 를 추가 해주면 된다.
  // 6. 프로그래스바 종료 처리
  Future<void> nextList() async {
    PostList model = state!;

    // 마지막 페이지가 true 라면
    if (model.isLast) {
      // UX 개선을 위해 딜레이 추가
      await Future.delayed(Duration(milliseconds: 500));
      refreshController.loadComplete(); // UI 갱신
      return;
    }

    // API 통신 요청
    Map<String, dynamic> responseBody =
        await postRepository.findAll(page: state!.pageNumber + 1);

    if (!responseBody['success']) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text('게시글을 못 불러 왔어요')),
      );
      return;
    }

    // 통신이 성공 이라면
    PostList prevModel = state!;
    PostList nextModel = PostList.fromMap(responseBody['response']);
    state = nextModel.copyWith(posts: [...prevModel.posts, ...nextModel.posts]);
    refreshController.loadComplete();
  }
}

// 창고 관리자 ( 창고 규격)
final postListProvider =
    NotifierProvider.autoDispose<PostListViewModel, PostList?>(
  () => PostListViewModel(),
);
