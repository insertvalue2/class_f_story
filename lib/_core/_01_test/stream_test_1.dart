import 'dart:async';

// Future<T> 한 번만 실행되고 완료되는 작업
// Stream<T> 여러 개의 데이터를 순차적으로 계속 전달해서 사용할 수 있다.
void main() async {
  // HOW
  // 데이터를 보내는 역할
  Stream<int> numberStream() async* {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  // 스트림을 구독해 보자 (데이터를 받음)
  await for (var number in numberStream()) {
    print('스트림 수신 : $number');
  }
  // ,,,,
}
