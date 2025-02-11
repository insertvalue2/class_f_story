// 뷰 모델을 동적으로 생성해야 한다.
// 동적으로 생성해야 (매개변수 전달 받아서 생성해야 한다 )
import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/data/model/post_detail_model.dart';
import 'package:class_f_story/data/repository/post_repository.dart';
import 'package:class_f_story/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/logger.dart';

class PostDetailViewModel extends AutoDisposeFamilyNotifier<PostDetail?, int> {
  final mContext = navigatorkey.currentContext!;
  PostRepository postRepository = const PostRepository();

  @override
  PostDetail? build(id) {
    // 습관적으로 종료 콜백 리스너 등록을 하자.
    ref.onDispose(
      () => {
        // 자원 해제 처리
        logger.d('PostDetailViewModel 파괴됨')
      },
    );

    init(id); // 초기 값 (API 통신)
    return null;
  }

  Future<void> init(int id) async {
    try {
      Map<String, dynamic> responseBody = await postRepository.findById(id: id);

      if (!responseBody['success']) {
        ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(
            content: Text('게시글 상세보기 실패'),
          ),
        );
        return;
      }
      // 성공이라면
      PostDetail model = PostDetail.fromMap(responseBody['response']);
      state = model;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('게시글 상세보기 오류 발생', stackTrace);
    }
  }

  // 삭제 기능 추가
  Future<void> deleteById(int id) async {
    try {
      Map<String, dynamic> responseBody = await postRepository.delete(id: id);

      if (!responseBody['success']) {
        ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(
            content: Text('게시글 삭제 실패 : ${responseBody['errorMessage']}'),
          ),
        );
        return;
      }
      // 화면 파괴시에 뷰 모델 자동 파괴 됨...
      Navigator.pop(mContext);
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('게시글 상세보기 중 오류 발생', stackTrace);
    }
  }
} // end of 뷰 모델

// 선택된 상세보기 하나당 새로운 상세보기 화면 뷰 모델이 생성이 되고
// 메모리 누수가 발생할 수 있기 때문에 뷰 모델을 파괴 시켜 주어야 한다.
final postDetailProvider =
    NotifierProvider.autoDispose.family<PostDetailViewModel, PostDetail?, int>(
  () {
    return PostDetailViewModel();
  },
);
