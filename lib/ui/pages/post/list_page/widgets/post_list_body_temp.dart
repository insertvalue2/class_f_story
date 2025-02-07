// 로컬 상태 관리 (해당 페이지에서면 변경되는 데이터가 있다)
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostListBodyTemp extends StatefulWidget {
  const PostListBodyTemp({super.key});

  @override
  State<PostListBodyTemp> createState() => _PostListBodyTempState();
}

class _PostListBodyTempState extends State<PostListBodyTemp> {
  // 사용자가 당기기, 사용자가 밑에서 올리기
  // 거기에 맞는 콜백 이벤트 메서드를 호출해야 사용이 가능하다.
  // _refreshController.refreshCompleted() <-- 새로 고침 완료 후 호출
  // loadCompleted() <-- 추가 데이터 로드 완료 후 호출
  RefreshController _refreshController = RefreshController();

  // 샘플 데이터
  List<Map<String, dynamic>> _posts = [
    {'id': 1, 'title': '1 번째 게시글', 'content': '내용 내용 1'},
    {'id': 2, 'title': '2 번째 게시글', 'content': '내용 내용 1'},
    {'id': 3, 'title': '3 번째 게시글', 'content': '내용 내용 1'},
    {'id': 4, 'title': '4 번째 게시글', 'content': '내용 내용 1'},
    {'id': 5, 'title': '5 번째 게시글', 'content': '내용 내용 1'},
    {'id': 6, 'title': '6 번째 게시글', 'content': '내용 내용 1'},
    {'id': 7, 'title': '7 번째 게시글', 'content': '내용 내용 1'},
    {'id': 8, 'title': '8 번째 게시글', 'content': '내용 내용 1'},
    {'id': 9, 'title': '9 번째 게시글', 'content': '내용 내용 1'},
    {'id': 10, 'title': '10 번째 게시글', 'content': '내용 내용 1'},
    {'id': 11, 'title': '11 번째 게시글', 'content': '내용 내용 1'},
    {'id': 12, 'title': '12 번째 게시글', 'content': '내용 내용 1'},
    {'id': 13, 'title': '13 번째 게시글', 'content': '내용 내용 1'},
  ];

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: _onRefresh,
      enablePullUp: true,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${_posts[index]['title']}'),
          subtitle: Text('${_posts[index]['content']}'),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // 통신 가정
    await Future.delayed(Duration(seconds: 1));
    // 데이터가 새로 드러 옴
    setState(() {
      _posts = [
        ..._posts,
        {'id': 14, 'title': '14 번째 게시글', 'content': '내용 내용 1'},
        {'id': 15, 'title': '15 번째 게시글', 'content': '내용 내용 1'},
      ];
    });
    _refreshController.refreshCompleted();
  }

  // 페이징 동작 처리 (무한 스크롤)
  // 사용자가 리스트를 맨 아래로 스크롤 할 때 이벤트 리스너 동작
  // 새로운 데이터를  API 호출해서 상태 갱신을 해 주어야 한다.
  Future<void> _onLoading() async {
    // 통신 가정
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // 기존 있던 이터에 추가로 값을 넣어서 화면 갱신
      // 기존에 데이터 타입 -- 통으로 List 이다.
      // 새로운 API 호출 시 ---> 데이터 타입은 10개 ---. List 이다.
      // 기존에 리스트에서 + 리스트 하는 방법
      // _posts = _post + [];
      _posts.addAll([
        {'id': 21, 'title': '14 번째 게시글', 'content': '내용 내용 1'},
        {'id': 22, 'title': '15 번째 게시글', 'content': '내용 내용 1'},
        {'id': 23, 'title': '14 번째 게시글', 'content': '내용 내용 1'},
        {'id': 24, 'title': '15 번째 게시글', 'content': '내용 내용 1'},
        {'id': 25, 'title': '14 번째 게시글', 'content': '내용 내용 1'},
        {'id': 26, 'title': '15 번째 게시글', 'content': '내용 내용 1'},
        {'id': 27, 'title': '14 번째 게시글', 'content': '내용 내용 1'},
        {'id': 28, 'title': '15 번째 게시글', 'content': '내용 내용 1'},
      ]);
    });
    _refreshController.loadComplete();
  }

  // 화면이 종료 될 때 호출 되는 생명 주기를 가지고 있다.
  // 스트림이 내부적으로 동작을 한다.
  // refreshController 위젯이 제거 될 때 메모리에서 해제를 해야 한다.
  // 왜? 메모리 릭이 발생할 수 있다. (메모리 누수)
  @override
  void dispose() {
    _refreshController.dispose(); // 메모리 해제
    super.dispose();
  }
  // 해제를 안하면
  // 화면을 이동해서 스트림 리스너가 계속 실행된다.
  // 중첩이 되면 메모리가 점점 증가하면서 앱이 느려진다.
}
