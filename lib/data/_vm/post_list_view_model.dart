// 게시글 목록 화면에서 사용하는 뷰 모델 클래스 이다. + 상태 관리

import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/data/model/post_list.dart';
import 'package:class_f_story/data/repository/post_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../_core/utils/logger.dart';

// 게시글 목록은 회원 가입 이동시, 로그인 페이지 이동시
// 뷰 모델 객체를 계속 가지고 있을 필요가 없다.
// AutoDisposeNotifier 를 사용해야 하는 이유를 알자 !!!!
class PostListViewModel extends AutoDisposeNotifier<PostList?> {
  // 상태관리가 아닌 멤버 변수
  final refreshController = RefreshController();
  final postRepository = const PostRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  PostList? build() {
    logger.d('PostListViewModel 초기화 메서드 호출 완료');

    // 콜백 메서드 등록
    ref.onDispose(() {
      //  PostListViewModel가 메모리에서 내려갈 때 콜백 호출 ...
      // refreshController 도 메모리 해제 처리
      // 메모리 누수 방지
      refreshController.dispose();
    });
    init();

    // 초기값 설정
    return null;
  }

  // 게시글 목을 뿌리는 초기화 작업 - 행위
  // 1. 예외처리
  // 2. API 호출
  // 3. success --> false 처리
  // 3. success --> true 처리 ---> state 갱신
  // 4. refreshController.loadCompleted() 호출 (동그라미 제거)
  Future<void> init() async {
    try {
      Map<String, dynamic> resBody = await postRepository.findAll();
      if (!resBody['success']) {
        // 통신은 성공이지만 내부적으로 오류 본다 --> 적절한 에러 메세지를 던져 줌
        ExceptionHandler.handleException(
            resBody['errorMessage'], StackTrace.current);
        return; // 실행의 제어권 반밥
      }

      // 통신 성공 -->
      state = PostList.fromMap(resBody);

      refreshController.loadComplete();
    } catch (e, stackTrace) {}
  }
}
