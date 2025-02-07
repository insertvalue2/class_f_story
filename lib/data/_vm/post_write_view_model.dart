// 글쓰기 화면 뷰 모델
// 화면 클래스에서 관리해야 하는 데이터, 기능을 여기로 옮기자.
// 그리고 상태 관리 까지

import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/_core/utils/my_http.dart';
import 'package:class_f_story/data/repository/post_repository.dart';
import 'package:class_f_story/data/repository/user_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// dto 만들기 싫어서 배웠던 문법 -> 레코드
// 모델 POST 사용해도 되지만 --> 레코드 --> POST(모델 활용)
class PostWriteViewModel
    extends Notifier<(String? title, String? content, bool isWriteCompleted)> {
  // 뷰 모델에서 컨텍스트를 사용하는 방안
  final mContext = navigatorkey.currentContext!;

  PostRepository postRepository = const PostRepository();

  // 상태값을  초기화 해야 된다.
  @override
  (String? title, String? content, bool isWriteCompleted) build() {
    // state == (String? title, String? content, bool isWriteCompleted)
    return (null, null, false);
  }

  // 행위 - 게시글 작성
  // 뷰 모델에서는 기본 데이터 타입 형태로 설계
  // 0. 뷰모델에서 예외처리를 하자 .
  // 1. 데이터 Map 구조로 변환 처리
  // 2. 응답 --> success -- false
  // 3. 응답 --> success -- true
  Future<void> createPost(
      {required String title, required String content}) async {
    try {
      // 데이터 가공 처리
      final body = {"title": title, "content": content};

      Map<String, dynamic> resBody = await postRepository.save(body);
      // Response response = await dio.post('/api/post', data: body);
      // Map<String, dynamic> responseBody = response.data;

      // 2
      if (!resBody['success']) {
        ExceptionHandler.handleException(
            resBody['errorMessage'], StackTrace.current);
        return;
      }

      // 시스템 키보드가 있다면 자동 닫기
      FocusScope.of(mContext).unfocus();

      // 게시글  완성 메세지
      ScaffoldMessenger.of(mContext)
          .showSnackBar(SnackBar(content: Text('게시글 등록 완료')));

      // 상태 갱신 처리
      state = (null, null, true);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('게시글 등록시 오류 발생', stackTrace);
    }
  }
}

// 창고 관리 만들기
final postWriteViewModelProvider = NotifierProvider<
    PostWriteViewModel,
    (
      String? title,
      String? content,
      bool isWriteCompleted
    )>(() => PostWriteViewModel());
