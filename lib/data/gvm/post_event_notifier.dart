// 1. 게시글 이벤트의 정의
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PostAction {
  none, // 아무런 이벤트로 발생하지 않음
  created, // 게시글 생성 이벤트 정의
  updated, // 게시글 수정 이벤트 정의
  deleted, // 게시글 삭제 이벤트 저의
}

// 2. 이벤트 노티파이어 생성
class PostEventNotifier extends Notifier<PostAction> {
  @override
  PostAction build() {
    // 초기값 설정
    return PostAction.none;
  }

  // 행위 설계해 보자.
  void postCreate() {
    state = PostAction.created;
  }

  void postUpdated() => state = PostAction.updated;
  void postDeleted() => state = PostAction.deleted;
  // 이벤트 처리 후 상태를 초기화 하는 코드 (중복 이벤트 방지)
  void reset() => state = PostAction.none;
}

// 3. 이벤트 프로바이더 생성
final postEventProvider = NotifierProvider<PostEventNotifier, PostAction>(
  () {
    return PostEventNotifier();
  },
);
