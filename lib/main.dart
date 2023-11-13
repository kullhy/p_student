// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p_student/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'vi_VN';
  if (Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setFullScreen(true);

    await DesktopWindow.setMinWindowSize(const Size(1200, 700));
  } else if (Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(const Size(1200, 700));
    await DesktopWindow.setFullScreen(true);
  }
  runApp(const MyApp());
}
