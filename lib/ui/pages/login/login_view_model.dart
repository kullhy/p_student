import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p_student/ui/pages/main/main_page.dart';

class LoginViewModel extends ChangeNotifier {
  Future<void> checkLogin(
      {required String username,
      required String password,
      required BuildContext context}) async {
    const apiUrl =
        'https://firestore.googleapis.com/v1/projects/p-care-e73a4/databases/(default)/documents/admin_account';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['documents'] != null && data['documents'].isNotEmpty) {
        final accounts = data['documents'] as List;

        for (final account in accounts) {
          final fields = account['fields'];

          final storedUsername = fields['username']['stringValue'];
          final storedPassword = fields['password']['stringValue'];

          if (storedUsername == username && storedPassword == password) {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
            log('Đăng nhập thành công!');
            return;
          }
        }

        // Không tìm thấy tài khoản trùng khớp
        log('Sai tên đăng nhập hoặc mật khẩu!');
      } else {
        // Không có dữ liệu hoặc lỗi API
        log('Lỗi khi lấy dữ liệu tài khoản!');
      }
    } else {
      // Lỗi khi kết nối đến API
      log('Lỗi kết nối đến API!');
    }
  }
}
