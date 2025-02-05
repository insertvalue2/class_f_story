import 'package:class_f_story/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatelessWidget {
  // scaffoldKey 는 Scaffold 의 상태를 전역적으로 제어하기 위한 키 입니다.
  // 이 키를 사용하여 Scaffold의 상태(열기/닫기) 를 제어할 수 있음
  // 즉, Drawer를 사용자 이벤트 대신 코드를 통해서 열고 닫기 할 수 있음
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 키 설정
        key: scaffoldKey,
        // 하위 위젯에 키 전달
        drawer: CustomDrawer(scaffoldKey),
        appBar: AppBar(
          title: Text('f-story'),
        ),
      ),
    );
  }
}
