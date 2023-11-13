import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/ui/widgets/float_button.dart';
import 'package:p_student/ui/widgets/side_bar.dart';
import 'package:p_student/ui/widgets/student_table.dart';
import 'package:p_student/view_model/student_time_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:slide_switcher/slide_switcher.dart';

class StudentTimePage extends StatelessWidget {
  const StudentTimePage({super.key, required this.className});
  final String className;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentTimeViewModel>(
      create: (_) => StudentTimeViewModel(),
      child: StudentTimeView(
        className: className,
      ),
    );
  }
}

class StudentTimeView extends StatefulWidget {
  const StudentTimeView({super.key, required this.className});

  @override
  State<StudentTimeView> createState() => _StudentTimeState();

  final String className;
}

class _StudentTimeState extends State<StudentTimeView>
    with SingleTickerProviderStateMixin {
  late StudentTimeViewModel viewModel;

  late Animation<double> _animation;
  late AnimationController _animationController;

  SidebarXController controller = SidebarXController(selectedIndex: 0);

  String todayDate =
      DateFormat('EEEE dd/MM/yyyy', 'vi_VN').format(DateTime.now());

  int switcherIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    viewModel = context.read<StudentTimeViewModel>();
    viewModel.processStudentData(widget.className);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "THPT BẮC YÊN THÀNH - LỚP:${widget.className}",
          style: AppTextStyle.blackS20Bold,
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              color: Colors.red,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 40,
          )
        ],
      ),
      drawer: MenuSideBar(controller: controller),

      //Init Floating Action Bubble
      floatingActionButton: FloatingActionCustom(
          animationController: _animationController,
          animation: _animation,
          function: viewModel.filter),

      body: Consumer<StudentTimeViewModel>(builder: (context, view, child) {
        return Container(
          margin: const EdgeInsets.only(top: 16, bottom: 16, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 24,
              // ),
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 4,
                    color: Colors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "DANH SÁCH SINH VIÊN - $todayDate",
                      style: AppTextStyle.blackS24Bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SlideSwitcher(
                    containerBorder: Border.all(color: Colors.blue),
                    // containerBorderRadius: 12,
                    containerColor: const Color.fromARGB(255, 237, 110, 71),
                    onSelect: (int index) {
                      setState(() => switcherIndex = index);
                      if (switcherIndex == 0) {
                        viewModel.filter("all");
                      } else {
                        viewModel.filter("card");
                      }
                    },
                    containerHeight: 32,
                    containerWight: 222,
                    children: [
                      Text(
                        'Điêm danh',
                        style: TextStyle(
                          fontWeight: switcherIndex == 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: switcherIndex == 0
                              ? Colors.deepOrange
                              : Colors.white,
                        ),
                      ),
                      Text(
                        'Thẻ',
                        style: TextStyle(
                          fontWeight: switcherIndex == 1
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: switcherIndex == 1
                              ? Colors.deepOrange
                              : const Color.fromARGB(255, 247, 204, 204),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      viewModel.exportToExcel(widget.className);
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/icons/export_excel_icon.png"),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: StudentTable(
                  size: size,
                  studentTimes: viewModel.filterStudents,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
