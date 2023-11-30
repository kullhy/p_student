import 'package:flutter/material.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/common/pallete.dart';
import 'package:p_student/ui/pages/student_time/student_time_page.dart';

class ClassItem extends StatelessWidget {
  const ClassItem({
    super.key,
    required this.size,
    required this.grade,
    required this.index,
  });

  final Size size;
  final String grade;
  final int index;

  @override
  Widget build(BuildContext context) {
    String className = "${grade}A${index + 1}";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentTimePage(
              className: className,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        height: size.height * 0.1,
        width: size.width * 0.1,
        decoration: BoxDecoration(
          color: Pallete.itemColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Text(
              className,
              style: AppTextStyle.blackS18Bold,
            ),
          ],
        ),
      ),
    );
  }
}
