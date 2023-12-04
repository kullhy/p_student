import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/ui/pages/student_time/student_time_view_model.dart';
import 'package:p_student/ui/pages/student_time/widget/student_table.dart';
import 'package:p_student/ui/widgets/side_bar.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';


class StudentTimePage extends StatelessWidget {
  const StudentTimePage({super.key, required this.className});
  final String className;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {return StudentTimeViewModel();} ,
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
  late StudentTimeViewModel _viewModel;

  late Animation<double> animation;
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
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    _viewModel = context.read<StudentTimeViewModel>();
    _viewModel.processStudentData(widget.className);
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
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _viewModel.exportToExcel(widget.className);
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
                child: Consumer<StudentTimeViewModel>(
                  builder: (context,viewModel,child) {
                    if(viewModel.studentLate.isEmpty && viewModel.isLoading){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(viewModel.studentLate.isEmpty && !viewModel.isLoading){
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Không tìm thấy học sinh đi muộn",style: AppTextStyle.blackS24W700,),
                          IconButton(onPressed: (){
                            viewModel.processStudentData(widget.className);
                          }, icon: const Icon(Icons.replay_outlined)),
                        ],
                      );
                    } else{
                     return  StudentTable(
                      size: size,
                      studentTimes: viewModel.studentLate,
                    );
                    }
                  }
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
