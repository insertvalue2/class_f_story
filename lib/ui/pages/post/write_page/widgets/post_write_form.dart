import 'package:class_f_story/_core/constants/size.dart';
import 'package:class_f_story/data/_vm/post_write_view_model.dart';
import 'package:class_f_story/ui/widgets/custom_elevated_button.dart';
import 'package:class_f_story/ui/widgets/custom_text_area.dart';
import 'package:class_f_story/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostWriteForm extends ConsumerWidget {
  // 폼에 상태/ 유효성 검사 ..save()
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  PostWriteForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // post_write_view_model 만든게 핵심
    // 뷰 모델 상태를 구독
    // (title, content, isWrited...)
    final data = ref.watch(postWriteViewModelProvider);
    // 뷰 모델 행위 사용해야 한다. (뷰 모델 자체 들고 오기)
    final vm = ref.read(postWriteViewModelProvider.notifier);

    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomTextFormField(
            hint: 'title',
            controller: _titleController,
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            hint: 'content',
            controller: _contentController,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
              text: '글쓰기',
              click: () {
                vm.createPost(
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                );
                // 레코드 문법 활용 가능
                if (data.$3 == true) {
                  // 페이지 이동 처리
                  _titleController.clear();
                  _contentController.clear();
                }
              })
        ],
      ),
    );
  }
}
