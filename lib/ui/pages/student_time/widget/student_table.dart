import 'package:flutter/material.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/common/pallete.dart';
import 'package:p_student/models/student_time.dart';

class StudentTable extends StatelessWidget {
  const StudentTable({
    super.key,
    required this.size,
    required this.studentTimes,
  });

  final Size size;
  final List<StudentTime> studentTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      // margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Pallete.actionColor,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: size.width * 0.05,
                  child: Text(
                    "STT",
                    style: AppTextStyle.blackS14Bold,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.25,
                  child: Text(
                    "Họ và tên",
                    style: AppTextStyle.blackS14Bold,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.2,
                  child: Text(
                    "Thời gian",
                    style: AppTextStyle.blackS14Bold,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.2,
                  child: Text(
                    "Ngày",
                    style: AppTextStyle.blackS14Bold,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.15,
                  child: Text(
                    "Trạng thái",
                    style: AppTextStyle.blackS14Bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: size.height - 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: studentTimes.length,
              itemBuilder: ((context, index) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.05,
                        child: Text(
                          "${studentTimes[index].stt}",
                          style: AppTextStyle.blackS14Bold,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.25,
                        child: Text(
                          studentTimes[index].name,
                          style: AppTextStyle.blackS14Bold,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: Text(
                          studentTimes[index].time,
                          style: AppTextStyle.blackS14Bold,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.2,
                        child: Text(
                          studentTimes[index].day,
                          style: AppTextStyle.blackS14Bold,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.15,
                        child: Text(
                           "Đi muộn",
                          style: AppTextStyle.blackS14Bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
