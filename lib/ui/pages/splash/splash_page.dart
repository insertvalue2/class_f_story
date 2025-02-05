import 'package:class_f_story/_core/utils/exception_handler.dart';
import 'package:class_f_story/_core/utils/my_http.dart';
import 'package:class_f_story/data/gvm/session_gvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ConsumerWidget ---> Stateless
// ConsumerStatefulWidget --> Stateful
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    // 단 한번 실행되는 코드 -> 인스턴스 화 될때
    super.initState();
    // 1. 화면을 렌더링 시키기 전에 로그인 유무 확인 - 메서드
    _checkLoginStates();
  } // end of initState

  // 로그인 상태 확인 후 자동 로그인 시도 또는 로그인 페이지 이동 처리
  // 1. 토큰 추출
  // 2. 토큰 유무 확인 ( 없다면 --> 로그인 페이지 이동 처리)
  // 2 - 1  로그인 페이지 이동 처리 (이미지 2초간 보여주고 이동 시키기 )
  Future<void> _checkLoginStates() async {
    try {
      // I/O
      String? accessToken = await secureStorage.read(key: 'accessToken');
      if (accessToken == null) {
        _navigateToLogin();
        return; // 실행의 제어권 반납
      }
      // accessToken null 아니라면
      SessionGVM sessionGVM = ref.read(sessionProvider.notifier);
      await sessionGVM.autoLogin();
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('자동 로그인 중 오류 발생', stackTrace);
      _navigateToLogin();
    }
  }

  // 로그인 페이지 이동 하는 매서드
  void _navigateToLogin() {
    // 2초 동안 대기 후 로그인 페이지 이동 처리
    Future.delayed(const Duration(seconds: 2), () {
      // mounted --> StatefulWidget 이 가지고 있다.
      // 네이게이션 이동시 mounted 을 확인하는 이유는
      // 1. 사용자가 2초 대기 중에 다른 페이지로 이동하면 이 위젯이 dispose 될 수 있다.
      // 2. disponse 된  위젯을 setState() 또는 Navigator를 호출하면 예외가 발생해서 앱이 종료 될 수 있다.
      // 따라서 mounted 변수는 현재 위젯 화면이 여전히 존재 하는가 여부를 판단 한다.
      // 방어적 코드 작성
      if (mounted) {
        Navigator.popAndPushNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

//
// class SplashPage extends ConsumerStatefulWidget {
//   const SplashPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // 자동 로그인 호출
//     // 단 한번도 로그인을 안했을 경우 --> 2초간 gif 이미지 보여주기
//     // 로그인 한적이 있다면(토큰이 있다면) --> 바로 페이지 이동 처리
//     ref.read(sessionProvider.notifier).autoLogin();
//
//     return Scaffold(
//       body: Center(
//         child: Image.asset(
//           'assets/splash.gif',
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
// }
