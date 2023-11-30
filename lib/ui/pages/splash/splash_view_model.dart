import 'package:flutter/material.dart';
import 'package:p_student/ui/pages/login/login_page.dart';

class SplashViewModel extends ChangeNotifier {
  void checkLogin(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }
}
