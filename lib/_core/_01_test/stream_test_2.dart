import 'dart:async';

// async* + yield 간단한 스트림 생성
// StreamController 조금 복잡한 스트림 생성할 때 사용할 수 있다.
void main() async {
  // 1. 스트림 컨트롤러 생성
  StreamController<String> streamController = StreamController();

  // 청취 <--- 대기 <-- 이번트 리스너 등록
  // streamController.stream.listen((event) {
  //   // 어떤 일을 수행 해
  //   print('event 확인 : ${event}');
  // });

  streamController.stream.listen(
    (event) {
      // 어떤 일을 수행 해
      print('event 확인 : ${event}');
    },
    onError: (error) {
      print('오류 발생');
    },
    onDone: () {
      print('스트림이 종료 되었습니다.');
    },
  );

  // 스트림을 통해서 이벤트를 전달해 보자.
  await Future.delayed(Duration(seconds: 1));
  streamController.add('나의 데이터 1 ');

  await Future.delayed(Duration(seconds: 1));
  streamController.add('나의 데이터 2 ');

  await Future.delayed(Duration(seconds: 1));
  streamController.add('나의 데이터 3 ');

  // 스트림 종료를 시켜 주어야 메모리 누수를 방지할 수 있다.
  await Future.delayed(Duration(seconds: 1));
  await streamController.close();
}
