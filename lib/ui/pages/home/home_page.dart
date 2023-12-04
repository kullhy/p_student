import 'package:flutter/material.dart';
import 'package:p_student/common/app_text_styles.dart';
import 'package:p_student/ui/pages/home/class_item.dart';
import 'package:p_student/ui/pages/home/home_vm.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return HomeVM();
      },
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final _viewModel = context.read<HomeVM>();

  @override
  void initState() {
    super.initState();
    _viewModel.getAllClass();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<HomeVM>(
        builder: (context,viewModel,child) {
          if(viewModel.isLoading==true){
            return const Center(child: CircularProgressIndicator());
          } else{
            return Container(
            margin: const EdgeInsets.only(top: 16, bottom: 16, right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/app_logo.png",
                      height: size.height * 0.1,
                      width: size.height * 0.1,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sở giáo dục và đào tạo tỉnh Nghệ An",
                          style: AppTextStyle.blackS18Bold,
                        ),
                        Text(
                          "T H P T   B Ắ C   Y Ê N   T H À N H",
                          style: AppTextStyle.blackS24Bold,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        "KHỐI 10",
                        style: AppTextStyle.blackS24Bold,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: size.height * 0.1,
                    width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ClassItem(
                          size: size,
                          grade: "10",
                          index: index,
                          schools: _viewModel.schools,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        "KHỐI 11",
                        style: AppTextStyle.blackS24Bold,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: size.height * 0.1,
                    width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ClassItem(
                          size: size,
                          grade: "11",
                          index: index,
                          schools: _viewModel.schools,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        "KHỐI 12",
                        style: AppTextStyle.blackS24Bold,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: size.height * 0.1,
                    width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ClassItem(
                          size: size,
                          grade: "12",
                          index: index,
                          schools: _viewModel.schools,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _viewModel.exportExcel();
                  },
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset("assets/icons/export_excel_icon.png"),
                        ),
                        const SizedBox(width: 12),
                        const Text("Xem tất cả")
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
          }
        }
      ),
    );
  }
}
