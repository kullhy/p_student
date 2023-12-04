import 'package:flutter/material.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/common/pallete.dart';
import 'package:p_student/models/student_time.dart';
import 'package:p_student/ui/pages/student_time/student_time_page.dart';

class ClassItem extends StatefulWidget {
  const ClassItem({
    super.key,
    required this.size,
    required this.grade,
    required this.index, required this.schools,
  });

  final Size size;
  final String grade;
  final int index;
  final List<Map<String, List<StudentTime>>> schools ;


  @override
  State<ClassItem> createState() => _ClassItemState();
}

class _ClassItemState extends State<ClassItem> {
String className = "";
int quantity = 0;
  @override
  void initState() {
    super.initState();
    className = "${widget.grade}A${widget.index + 1}";
    getStudentQuantity();
  }

  void getStudentQuantity(){
    for (var classItem in widget.schools) {
      if(classItem.keys.first==className){
        quantity= classItem.values.first.length;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            height: widget.size.height * 0.1,
            width: widget.size.width * 0.1,
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
         quantity !=0? Positioned(
            right: 0,
            child: Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: const BoxDecoration(shape: BoxShape.circle,color: Colors.red),
              child:  Text(quantity.toString(),style: AppTextStyle.blackS14Bold,),
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }
}
