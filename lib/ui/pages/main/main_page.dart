import 'package:flutter/material.dart';
import 'package:p_student/common/pallete.dart';
import 'package:p_student/ui/pages/home/home_page.dart';
import 'package:p_student/ui/widgets/side_bar.dart';
import 'package:sidebarx/sidebarx.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SidebarXController controller = SidebarXController(selectedIndex: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      body: Row(
        children: [
          MenuSideBar(controller: controller),
          const Expanded(child: HomePage())
        ],
      ),
    );
  }
}
