import 'package:class_f_story/_core/constants/size.dart';
import 'package:class_f_story/data/gvm/session_gvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/_vm/post_list_view_model.dart';

class CustomDrawer extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomDrawer(this.scaffoldKey, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 뷰 모델 들고 오기
    SessionGVM vm = ref.read(sessionProvider.notifier);
    return Container(
      height: double.infinity,
      width: getDrawerWidth(context),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                // 기능1 -> Drawer 닫고
                // 기능2 -> 글쓰기 페이지로 이동
                scaffoldKey.currentState!.openEndDrawer();
                // 글쓰기 페이지 이동 처리
                Navigator.pushNamed(context, '/post/write');
              },
              child: Text(
                '글쓰기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () async {
                await vm.logout();
              },
              child: Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
